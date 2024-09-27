local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['afk'] = true,
        ['shoping'] = false,
        ['admining'] = false,
        ['inventory'] = false,
        ['cache'] = _base:getNew('cache'),
    }

    -- NAME

    function this:getName()
        local name = private.cache:get('name')
        if name == nil then
            name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
            private.cache:add('name', name, 60)
        end
        return name
    end

    -- POSITION

    function this:getPosition()
        local position = private.cache:get('position')
        if position == nil then
            local x, y, z = getCharCoordinates(playerPed)
            position = {
                ['x'] = x,
                ['y'] = y,
                ['z'] = z,
            }
            private.cache:add('cursor', position, 0.01)
        end
        return position
    end

    function this:getX()
        return this:getPosition().x
    end

    function this:getY()
        return this:getPosition().y
    end

    function this:getZ()
        return this:getPosition().z
    end

    -- CURSOR

    function this.getCursorPosition()
        local position = private.cache:get('cursor')
        if position == nil then
            local x, y = getCursorPos()
            position = {
                ['x'] = x,
                ['y'] = y,
            }
            private.cache:add('cursor', position, 0.1)
        end
        return position
    end

    function this:getCursorX()
        return this:getCursorPosition().x
    end

    function this:getCursorY()
        return this:getCursorPosition().y
    end

    -- AFK

    function this:isAFK()
        return private.afk
    end

    -- SHOPING

    function this:isShoping()
        return private.shoping
    end

    function private:setShoping(bool)
        private.shoping = bool
        return private
    end

    -- ADMINING

    function this:isAdmining()
        return private.admining
    end

    function private:setAdmining(bool)
        private.admining = bool
        return private
    end

    -- INVENTORY

    function this:inInventory()
        return private.inventory
    end

    function private:setInventory(bool)
        private.inventory = bool
        return private
    end

    -- SHOPING ADMINING INVENTORY

    function this:isSAI()
        return this:isShoping() or this:isAdmining() or this:inInventory()
    end

    -- INITS

    function private:init()
        private:initEvents():initThrades()
        return this
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onShowDialogShopAdmining',
            function (_, _, title)
                _base:get('threadManager'):add(
                    nil,
                    function ()
                        while _base:get('dialogManager'):isOpened() do wait(1000)
                            local shop = _base:get('shopManager'):getNearbyAdmin()
                            if shop ~= nil and shop:getPlayerName() == this:getName() then
                                local id = _base:get('helper'):getNumber(title:match(_base:get('message'):get('system_regex_match_dialog_title_shop_id')))
                                _base:get('eventManager'):trigger('onOpenShopAdminingList', id, shop)
                                return
                            end
                        end
                    end
                )
            end
        )
        :add(
            'onCreateTextdraw',
            function (textdraw)
                if textdraw:getText() ~= '' then
                    local text = _base:get('helper'):textDecode(textdraw:getText())
                    if text == _base:get('message'):get('system_textdraw_shop_shoping') then
                        private:setShoping(true)
                        _base:get('threadManager'):add(
                            nil,
                            function () wait(0)
                                _base:get('eventManager'):trigger('onEnterShop')
                                while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setShoping(false)
                                _base:get('eventManager'):trigger('onOutShop')
                            end
                        )
                    end
                    if text == _base:get('message'):get('system_textdraw_shop_admining') then
                        private:setAdmining(true)
                        _base:get('threadManager'):add(
                            nil,
                            function () wait(0)
                                _base:get('eventManager'):trigger('onOpenShopAdmining')
                                while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setAdmining(false)
                                _base:get('eventManager'):trigger('onCloseShopAdmining')
                            end
                        )
                    end
                    if not this:isShoping() and not this:isAdmining() and text == _base:get('message'):get('system_textdraw_inventory') then
                        private:setInventory(true)
                        _base:get('threadManager'):add(
                            nil,
                            function () wait(0)
                                _base:get('eventManager'):trigger('onOpenInventory')
                                while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setInventory(false)
                                _base:get('eventManager'):trigger('onCloseInventory')
                            end
                        )
                    end
                end
            end
        )
        :add(
            'onServerMessage',
            function (_, text)
                text = _base:get('helper'):removeColors(text or '')
                if text:find(_base:get('message'):get('system_regex_find_chat_shop_is_empty')) then
                    _base:get('eventManager'):trigger('onEnterShop')
                    private:setShoping(true)
                    private:setShoping(false)
                    _base:get('eventManager'):trigger('onOutShop')
                end
            end
        )
        return private
    end

    function private:initThrades()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(5000)
                    private.afk = true
                    local cursor = private.cache:get('afk_cursor') or {}
                    if cursor.x ~= this:getCursorX() or cursor.y ~= this:getCursorY() then
                        private.afk = false
                        private.cache:add('afk_cursor', this:getCursorPosition())
                    end
                    local position = private.cache:get('afk_position') or {}
                    if position.x ~= this:getX() or position.y ~= this:getY() or position.z ~= this:getZ() then
                        private.afk = false
                        private.cache:add('afk_position', this:getPosition())
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class