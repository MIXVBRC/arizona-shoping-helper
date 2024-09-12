local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['shoping'] = false,
        ['admining'] = false,
        ['inventory'] = false,
        ['cache'] = _base:getInit('cache'),
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
        local x, y, z = getCharCoordinates(playerPed)
        return {
            ['x'] = x,
            ['y'] = y,
            ['z'] = z,
        }
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

    -- SHOPING

    function this:isShoping()
        return private.shoping
    end

    function private:setShoping(bool)
        private.shoping = bool
        return this
    end

    -- ADMINING

    function this:isAdmining()
        return private.admining
    end

    function private:setAdmining(bool)
        private.admining = bool
        return this
    end

    -- INVENTORY

    function this:inInventory()
        return private.inventory
    end

    function private:setInventory(bool)
        private.inventory = bool
        return this
    end

    -- SHOPING ADMINING INVENTORY

    function this:isSAI()
        return this:isShoping() or this:isAdmining() or this:inInventory()
    end

    -- INITS

    function private:init()
        private:initEvents()
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
                            local shop = _base:get('shopManager'):getNearby()
                            if shop ~= nil and shop:getPlayer() == this:getName() then
                                local id = _base:get('helper'):getNumber(title:match(_base:get('message'):get('system_regex_match_dialog_title_shop_id')))
                                _base:get('eventManager'):trigger('onOpenShopAdminingList', shop, id)
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
                    local cacheKey = 'text_'..textdraw:getText()
                    local text = private.cache:get(cacheKey)
                    if text == nil then
                        text = _base:get('helper'):textDecode(textdraw:getText())
                        private.cache:add(cacheKey, text)
                    end
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
    end

    private:init()
    return this
end

return class