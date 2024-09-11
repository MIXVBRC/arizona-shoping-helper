local class = {}
function class:new(base)
    local this = {}
    local private = {
        ['color'] = base:getClass('color'):get('white'),
        ['alpha'] = base:getClass('color'):getAlpha(100),
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
        local _, x, y, z, _, _ = convert3DCoordsToScreenEx(base:getClass('playerManager'):getX(), base:getClass('playerManager'):getY(), base:getClass('playerManager'):getZ() - 1)
        if z > 0 then
            base:getClass('render'):pushLine(x, y, x, y - 50, 3, private:getAlpha() .. private:getColor())
            base:getClass('render'):pushPoint(x, y - 10, 20, 20, 3, 180, private:getAlpha() .. private:getColor())
        end
    end

    return this
end
return class