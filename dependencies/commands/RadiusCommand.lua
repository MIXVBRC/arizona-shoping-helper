local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['radius'] = 5,
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
        ['lowPoint'] = _base:getNew('lowPoint'),
        ['cache'] = _base:getNew('cache'),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- RADIUS

    function private:getRadius()
        return private.radius
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:toggleActive()
        private.config:set('active', not private:isActive())
        return private
    end

    -- PLAYER

    function private:isPlayer()
        return private.config:get('player')
    end

    function private:togglePlayer()
        private.config:set('player', not private:isPlayer())
        return private
    end

    -- POLYGONS

    function private:getPolygons()
        return private.config:get('polygons') or private.minmax:getMin('polygons')
    end

    function private:setPolygons(polygons)
        private.config:set('polygons', private.minmax:get(polygons, 'polygons'))
        return private
    end

    -- DISTANCE

    function private:getDistance()
        return private.config:get('distance') or private.minmax:getMin('distance')
    end

    function private:setDistance(distance)
        private.config:set('distance', private.minmax:get(distance, 'distance'))
        return private
    end

    -- COLOR

    function private:getColors()
        return private.config:get('colors') or {}
    end

    function private:getColor(name)
        return private:getColors()[name]
    end

    -- LOGIC

    function private:getShops()
        local shops = {}
        for _, shop in ipairs(_base:get('shopManager'):getShops()) do
            if not shop:isCentral() and (not private:isPlayer() or shop:getPlayerName() ~= _base:get('playerManager'):getName()) then
                local distance = _base:get('helper'):distanceToPlayer2d(shop:getX(), shop:getY())
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
            if shop:getAdmin() ~= nil then
                table.insert(circles, {
                    ['position'] = {
                        ['x'] = shop:getAdmin():getX(),
                        ['y'] = shop:getAdmin():getY(),
                        ['z'] = shop:getAdmin():getZ() - 0.8,
                    },
                    ['radius'] = private:getRadius(),
                    ['polygons'] = private:getPolygons(),
                })
            end
        end
        return circles
    end

    function private:getOmitPoint(point)
        local newPoint = point
        local position = _base:get('helper'):omitPosition(point:getX(), point:getY(), point:getZ(), 5)
        if math.abs(point:getZ() - position.z) < 2 then
            newPoint = _base:getNew( 'point',
                point:getX(),
                point:getY(),
                position.z
            )
        end
        return newPoint
    end

    function private:getSegments(circlesPoints)
        local segments = {}
        if circlesPoints ~= nil and #circlesPoints > 0 then
            for index, points in ipairs(circlesPoints) do
                segments[index] = {}
                local distancePoints = math.ceil(2 * private:getRadius() * math.sin( math.rad( 360 / private:getPolygons() / 2 ) ) * 100) / 100
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
                    local distance = _base:get('helper'):distanceToPlayer3d(
                        ( pointB:getX() + pointA:getX() ) / 2,
                        ( pointB:getY() + pointA:getY() ) / 2,
                        ( pointB:getZ() + pointA:getZ() ) / 2
                    )
                    local alpha = _base:get('color'):getAlpha(100 - math.floor(distance * 100 / (private:getDistance() - 10)))
                    local _, aX, aY, aZ, _, _ = convert3DCoordsToScreenEx(pointA:getX(), pointA:getY(), pointA:getZ())
                    local _, bX, bY, bZ, _, _ = convert3DCoordsToScreenEx(pointB:getX(), pointB:getY(), pointB:getZ())
                    if aZ > 0 and bZ > 0 then
                        _base:get('renderManager'):pushLine(aX, aY, bX, bY, 1, alpha .. private:getColor('circle'))
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initThreads()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'player'}, private.togglePlayer)
        :add({private:getName(), 'polygons'}, function (polygons)
            private:setPolygons(_base:get('helper'):getNumber(polygons))
        end)
        :add({private:getName(), 'distance'}, function (distance)
            private:setDistance(_base:get('helper'):getNumber(distance))
        end)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive()
                    and not _base:get('playerManager'):isSAI()
                    and not sampIsScoreboardOpen()
                    then
                        local segments = private.cache:get('segments')
                        if segments == nil then
                            local shops = private:getShops()
                            local cacheName = private:getPolygons()
                            for _, shop in ipairs(shops) do
                                cacheName = cacheName .. shop:getId()
                            end
                            cacheName = _base:get('helper'):md5(cacheName)
                            local points = private.cache:get('points_'..cacheName)
                            if points == nil then
                                points = {}
                                local circleManager = _base:getNew('circleManager')
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
                            segments = private:getSegments(points)
                            private.cache:add('segments', segments, 1)
                        end
                        private:drawSegments(segments)
                        local shop = _base:get('shopManager'):getNearbyAdmin(private:isPlayer())
                        if shop ~= nil and not shop:isCentral() then
                            if shop:getAdmin() ~= nil then
                                local distance = _base:get('helper'):distanceToPlayer2d(shop:getAdmin():getX(), shop:getAdmin():getY())
                                if distance < 6 then
                                    private.lowPoint:setColor(private:getColor('green'))
                                    if distance <= private:getRadius() then
                                        private.lowPoint:setColor(private:getColor('red'))
                                    end
                                    private.lowPoint:render()
                                end
                            end
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class