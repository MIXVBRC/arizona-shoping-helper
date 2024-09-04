local class = {}
function class:new(_x, _y, _z, _player, _mod, _empty, _central)
    local public = {}
    local private = {
        ['id'] = _sh.helper:md5((_player or 'none')..(_x or 0)..(_y or 0)..(_z or 0)),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['player'] = _player or 'none',
        ['mod'] = _mod or 'sale',
        ['empty'] = _empty or true,
        ['central'] = _central or false,
    }

    function public:getId()
        return private.id
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

    function public:getPlayer()
        return private.player
    end

    function public:getMod()
        return private.mod
    end

    function public:isEmpty()
        return private.empty
    end

    function public:isCentral()
        return private.central
    end

    return public
end
return class