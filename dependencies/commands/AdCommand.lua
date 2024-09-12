local this = {}
function this:new(_base, _name, _default, _minmax)
    local class = {}
    local private = {
        ['name'] = _name,
        ['pushing'] = false,
        ['id'] = nil,
        ['shop'] = nil,
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- TODO: ������ 1 ��������� ������� ����������� �������� ���������� ��������� � ���� ������� (������������)
    -- TODO: ������� ����������� ���������������� ���������
    -- TODO: �������� ������ �� ���������� ���� � ��� ���������� ���������, ����� �� ���� ���
    -- TODO: � DialogManager �������� ������� ��� �������� VR � AD � ���������, ���� ����
    -- TODO: ��� ������� ���� ������� ����������� ������������� ������ ���������
    -- TODO: �������� ������� � AD, �����, ������

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:setActive(bool)
        private.config:set('active', bool)
        return class
    end

    function private:toggleActive()
        private:setActive(not private:isActive())
        return class
    end

    -- MESSAGE

    function private:getMessage()
        return private.config:get('message') or ''
    end

    function private:setMessage(message)
        private.config:set('message', message or '')
        return class
    end

    -- TIME

    function private:getTime()
        return private.config:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.config:set('time', private.minmax:get(time, 'time'))
        return class
    end

    -- CHATS

    function private:getChats()
        return private.config:get('chats') or {}
    end

    function private:setChats(chats)
        private.config:set('chats', chats or {})
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
        return private.config:get('pushAt') or 0
    end

    function private:setPushAt(time)
        private.config:set('pushAt', math.abs(time or 0))
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
        local time = math.ceil((private:getPushAt() - os.time()) / 60)
        if time < 0 then
            time = 0
        end
        return time
    end

    function private:checkChats()
        for _, chat in ipairs(private:getChats()) do
            if chat.active then
                return true
            end
        end
        return false
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initEvents():initThreads()
        return class
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'push'}, function ()
            private:setPushAt(0)
        end)
        :add({private:getName(), 'message'}, function (message)
            private:setMessage(message)
        end)
        :add({private:getName(), 'time'}, function (time)
            time = _base:get('helper'):getNumber(time)
            if private:getPushAt() > 0 then
                private:setPushAt(private:getPushAt() - (private:getTime() - time) * 60)
            end
            private:setTime(time)
        end)
        :add({private:getName(), 'left'}, function ()
            if not private:isActive() then
                _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_active'))
            end
            if not private:checkChats() then
                _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_chats'))
            end
            if private:getMessage() == '' then
                _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_message'))
            end
            if private:getId() == nil then
                _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_number'))
            end
            _base:get('chat'):push(_base:get('message'):get('message_ad_next_push_time', {
                private:getRemainingTime()
            }))
        end)
        for _, chat in ipairs(private:getChats()) do
            _base:get('commandManager'):add({private:getName(), 'active', chat.name}, function ()
                private:toggleChat(chat.name)
            end)
        end
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onOpenShopAdminingList',
            function (shop, id)
                private:setId(id)
                private:setShop(shop)
            end
        )
        :add(
            'onShowDialog',
            function (id)
                if private:isPushing() then
                    _base:get('dialogManager'):send(id, 1)
                    private:setPushing(false)
                    return false
                end
            end,
            1000
        )
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(1000)
                    if private:isActive() and not _base:get('dialogManager'):isOpened() and not _base:get('playerManager'):isShoping() and not _base:get('playerManager'):isAdmining() then
                        if private:checkChats() and private:getPushAt() <= os.time() then
                            private:setPushAt(os.time() + private:getTime() * 60)
                            if private:getMessage() ~= '' and private:getId() ~= nil then
                                local data = {
                                    private:getId(),
                                    private:getMessage()
                                }
                                local message = ''
                                if private:getShop() ~= nil and private:getShop():isCentral() then
                                    message = _base:get('message'):get('message_ad_push_central_market', data)
                                else
                                    message = _base:get('message'):get('message_ad_push', data)
                                end
                                for _, chat in ipairs(private:getChats()) do
                                    if chat.active then
                                        private:setPushing(true)
                                        sampProcessChatInput(_base:get('helper'):implode(' ', {'/'..chat.name, message}))
                                        wait(500)
                                    end
                                end
                            else
                                if private:getMessage() == '' then
                                    _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_message'))
                                elseif private:getId() == nil then
                                    _base:get('chat'):push(_base:get('message'):get('message_ad_push_error_number'))
                                end
                            end
                            _base:get('chat'):push(_base:get('message'):get('message_ad_next_push_time', {
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