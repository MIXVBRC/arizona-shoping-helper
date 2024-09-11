local class = {}
function class:new(base, _text, _x, _y, _z)
    local this = {}
    local private = {
        ['text'] = _text or '',
        ['player'] = 'none',
        ['mod'] = base:getClass('message'):get('system_shop_empty'),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
    }

    function this:getText()
        return private.text
    end

    function this:getPlayer()
        return private.player
    end

    function private:setPlayer(player)
        private.player = player
        return this
    end

    function this:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return this
    end

    function this:getPosition()
        return private.position
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

    function private:init()
        private:setPlayer(this:getText():match('^(.+)%s{......}.+{......}.+$'))
        private:setMod(this:getText():match('^.+{......}(.+){......}.+$'))
    end

    private:init()
    return this
end
return class