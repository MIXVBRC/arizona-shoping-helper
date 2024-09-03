local class = {}
function class:new()
    local public = {}
    local private = {
        ['color'] = 'ffffff',
        ['alpha'] = '0xff',
    }

    function private:getColor()
        return private.color
    end

    function public:setColor(color)
        private.color = color
        return public
    end

    function private:getAlpha()
        return private.alpha
    end

    function public:setAlpha(alpha)
        private.alpha = alpha
        return public
    end

    function public:render()
        local _, x, y, z, _, _ = convert3DCoordsToScreenEx(_sh.player:getX(), _sh.player:getY(), _sh.player:getZ() - 1);
        if z > 0 then
            renderDrawLine(x, y, x, y - 50, 3,
            private:getAlpha() ..
            private:getColor()
        );
            renderDrawPolygon(x, y - 10, 20, 20, 3, 180, private:getAlpha() .. private:getColor());
        end;
    end

    return public
end
return class