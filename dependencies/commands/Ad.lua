local class = {}
function class:new(_command, _default, _minmax)
    local public = {}
    local private = {
        ['pushing'] = false,
        ['id'] = nil,
        ['shop'] = nil,
        ['minmax'] = _sh.dependencies.minMax:new(_minmax),
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
        return public
    end

    -- MESSAGE

    function private:getMessage()
        return private.configManager:get('message') or ''
    end

    function private:setMessage(message)
        private.configManager:set('message', message or '')
        return public
    end

    -- TIME

    function private:getTime()
        return private.configManager:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.configManager:set('time', private.minmax:get(time, 'time'))
        return public
    end

    -- CHATS

    function private:getChats()
        return private.configManager:get('chats') or {}
    end

    function private:setChats(chats)
        private.configManager:set('chats', chats or {})
        return public
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
        return public
    end

    function private:toggleChat(name)
        local chats = private:getChats()
        for _, chat in ipairs(chats) do
            if name == chat.name then
                chat.active = not chat.active
            end
        end
        private:setChats(chats)
        return public
    end

    -- PUSH AT

    function private:getPushAt()
        return private.configManager:get('pushAt') or 0
    end

    function private:setPushAt(time)
        private.configManager:set('pushAt', math.abs(time or 0))
        return public
    end

    -- PUSHING

    function private:isPushing()
        return private.pushing
    end

    function private:setPushing(bool)
        private.pushing = bool
        return public
    end

    -- ID

    function private:getId()
        return private.id
    end

    function private:setId(id)
        private.id = id
        return public
    end

    -- SHOP

    function private:getShop()
        return private.shop
    end

    function private:setShop(shop)
        private.shop = shop
        return public
    end

    -- LOGIC

    function private:getRemainingTime()
        return math.ceil((private:getPushAt() - os.time()) / 60)
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initEvents()
        private:initThreads()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('message', function (message)
            private:setMessage(message)
        end)
        private.commandManager:add('time', function (time)
            time = _sh.helper:getNumber(time)
            if private:getPushAt() > 0 then
                private:setPushAt(private:getPushAt() - (private:getTime() - time) * 60)
            end
            private:setTime(time)
        end)
        for _, chat in ipairs(private:getChats()) do
            private.commandManager:add({'active', chat.name}, function ()
                private:toggleChat(chat.name)
            end)
        end
        private.commandManager:add('left', function ()
            _sh.chat:push(_sh.message:get('message_ad_next_push_time', {
                private:getRemainingTime()
            }))
        end)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onEnterShopAdmining',
            function (shop, id)
                private:setId(id)
                private:setShop(shop)
            end
        )
        _sh.eventManager:add(
            'onShowDialog',
            function (id)
                if private:isPushing() then
                    _sh.dialogManager:send(id, 1)
                    private:setPushing(false)
                    return false
                end
            end,
            1000
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(1000)
                    if private:isActive() and not _sh.dialogManager:isOpened() and not _sh.player:isShoping() and not _sh.player:isAdmining() then
                        if private:getMessage() ~= '' and private:getPushAt() <= os.time() and private:getId() ~= nil then
                            local data = {
                                private:getId(),
                                private:getMessage()
                            }
                            local message = ''
                            if private:getShop() ~= nil and private:getShop():isCentral() then
                                message = _sh.message:get('message_ad_push_central_market', data)
                            else
                                message = _sh.message:get('message_ad_push', data)
                            end
                            for _, chat in ipairs(private:getChats()) do
                                if chat.active then
                                    private:setPushing(true)
                                    sampProcessChatInput(_sh.helper:implode(' ', {'/'..chat.name, message}))
                                    wait(1000)
                                end
                            end
                            private:setPushAt(os.time() + private:getTime() * 60)
                            private:setPushing(false)
                            _sh.chat:push(_sh.message:get('message_ad_next_push_time', {
                                private:getRemainingTime()
                            }))
                        end
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class