local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['color'] = _base:get('color'):get('white'),
        ['alpha'] = _base:get('color'):getAlpha(100),
    }

    function private:getColor()
        return private.color
    end

    function this:setColor(color)
        private.color = color
        return this
    end

    function private:getAlpha()
        return private.alpha
    end

    function this:setAlpha(alpha)
        private.alpha = alpha
        return this
    end

    function this:render()
        local _, x, y, z, _, _ = convert3DCoordsToScreenEx(_base:get('playerManager'):getX(), _base:get('playerManager'):getY(), _base:get('playerManager'):getZ() - 1)
        if z > 0 then
            _base:get('renderManager'):pushLine(x, y, x, y - 50, 3, private:getAlpha() .. private:getColor())
            _base:get('renderManager'):pushPoint(x, y - 10, 20, 20, 3, 180, private:getAlpha() .. private:getColor())
        end
    end

    return this
end
return class