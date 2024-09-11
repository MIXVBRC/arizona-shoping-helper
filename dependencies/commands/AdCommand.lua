local this = {}
function this:new(_base, _name, _default, _minmax)
    local class = {}
    local private = {
        ['name'] = _name,
        ['pushing'] = false,
        ['id'] = nil,
        ['shop'] = nil,
        ['minmax'] = _base:getNewClass('minMax', _minmax),
        ['configManager'] = _base:getNewClass('configManager', _name, _default),
        ['dependencies'] = {
            
        },
    }

    -- TODO: вместо 1 сообщения сделать возможность отправки нескольких сообщений в виде очереди (разнообразие)
    -- TODO: сделать возможность шаблонизирования сообщения
    -- TODO: добавить защиту от случайного пуша в чат рекламного сообщения, чтобы не дали мут
    -- TODO: в DialogManager добавить события для диалогов VR и AD и остальных, если есть
    -- TODO: для каждого чата сделать возможность персонального текста сообщения
    -- TODO: добавить рекламу в AD, Семью, Альянс

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:setActive(bool)
        private.configManager:set('active', bool)
        return class
    end

    function private:toggleActive()
        private:setActive(not private:isActive())
        return class
    end

    -- MESSAGE

    function private:getMessage()
        return private.configManager:get('message') or ''
    end

    function private:setMessage(message)
        private.configManager:set('message', message or '')
        return class
    end

    -- TIME

    function private:getTime()
        return private.configManager:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.configManager:set('time', private.minmax:get(time, 'time'))
        return class
    end

    -- CHATS

    function private:getChats()
        return private.configManager:get('chats') or {}
    end

    function private:setChats(chats)
        private.configManager:set('chats', chats or {})
        return class
    end

    function private:getChat(name)
        for _, chat in ipairs(private:getChats()) do
            if name == chat.name then
                return chat
            end
        end
        return nil
    end

    function private:setChat(name, bool)
        local chats = private:getChats()
        for _, chat in ipairs(chats) do
            if name == chat.name then
                chat.active = bool
            end
        end
        private:setChats(chats)
        return class
    end

    function private:toggleChat(name)
        local chats = private:getChats()
        for _, chat in ipairs(chats) do
            if name == chat.name then
                chat.active = not chat.active
            end
        end
        private:setChats(chats)
        return class
    end

    -- PUSH AT

    function private:getPushAt()
        return private.configManager:get('pushAt') or 0
    end

    function private:setPushAt(time)
        private.configManager:set('pushAt', math.abs(time or 0))
        return class
    end

    -- PUSHING

    function private:isPushing()
        return private.pushing
    end

    function private:setPushing(bool)
        private.pushing = bool
        return class
    end

    -- ID

    function private:getId()
        return private.id
    end

    function private:setId(id)
        private.id = id
        return class
    end

    -- SHOP

    function private:getShop()
        return private.shop
    end

    function private:setShop(shop)
        private.shop = shop
        return class
    end

    -- LOGIC

    function private:getRemainingTime()
        return math.ceil((private:getPushAt() - os.time()) / 60)
    end

    -- INITS

    function private:init()
        if _base:getClass(private:getName()) ~= nil then
            return _base:getClass(private:getName())
        end
        private:initCommands():initEvents():initThreads()
        return class
    end

    function private:initCommands()
        _base:getClass('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'push'}, function ()
            private:setPushAt(0)
        end)
        :add({private:getName(), 'message'}, function (message)
            private:setMessage(message)
        end)
        :add({private:getName(), 'time'}, function (time)
            time = _base:getClass('helper'):getNumber(time)
            if private:getPushAt() > 0 then
                private:setPushAt(private:getPushAt() - (private:getTime() - time) * 60)
            end
            private:setTime(time)
        end)
        :add({private:getName(), 'left'}, function ()
            if not private:isActive() then
                _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_push_error_active'))
            end
            if private:getMessage() == '' then
                _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_push_error_message'))
            end
            if private:getId() == nil then
                _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_push_error_number'))
            end
            _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_next_push_time', {
                private:getRemainingTime()
            }))
        end)
        for _, chat in ipairs(private:getChats()) do
            _base:getClass('commandManager'):add({private:getName(), 'active', chat.name}, function ()
                private:toggleChat(chat.name)
            end)
        end
        return private
    end

    function private:initEvents()
        _base:getClass('eventManager')
        :add(
            'onEnterShopAdmining',
            function (shop, id)
                private:setId(id)
                private:setShop(shop)
            end
        )
        :add(
            'onShowDialog',
            function (id)
                if private:isPushing() then
                    _base:getClass('dialogManager'):send(id, 1)
                    private:setPushing(false)
                    return false
                end
            end,
            1000
        )
        return private
    end

    function private:initThreads()
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(1000)
                    if private:isActive() and not _base:getClass('dialogManager'):isOpened() and not _base:getClass('playerManager'):isShoping() and not _base:getClass('playerManager'):isAdmining() then
                        if private:getPushAt() <= os.time() then
                            private:setPushAt(os.time() + private:getTime() * 60)
                            if private:getMessage() ~= '' and private:getId() ~= nil then
                                local data = {
                                    private:getId(),
                                    private:getMessage()
                                }
                                local message = ''
                                if private:getShop() ~= nil and private:getShop():isCentral() then
                                    message = _base:getClass('message'):get('message_ad_push_central_market', data)
                                else
                                    message = _base:getClass('message'):get('message_ad_push', data)
                                end
                                for _, chat in ipairs(private:getChats()) do
                                    if chat.active then
                                        private:setPushing(true)
                                        _base:getClass('chat'):push(message)
                                        -- sampProcessChatInput(_base:getClass('helper'):implode(' ', {'/'..chat.name, message}))
                                        wait(500)
                                    end
                                end
                            else
                                if private:getMessage() == '' then
                                    _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_push_error_message'))
                                elseif private:getId() == nil then
                                    _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_push_error_number'))
                                end
                            end
                            _base:getClass('chat'):push(_base:getClass('message'):get('message_ad_next_push_time', {
                                private:getRemainingTime()
                            }))
                            private:setPushing(false)
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return this