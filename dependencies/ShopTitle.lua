local class = {}
function class:new(_text, _x, _y, _z)
    local public = {}
    local private = {
        ['text'] = _text or '',
        ['player'] = 'none',
        ['mod'] = _sh.message:get('system_shop_empty'),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
    }

    function public:getText()
        return private.text
    end

    function public:getPlayer()
        return private.player
    end

    function private:setPlayer(player)
        private.player = player
        return public
    end

    function public:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return public
    end

    function public:getPosition()
        return private.position
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

    function private:init()
        private:setPlayer(public:getText():match('^(.+)%s{......}.+{......}.+$'))
        private:setMod(public:getText():match('^.+{......}(.+){......}.+$'))
    end

    private:init()
    return public
end
return class