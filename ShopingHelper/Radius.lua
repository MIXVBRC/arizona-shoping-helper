local class = {}
function class:new()
    local public = {}
    local private = {
        -- ['lowPoint'] = {
        --     ['active'] = false,
        --     ['distance'] = 6,
        -- },
        ['radius'] = 5,
        ['polygons'] = 32,
        ['distance'] = 20,
        -- ['intersections'] = false,
        -- ['circles'] = {},
        -- ['player'] = {
        --     ['position'] = {
        --         ['x'] = 0,
        --         ['y'] = 0,
        --         ['z'] = 0,
        --     },
        --     ['distance'] = nil,
        -- },
        ['color'] = {
            ['circle'] = 'ffffff',
            ['lowPoint'] = {
                ['good'] = '00ff00',
                ['bad'] = 'ff0000',
            },
            ['alpha'] = '0xff',
        },
        ['cache'] = _sh.dependencies.cache:new(1),
    }

    function public:setRadius(radius)
        private.radius = radius
        return public
    end

    function public:setPolygons(polygons)
        private.polygons = polygons
        return public
    end

    function public:setDistance(distance)
        private.distance = distance
        return public
    end

    function private:getCircles()
        local circles = {}
        for _, shop in ipairs(_sh.shopManager:getAll()) do
            if not shop:isCentral() then
                local distance = getDistanceBetweenCoords2d(
                    _sh.player:getX(), _sh.player:getY(),
                    shop:getX(), shop:getY()
                )
                if distance < private.distance then
                    table.insert(circles, {
                        ['position'] = {
                            ['x'] = shop:getX(),
                            ['y'] = shop:getY(),
                            ['z'] = shop:getZ(),
                        },
                        ['radius'] = private.radius,
                        ['polygons'] = private.polygons,
                    })
                end
            end
        end
        return circles
    end

    function private:getOmitPoint(point)
        local newPoint = point
        local trace = _sh.helper:trace(
            point:getX(), point:getY(), point:getZ() + 1000,
            point:getX(), point:getY(), point:getZ() - 1000
        )
        if trace.touch and trace.position ~= nil then
            if math.abs(point:getZ() - trace.position.z) < 2 then
                newPoint = _sh.dependencies.point:new(
                    point:getX(),
                    point:getY(),
                    trace.position.z
                )
            end
        end
        return newPoint
    end

    function public:getSegments(circlesPoints)
        local segments = {}
        if circlesPoints ~= nil and #circlesPoints > 0 then
            for index, points in ipairs(circlesPoints) do
                segments[index] = {}
                local distancePoints = math.ceil(2 * private.radius * math.sin( math.rad( 360 / private.polygons / 2 ) ) * 100) / 100
                local previousPoint = nil
                table.insert(points, points[1])
                for _, point in ipairs(points) do
                    if previousPoint ~= nil then
                        local distance = getDistanceBetweenCoords2d(
                            point:getX(), point:getY(),
                            previousPoint:getX(), previousPoint:getY()
                        )
                        if distancePoints >= distance then
                            table.insert(segments[index], {
                                previousPoint,
                                point,
                            })
                        end
                    end
                    previousPoint = point
                end
            end
        end
        return segments
    end

    function private:drawSegments(circleSegments)
        for _, segments in ipairs(circleSegments) do
            if segments ~= nil and #segments > 0 then
                for _, segment in ipairs(segments) do
                    local _, aX, aY, aZ, _, _ = convert3DCoordsToScreenEx(segment[1]:getX(), segment[1]:getY(), segment[1]:getZ())
                    local _, bX, bY, bZ, _, _ = convert3DCoordsToScreenEx(segment[2]:getX(), segment[2]:getY(), segment[2]:getZ())
                    if aZ > 0 and bZ > 0 then
                        renderDrawLine(aX, aY, bX, bY, 1, private.color.alpha .. private.color.circle)
                    end
                end
            end
        end
    end

    function public:work()
        local segments = private.cache:get('segments')
        if segments == nil then
            local circleManager = _sh.dependencies.circleManager:new()
            for _, circle in ipairs(private:getCircles()) do
                circleManager:create(
                    circle.position.x,
                    circle.position.y,
                    circle.position.z,
                    circle.radius,
                    circle.polygons
                )
            end
            circleManager:booleanUnion()
            local points = {}
            for index, circle in ipairs(circleManager:getAll()) do
                points[index] = {}
                for _, point in ipairs(circle:getPoints()) do
                    table.insert(points[index], private:getOmitPoint(point))
                end
            end
            segments = public:getSegments(points)
            private.cache:add('segments', segments, 1)
        end
        private:drawSegments(segments)
    end

    return public
end
return class