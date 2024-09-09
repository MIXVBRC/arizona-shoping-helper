local class = {}
function class:new()
    local public = {}
    local private = {
        ['shoping'] = false,
        ['admining'] = false,
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function public:getName()
        local name = private.cache:get('name')
        if name == nil then
            name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
            private.cache:add('name', name, 60)
        end
        return name
    end

    function public:getPosition()
        local x, y, z = getCharCoordinates(playerPed)
        return {
            ['x'] = x,
            ['y'] = y,
            ['z'] = z,
        }
    end

    function public:getX()
        return public:getPosition().x
    end

    function public:getY()
        return public:getPosition().y
    end

    function public:getZ()
        return public:getPosition().z
    end

    function public:isShoping()
        return private.shoping
    end

    function private:setShoping(bool)
        private.shoping = bool
        return public
    end

    function public:isAdmining()
        return private.admining
    end

    function private:setAdmining(bool)
        private.admining = bool
        return public
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
                    if not public:isShoping() and text == _sh.message:get('system_shop_textdraw') then
                        private:setShoping(true)
                        _sh.threadManager:add(
                            nil,
                            function () wait(0) while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                private:setShoping(false)
                            end
                        )
                    end
                    if not public:isAdmining() and text == _sh.message:get('system_trade_textdraw') then
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
            'onShowDialog',
            function (_, _, title)
                title = _sh.helper:removeColors(title)
                if title:find('^Ыртър Й%d+$') then
                    local shop = _sh.shopManager:getNearby()
                    if shop ~= nil then
                        _sh.chat:push(1)
                        local id = _sh.helper:getNumber(title:match('^Ыртър Й(%d+)$'))
                        _sh.eventManager:trigger('onEnterShopAdmining', shop, id)
                    end
                end
            end
        )
    end

    private:init()
    return public
end

return class