local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['circles'] = {},
    }

    function this:getAll()
        return private.circles
    end

    function this:clear()
        private.circles = {}
        return this
    end

    function this:create(x, y, z, radius, polygons)
        table.insert(private.circles, _base:getInit('circle', x, y, z, radius, polygons))
        return this
    end

    function this:booleanUnion()
        for _, circle in ipairs(this:getAll()) do
            local intersectingCircles = private:getIntersectingCircles(circle)
            if #intersectingCircles > 0 then
                for _, intersectingCircle in ipairs(intersectingCircles) do
                    local d = getDistanceBetweenCoords2d(
                        circle:getX(), circle:getY(),
                        intersectingCircle:getX(), intersectingCircle:getY()
                    )
                    local a = (circle:getRadius() ^ 2 - intersectingCircle.getRadius() ^ 2 + d ^ 2) / (2 * d)
                    local h = math.sqrt(circle:getRadius() ^ 2 - a ^ 2)
                    local x = circle:getX() + a / d * (intersectingCircle:getX() - circle:getX())
                    local y = circle:getY() + a / d * (intersectingCircle:getY() - circle:getY())
                    circle:addPoint(
                        x + h / d * (intersectingCircle:getY() - circle:getY()),
                        y - h / d * (intersectingCircle:getX() - circle:getX()),
                        circle:getZ()
                    )
                    circle:addPoint(
                        x - h / d * (intersectingCircle:getY() - circle:getY()),
                        y + h / d * (intersectingCircle:getX() - circle:getX()),
                        circle:getZ()
                    )
                    for _, point in ipairs(circle:getPoints()) do
                        for _, _intersectingCircle in ipairs(intersectingCircles) do
                            local distance = getDistanceBetweenCoords2d(
                                point:getX(), point:getY(),
                                _intersectingCircle:getX(), _intersectingCircle:getY()
                            )
                            if distance < intersectingCircle:getRadius() - 0.001 then
                                circle:deletePoint(point)
                            end
                        end
                    end
                end
            end
        end
        return this
    end

    function private:getIntersectingCircles(_circle)
        local intersectingCircles = {}
        for _, circle in ipairs(this:getAll()) do
            local distance = getDistanceBetweenCoords2d(
                _circle:getX(), _circle:getY(),
                circle:getX(), circle:getY()
            )
            if distance ~= 0 and distance < (_circle:getRadius() + circle:getRadius()) then
                table.insert(intersectingCircles, circle)
            end
        end
        return intersectingCircles
    end

    return this
end
return class