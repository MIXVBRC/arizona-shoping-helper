local class = {}
function class:new(_sh, _polygons, _distance)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['lowPoint'] = {
            ['active'] = false,
            ['distance'] = 6,
        },
        ['radius'] = 5,
        ['polygons'] = _polygons or 32,
        ['distance'] = _distance or 20,
        ['circles'] = {},
        ['player'] = {
            ['position'] = {
                ['x'] = 0,
                ['y'] = 0,
                ['z'] = 0,
            },
            ['distance'] = nil,
        },
        ['color'] = {
            ['circle'] = 'ffffff',
            ['lowPoint'] = {
                ['good'] = '00ff00',
                ['bad'] = 'ff0000',
            },
            ['alpha'] = '0xff',
        },
        ['centralMarkets'] = {},
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

    function private:getColor(num)
        local result = string.format("%x", num * 255)
        if result:len() < 2 then
            result = '0' .. result
        end
        return result
    end

    function private:isCentralMarket(x, y, z)
        if private.centralMarkets[x .. y .. z] == nil then
            for _, object in ipairs(getAllObjects()) do
                local objectModel = getObjectModel(object)
                if objectModel == 3861 or objectModel == 14211 or objectModel == 14210 then
                    local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                    local distance = getDistanceBetweenCoords3d(
                        x, y, z,
                        objectX, objectY, objectZ
                    )
                    if distance < 1 then
                        return true
                    end
                end
            end
        else
            return true
        end
        return false
    end

    function private:initCircles()
        local circles = private.cache:get('circles')
        if circles == nil then
            circles = {}
            for textId = 0, 2048 do
                if sampIs3dTextDefined(textId) then
                    local text, _, textX, textY, textZ, _, _, _, _ = sampGet3dTextInfoById(textId)
                    if text == private.sh.message:get('product_management') then
                        local isCentralMarket = private:isCentralMarket(textX, textY, textZ)
                        if not isCentralMarket then
                            local distance = getDistanceBetweenCoords3d(
                                private.player.position.x, private.player.position.y, private.player.position.z,
                                textX, textY, textZ
                            )
                            if distance < private.distance then
                                table.insert(
                                    circles,
                                    private.sh.dependencies.circle:new(
                                        textX, textY, textZ,
                                        private.radius,
                                        private.polygons,
                                        private.color.circle
                                    ):distance(distance)
                                )
                            end
                        else
                            private.centralMarkets[textX .. textY .. textZ] = true
                        end
                    end
                end
            end
            private.cache:add('circles', circles)
        end

        if circles ~= nil and #circles > 0 then
            for _, circle in ipairs(circles) do
                local distance = getDistanceBetweenCoords3d(
                    private.player.position.x, private.player.position.y, private.player.position.z,
                    circle:getPosition('x'), circle:getPosition('y'), circle:getPosition('z')
                )

                if private.player.distance == nil or distance < private.player.distance then
                    private.player.distance = distance
                end

                if distance <= private.lowPoint.distance then
                    private.lowPoint.active = true
                end
            end
        end

        if #circles > 0 and #private.circles > 0 and #circles == #private.circles then
            for _, beforeCircle in ipairs(private.circles) do
                if beforeCircle:checkIntersecting(circles) then
                    private.circles = circles
                    break
                end
            end
        else
            private.circles = circles
        end
    end

    function private:recalculateCircles()
        for _, circle in ipairs(private.circles) do
            circle:checkIntersecting(private.circles)
            if circle:needRecalculate() then
                circle:calculateIntersecting():initPoints():clearIntersectionPoints():sortPoints():omitPoints():initSegments()
            end
        end
    end

    function private:drawCircles()
        for _, circle in ipairs(private.circles) do
            local segments = circle:getSegments()
            if segments ~= nil and #segments > 0 then
                for _, segment in ipairs(segments) do
                    local _, aX, aY, aZ, _, _ = convert3DCoordsToScreenEx(segment[1].x, segment[1].y, segment[1].z)
                    local _, bX, bY, bZ, _, _ = convert3DCoordsToScreenEx(segment[2].x, segment[2].y, segment[2].z)
                    if aZ > 0 and bZ > 0 then
                        renderDrawLine(aX, aY, bX, bY, 1, private.color.alpha .. circle:getColor())
                    end
                end
            end
        end
    end

    function private:drawLowPoint()
        if private.lowPoint.active then
            local _, x, y, z, _, _ = convert3DCoordsToScreenEx(private.player.position.x, private.player.position.y, private.player.position.z - 1)
            if z > 0 then
                local color = private.color.lowPoint.good
                if private.player.distance <= private.radius then
                    color = private.color.lowPoint.bad
                end
                renderDrawLine(x, y, x, y - 50, 3, private.color.alpha .. color)
                renderDrawPolygon(x, y - 10, 20, 20, 3, 180, private.color.alpha .. color)
            end
            private.lowPoint.active = false
            private.player.distance = nil
        end
    end

    function public:init()
        private.player.position.x, private.player.position.y, private.player.position.z = getCharCoordinates(playerPed)
        private:initCircles()
        if #private.circles > 0 then
            private:recalculateCircles()
            private:drawCircles()
            private:drawLowPoint()
        end
    end

    return public
end
return class