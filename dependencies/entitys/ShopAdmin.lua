local class = {}
function class:new(base, _text, _x, _y, _z)
    local this = {}
    local private = {
        ['text'] = _text,
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
    }

    function this:getText()
        return private.text
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

    return this
end
return class