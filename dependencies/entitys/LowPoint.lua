local class = {}
function class:new()
    local this = {}
    local private = {
        ['color'] = _sh.color:get('white'),
        ['alpha'] = _sh.color:getAlpha(100),
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
        local _, x, y, z, _, _ = convert3DCoordsToScreenEx(_sh.player:getX(), _sh.player:getY(), _sh.player:getZ() - 1)
        if z > 0 then
            _sh.render:pushLine(x, y, x, y - 50, 3, private:getAlpha() .. private:getColor())
            _sh.render:pushPoint(x, y - 10, 20, 20, 3, 180, private:getAlpha() .. private:getColor())
        end
    end

    return this
end
return class