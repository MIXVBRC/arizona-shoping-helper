local class = {}
function class:new()
    local public = {}
    local private = {
        ['circles'] = {},
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function public:getAll()
        return private.circles
    end

    function public:clear()
        private.circles = {}
        return public
    end

    function public:create(x, y, z, radius, polygons)
        table.insert(private.circles, _sh.dependencies.circle:new(x, y, z, radius, polygons))
        private.cache:clear()
        return public
    end

    function public:booleanUnion()
        for _, circle in ipairs(public:getAll()) do
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
                        local distance = getDistanceBetweenCoords2d(
                            point:getX(), point:getY(),
                            intersectingCircle:getX(), intersectingCircle:getY()
                        )
                        if distance - intersectingCircle:getRadius() < -0.1 then -- maybee need -0.0001
                            circle:deletePoint(point)
                        end
                    end
                end
            end
        end
        return public
    end

    function private:getIntersectingCircles(_circle)
        local intersectingCircles = {}
        for _, circle in ipairs(public:getAll()) do
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

    return public
end
return class