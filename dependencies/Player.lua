local class = {}
function class:new()
    local public = {}
    local private = {
        ['inShop'] = false,
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

    function public:inShop()
        return private.inShop
    end

    function private:setInShop(inShop)
        private.inShop = inShop
        return public
    end

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onVisitShop',
            function (shop, mod, textdraw)
                private:setInShop(true)
                _sh.threadManager:add(
                    nil,
                    function ()
                        while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                        private:setInShop(false)
                    end
                )
            end
        )
    end

    private:init()
    return public
end

return class