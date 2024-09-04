local class = {}
function class:new(_name, _defaultConfig)
    local public = {}
    local private = {
        ['radius'] = 5,
        ['minmax'] = _sh.dependencies.minMax:new({
            ['polygons'] = {
                ['min'] = 24,
                ['max'] = 48,
            },
            ['distance'] = {
                ['min'] = 30,
                ['max'] = 60,
            },
        }),
        ['configManager'] = _sh.dependencies.configManager:new(_name, _sh.config),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
        ['cache'] = _sh.dependencies.cache:new(),
        ['lowPoint'] = _sh.dependencies.lowPoint:new(),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:getOption('active')
    end

    function public:toggleActive()
        private.configManager:setOption('active', not private:isActive())
        return public
    end

    -- POLYGONS

    function private:getPolygons()
        return private.configManager:getOption('polygons')
    end

    function private:setPolygons(polygons)
        private.configManager:setOption('polygons', private.minmax:get(polygons, 'polygons'))
        return public
    end

    -- DISTANCE

    function private:getDistance()
        return private.configManager:getOption('distance')
    end

    function private:setDistance(distance)
        private.configManager:setOption('distance', private.minmax:get(distance, 'distance'))
        return public
    end

    -- COLOR

    function private:getColor(name)
        return private.configManager:getOption('colors')[name]
    end

    -- INITS

    function private:init(defaultConfig)
        for name, value in pairs(defaultConfig) do
            if private.configManager:getOption(name) == nil then
                private.configManager:setOption(name, value)
            end
        end
        private:initThreads()
        private:initCommands()
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        private:work()
                    end
                end
            end
        )
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
        private.commandManager:add('polygons', function (polygons)
            polygons = _sh.helper:toInt(polygons)
            if polygons ~= nil then
                private:setPolygons(polygons)
            end
        end)
        private.commandManager:add('distance', function (distance)
            distance = _sh.helper:toInt(distance)
            if distance ~= nil then
                private:setDistance(distance)
            end
        end)
    end

    -- LOGICK

    function private:getShops()
        local shops = {}
        for _, shop in ipairs(_sh.shopManager:getAll()) do
            if not shop:isCentral() then
                local distance = _sh.helper:distanceToPlayer2d(shop:getX(), shop:getY())
                if distance < private:getDistance() then
                    table.insert(shops, shop)
                end
            end
        end
        return shops
    end

    function private:getCircles(shops)
        local circles = {}
        for _, shop in ipairs(shops) do
            table.insert(circles, {
                ['position'] = {
                    ['x'] = shop:getX(),
                    ['y'] = shop:getY(),
                    ['z'] = shop:getZ() - 0.8,
                },
                ['radius'] = private.radius,
                ['polygons'] = private:getPolygons(),
            })
        end
        return circles
    end

    function private:getOmitPoint(point)
        local newPoint = point
        local position = _sh.helper:omitPosition(point:getX(), point:getY(), point:getZ(), 5)
        if math.abs(point:getZ() - position.z) < 2 then
            newPoint = _sh.dependencies.point:new(
                point:getX(),
                point:getY(),
                position.z
            )
        end
        return newPoint
    end

    function public:getSegments(circlesPoints)
        local segments = {}
        if circlesPoints ~= nil and #circlesPoints > 0 then
            for index, points in ipairs(circlesPoints) do
                segments[index] = {}
                local distancePoints = math.ceil(2 * private.radius * math.sin( math.rad( 360 / private:getPolygons() / 2 ) ) * 100) / 100
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
                    local pointA = segment[1]
                    local pointB = segment[2]
                    local distance = _sh.helper:distanceToPlayer3d(
                        ( pointB:getX() + pointA:getX() ) / 2,
                        ( pointB:getY() + pointA:getY() ) / 2,
                        ( pointB:getZ() + pointA:getZ() ) / 2
                    )
                    local alpha = _sh.color:alpha( 1 - math.floor( distance * 100 / ( private:getDistance() - 10 ) ) / 100 )
                    local _, aX, aY, aZ, _, _ = convert3DCoordsToScreenEx(pointA:getX(), pointA:getY(), pointA:getZ())
                    local _, bX, bY, bZ, _, _ = convert3DCoordsToScreenEx(pointB:getX(), pointB:getY(), pointB:getZ())
                    if aZ > 0 and bZ > 0 then
                        renderDrawLine(aX, aY, bX, bY, 1, alpha .. private:getColor('circle'))
                    end
                end
            end
        end
    end

    -- WORK

    function private:work()
        local segments = private.cache:get('segments')
        if segments == nil then
            local shops = private:getShops()
            local cacheName = private:getPolygons()
            for _, shop in ipairs(shops) do
                cacheName = cacheName .. shop:getId()
            end
            cacheName = _sh.helper:md5(cacheName)
            local points = private.cache:get('points_'..cacheName)
            if points == nil then
                points = {}
                local circleManager = _sh.dependencies.circleManager:new()
                for _, circle in ipairs(private:getCircles(shops)) do
                    circleManager:create(
                        circle.position.x,
                        circle.position.y,
                        circle.position.z,
                        circle.radius,
                        circle.polygons
                    )
                end
                circleManager:booleanUnion()
                for index, circle in ipairs(circleManager:getAll()) do
                    points[index] = {}
                    for _, point in ipairs(circle:getPoints()) do
                        table.insert(points[index], private:getOmitPoint(point))
                    end
                end
                private.cache:add('points_'..cacheName, points, 60)
            end
            segments = public:getSegments(points)
            private.cache:add('segments', segments, 1)
        end
        private:drawSegments(segments)
        local shop = _sh.shopManager:getNearby()
        if not shop:isCentral() then
            local distance = _sh.helper:distanceToPlayer2d(shop:getX(), shop:getY())
            if distance < 6 then
                private.lowPoint:setColor(private:getColor('green'))
                if distance <= private.radius then
                    private.lowPoint:setColor(private:getColor('red'))
                end
                private.lowPoint:render()
            end
        end
    end

    private:init(_defaultConfig or {})
    return public
end
return class