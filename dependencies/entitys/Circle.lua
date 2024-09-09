local class = {}
function class:new(_x, _y, _z, _radius, _polygons)
    local this = {}
    local private = {
        ['id'] = _sh.helper:md5((_x or 0)..(_y or 0)..(_z or 0)..(_radius or 5)..(_polygons or 32)),
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['radius'] = _radius or 5,
        ['polygons'] = _polygons or 32,
        ['points'] = {},
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

    function this:getRadius()
        return private.radius
    end

    function this:getPolygons()
        return private.polygons
    end

    function this:getPoints()
        return private.points
    end

    function this:deletePoint(_point)
        local new = {}
        for _, point in ipairs(this:getPoints()) do
            if _point:getId() ~= point:getId() then
                table.insert(new, point)
            end
        end
        private.points = new
        private:sort()
        return this
    end

    function this:addPoint(x, y, z)
        table.insert(private.points, _sh.dependencies.point:new(
            x,
            y,
            z,
            _sh.helper:getAngle(x - this:getX(), y - this:getY())
        ))
        private:sort()
    end

    function private:initPoints()
        for angle = 0, 360, math.floor(360 / this:getPolygons()) do
            this:addPoint(
                this:getX() + this:getRadius() * math.cos(math.rad(angle)),
                this:getY() + this:getRadius() * math.sin(math.rad(angle)),
                this:getZ()
            )
        end
        private:sort()
    end

    function private:sort()
        if #private.points > 0 then
            table.sort(private.points, function (a, b) return a:getAngle() > b:getAngle() end)
        end
        return this
    end

    private:initPoints()
    return this
end
return class