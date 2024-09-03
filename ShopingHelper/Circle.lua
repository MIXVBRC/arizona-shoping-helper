local class = {}
function class:new(_x, _y, _z, _radius, _polygons)
    local public = {}
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

    function public:getRadius()
        return private.radius
    end

    function public:getPolygons()
        return private.polygons
    end

    function public:getPoints()
        return private.points
    end

    function public:addPoint(x, y, z)
        table.insert(private.points, _sh.dependencies.point:new(
            x,
            y,
            z,
            _sh.helper:getAngle(x - public:getX(), y - public:getY())
        ))
        private:sort()
    end

    function private:initPoints()
        for angle = 0, 360, math.floor(360 / public:getPolygons()) do
            public:addPoint(
                public:getX() + public:getRadius() * math.cos(math.rad(angle)),
                public:getY() + public:getRadius() * math.sin(math.rad(angle)),
                public:getZ()
            )
        end
        private:sort()
    end

    function private:sort()
        if #private.points > 0 then
            table.sort(private.points, function (a, b) return a:getAngle() > b:getAngle() end)
        end
        return public
    end

    private:initPoints()
    return public
end
return class