local class = {}
function class:new()
    local public = {}
    local private = {
        ['cache'] = _sh.dependencies.cache:new(60),
    }

    function public:getName()
        local name = private.cache:get('name')
        if name == nil then
            name = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
            private.cache:add('name', name)
        end
        return name
    end

    function public:getPosition()
        local position = private.cache:get('position')
        if position == nil then
            local x, y, z = getCharCoordinates(playerPed)
            position = {
                ['x'] = x,
                ['y'] = y,
                ['z'] = z,
            }
            private.cache:add('position', position, 0.1)
        end
        return position
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

    return public
end

return class