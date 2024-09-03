local class = {}
function class:new(_x, _y, _z, _angle)
    local public = {}
    local private = {
        ['id'] = _sh.helper:md5((_x or 0)..(_y or 0)..(_z or 0)..(_angle or 0)),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['angle'] = _angle or 0,
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

    function public:getAngle()
        return private.angle
    end

    return public
end
return class