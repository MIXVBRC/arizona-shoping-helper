local class = {}
function class:new(id, position, player, mod, empty, central)
    local public = {}
    local private = {
        ['id'] = id,
        ['position'] = position or {
            ['x'] = 0,
            ['y'] = 0,
            ['z'] = 0,
        },
        ['player'] = player or 'none',
        ['mod'] = mod or 'sale',
        ['empty'] = empty or true,
        ['central'] = central or true,
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