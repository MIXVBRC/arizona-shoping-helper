local class = {}
function class:new()
    local this = {}
    local private = {
        ['shoping'] = false,
        ['admining'] = false,
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function this:getName()
        local name = private.cache:get('name')
        if name == nil then
            name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
            private.cache:add('name', name, 60)
        end
        return name
    end

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

    function this:isShoping()
        return private.shoping
    end

    function private:setShoping(bool)
        private.shoping = bool
        return this
    end

    function this:isAdmining()
        return private.admining
    end

    function private:setAdmining(bool)
        private.admining = bool
        return this
    end

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onCreateTextdraw',
            function (textdraw)
                if textdraw:getText() ~= '' then
                    local cacheKey = 'text_'..textdraw:getText()
                    local text = private.cache:get(cacheKey)
                    if text == nil then
                        text = _sh.helper:textDecode(textdraw:getText())
                        private.cache:add(cacheKey, text)
                    end
                    if not this:isShoping() and text == _sh.message:get('system_shop_shoping_textdraw') then
                        private:setShoping(true)
                        _sh.threadManager:add(
                            nil,
                            function () wait(0) while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setShoping(false)
                            end
                        )
                    end
                    if not this:isAdmining() and text == _sh.message:get('system_shop_admining_textdraw') then
                        private:setAdmining(true)
                        _sh.threadManager:add(
                            nil,
                            function () wait(0) while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setAdmining(false)
                            end
                        )
                    end
                end
            end
        )
        _sh.eventManager:add(
            'onShowDialogShopAdmining',
            function (_, _, title)
                _sh.threadManager:add(
                    nil,
                    function ()
                        while _sh.dialogManager:isOpened() do wait(1000)
                            local shop = _sh.shopManager:getNearby()
                            if shop ~= nil and shop:getPlayer() == this:getName() then
                                local id = _sh.helper:getNumber(title:match(_sh.message:get('system_regex_match_dialog_title_shop_id')))
                                _sh.eventManager:trigger('onEnterShopAdmining', shop, id)
                                return
                            end
                        end
                    end
                )
            end
        )
    end

    private:init()
    return this
end

return class