local class = {}
function class:new(_id, _position, _player, _mod, _empty, _central)
    local public = {}
    local private = {
        ['id'] = _id,
        ['position'] = _position or {
            ['x'] = 0,
            ['y'] = 0,
            ['z'] = 0,
        },
        ['player'] = _player or 'none',
        ['mod'] = _mod or 'sale',
        ['empty'] = _empty or true,
        ['central'] = _central or true,
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

    if id == nil then return nil else return public end
end
return class