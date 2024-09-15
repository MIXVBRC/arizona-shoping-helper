local class = {}
function class:new(_base, _text, _x, _y, _z)
    local this = {}
    local private = {
        ['text'] = _text or '',
        ['player'] = 'none',
        ['mod'] = _base:get('message'):get('system_shop_empty'),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
    }

    -- PARAMS

    function this:getText()
        return private.text
    end

    function this:getPlayer()
        return private.player
    end

    function private:setPlayer(player)
        private.player = player
        return private
    end

    function this:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return private
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

    -- INITS

    function private:init()
        private:initPlayer():initMod()
        return this
    end

    function private:initPlayer()
        private:setPlayer(this:getText():match('^(.+)%s{......}.+{......}.+$'))
        return private
    end

    function private:initMod()
        private:setMod(this:getText():match('^.+{......}(.+){......}.+$'))
        return private
    end

    return private:init()
end
return class