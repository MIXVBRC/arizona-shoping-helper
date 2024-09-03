local class = {}
function class:new()
    local public = {}

    function public:normalize(num, index)
        index = index or 1000
        num = math.floor(num * index) / index
        return num
    end

    function public:normalizePosition(x, y, z, index)
        return {
            ['x'] = public:normalize(x, index),
            ['y'] = public:normalize(y, index),
            ['z'] = public:normalize(z, index),
        }
    end

    function public:md5(string)
        return _sh.md5.sumhexa(string)
    end

    function public:utf8(string)
        _sh.encoding.default = 'CP1251'
        return _sh.encoding.UTF8:decode(string)
    end

    function public:getObjectsByIds(ids)
        local objects = {}
        for _, object in ipairs(getAllObjects()) do
            local objectId = getObjectModel(object)
            for _, id in ipairs(ids) do
                if objectId == id then
                    table.insert(objects, object)
                end
            end
        end
        return objects
    end

    function public:getTextIds()
        local textIds = {}
        for textId = 0, 2048 do
            if sampIs3dTextDefined(textId) then
                table.insert(textIds, textId)
            end
        end
        return textIds
    end

    function public:getAngle(x, y)
        local angle = math.atan2(x, y) / math.pi * 180
        if angle < 0 then
            angle = angle + 360
        end
        return angle
    end

    function public:tableClone(_table)
        return {table.unpack(_table)}
    end

    function public:trace(aX, aY, aZ, bX, bY, bZ)
        local touch, data = processLineOfSight(
            aX, aY, aZ,
            bX, bY, bZ
        )
        local position = nil
        if data ~= nil then
            position = {
                ['x'] = data.pos[1],
                ['y'] = data.pos[2],
                ['z'] = data.pos[3],
            }
        end
        return {
            ['touch'] = touch,
            ['position'] = position,
        }
    end

    function public:omitPosition(_x, _y, _z, index)
        index = index or 10
        local position = {
            ['x'] = _x,
            ['y'] = _y,
            ['z'] = _z,
        }
        local trace = public:trace(
            position.x, position.y, position.z + index,
            position.x, position.y, position.z - index
        )
        if trace.touch and trace.position ~= nil then
            position = {
                ['x'] = trace.position.x,
                ['y'] = trace.position.y,
                ['z'] = trace.position.z,
            }
        end
        return position
    end

    function public:distanceToPlayer2d(_x, _y)
        return getDistanceBetweenCoords2d(_sh.player:getX(), _sh.player:getY(), _x, _y)
    end

    function public:distanceToPlayer3d(_x, _y, _z)
        return getDistanceBetweenCoords3d(_sh.player:getX(), _sh.player:getY(), _sh.player:getZ(), _x, _y, _z)
    end

    function public:implode(separator, array)
        local collect = ''
        for _, value in ipairs(array) do
            if collect == '' then
                collect = value
            else
                collect = collect .. separator .. value
            end
        end
        return collect
    end

    function public:toInt(string)
        string = tostring(string);
        string = string:match('%d+');
        string = tonumber(string);
        return string;
    end

    return public
end
return class