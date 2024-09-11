local class = {}
function class:new(_base, _x, _y, _z, _angle)
    local this = {}
    local private = {
        ['id'] = _base:getClass('helper'):md5((_x or 0)..(_y or 0)..(_z or 0)..(_angle or 0)),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['angle'] = _angle or 0,
    }

    function this:getId()
        return private.id
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

    function this:getAngle()
        return private.angle
    end

    return this
end
return class