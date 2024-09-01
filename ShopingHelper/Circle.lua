local class = {}
function class:new(_x, _y, _z, _radius, _polygons, _color)
    local public = {}
    local private = {
        ['params'] = {
            ['id'] = 'x' .. _x .. 'y' .. _y .. 'z' .. _z,
            ['position'] = {
                ['x'] = _x or 0,
                ['y'] = _y or 0,
                ['z'] = _z or 0,
            },
            ['radius'] = _radius or 5,
            ['polygons'] = _polygons or 32,
            ['color'] = _color or 'ffffff',
            ['intersections'] = {},
            ['points'] = {},
            ['segments'] = {},
            ['recalculate'] = true,
            ['distance'] = nil,
        },
    }

    function public:getId()
        return private.params.id
    end

    function public:getPosition(axis)
        if axis ~= nil then
            return private.params.position[axis]
        end
        return private.params.position
    end

    function public:getRadius()
        return private.params.radius
    end

    function public:getPolygons()
        return private.params.polygons
    end

    function public:getColor()
        return private.params.color
    end

    function public:needRecalculate(bool)
        if bool == nil then
            return private.params.recalculate
        end
        private.params.recalculate = bool
        return public
    end

    function public:distance(distance)
        if distance == nil then
            return private.params.distance
        end
        private.params.distance = distance
        return public
    end

    function private:getAnglePoint(x, y)
        local angle = math.atan2(x - private.params.position.x, y - private.params.position.y) / math.pi * 180
        if angle < 0 then
            angle = angle + 360
        end
        return angle
    end

    function public:addPoint(point)
        table.insert(private.params.points, point)
    end

    function public:getPoints()
        return private.params.points
    end

    function private:trace(aX, aY, aZ, bX, bY, bZ)
        return processLineOfSight(
            aX, aY, aZ,
            bX, bY, bZ
        )
    end

    function public:checkIntersecting(circles)
        if circles ~= nil and #circles > 0 then
            local intersections = {}
            for _, circle in ipairs(circles) do
                if public:getId() ~= circle:getId() then
                    local circlePosition = circle.getPosition()
                    local distance = getDistanceBetweenCoords2d(
                        private.params.position.x, private.params.position.y,
                        circlePosition.x, circlePosition.y
                    )
                    if distance <= private.params.radius + circle.getRadius() then
                        table.insert(intersections, circle)
                    end
                end
            end
            if #private.params.intersections ~= #intersections then
                public:needRecalculate(true)
            elseif #private.params.intersections > 0 and #intersections > 0 then
                for _, beforeIntersection in ipairs(private.params.intersections) do
                    for _, afterIntersection in ipairs(intersections) do
                        if beforeIntersection:getId() == afterIntersection:getId() then
                            goto continue
                        end
                    end
                    public:needRecalculate(true)
                    break
                    ::continue::
                end
            end
            if public:needRecalculate() then
                private.params.intersections = intersections
            end
        end
        return public:needRecalculate()
    end

    function public:calculateIntersecting()
        if #private.params.intersections > 0 then
            for _, intersection in ipairs(private.params.intersections) do
                local intersectionPosition = intersection.getPosition()
                local d = getDistanceBetweenCoords2d(
                    private.params.position.x, private.params.position.y,
                    intersectionPosition.x, intersectionPosition.y
                )
                local a = (private.params.radius ^ 2 - intersection.getRadius() ^ 2 + d ^ 2) / (2 * d)
                local h = math.sqrt(private.params.radius ^ 2 - a ^ 2)
                local x = private.params.position.x + a / d * (intersectionPosition.x - private.params.position.x)
                local y = private.params.position.y + a / d * (intersectionPosition.y - private.params.position.y)
                public:addPoint({
                    ['x'] = x + h / d * (intersectionPosition.y - private.params.position.y),
                    ['y'] = y - h / d * (intersectionPosition.x - private.params.position.x),
                    ['z'] = private.params.position.z,
                    ['intersection'] = true
                })
                public:addPoint({
                    ['x'] = x - h / d * (intersectionPosition.y - private.params.position.y),
                    ['y'] = y + h / d * (intersectionPosition.x - private.params.position.x),
                    ['z'] = private.params.position.z,
                    ['intersection'] = true
                })
            end
        end
        public:needRecalculate(false)
        return public
    end

    function public:clearIntersectionPoints()
        if #private.params.intersections > 0 then
            local points = {}
            for _, point in ipairs(private.params.points) do
                for _, circle in ipairs(private.params.intersections) do
                    local distance = getDistanceBetweenCoords2d(
                        circle:getPosition('x'), circle:getPosition('y'),
                        point.x, point.y
                    )
                    if distance - circle:getRadius() < -0.0001 then
                        goto continue
                    end
                end
                table.insert(points, point)
                ::continue::
            end
            private.params.points = points
        end
        return public
    end

    function public:initPoints()
        for angle = 0, 360, math.floor(360 / private.params.polygons) do
            public:addPoint({
                ['x'] = private.params.position.x + private.params.radius * math.cos(math.rad(angle)),
                ['y'] = private.params.position.y + private.params.radius * math.sin(math.rad(angle)),
                ['z'] = private.params.position.z,
                ['intersection'] = false,
            })
        end
        return public
    end

    function public:sortPoints()
        if #private.params.points > 0 then
            for _, point in ipairs(private.params.points) do
                point.angle = private:getAnglePoint(point.x, point.y)
            end
            table.sort(private.params.points, function (a, b) return a.angle > b.angle end)
        end
        return public
    end

    function public:omitPoints()
        if #private.params.points > 0 then
            for _, point in ipairs(private.params.points) do
                local result, dataTrace = private:trace(point.x, point.y, point.z + 1000, point.x, point.y, point.z - 1000)
                if result and dataTrace ~= nil then
                    if math.abs(point.z - dataTrace.pos[3]) < 2 then
                        point.z = dataTrace.pos[3]
                    end
                end
            end
        end
        return public
    end

    function public:initSegments()
        private.params.segments = {}
        if #private.params.points > 0 then
            local distancePoints = math.ceil(2 * private.params.radius * math.sin( math.rad( 360 / private.params.polygons / 2 ) ) * 100) / 100
            local previousPoint = nil
            local points = private.params.points
            table.insert(points, private.params.points[1])
            for _, point in ipairs(points) do
                if previousPoint ~= nil and distancePoints >= getDistanceBetweenCoords2d(point.x, point.y, previousPoint.x, previousPoint.y) then
                    table.insert(private.params.segments, {
                        previousPoint,
                        point,
                    })
                end
                previousPoint = point
            end
        end
        return public
    end

    function public:getSegments()
        return private.params.segments
    end

    return public
end
return class