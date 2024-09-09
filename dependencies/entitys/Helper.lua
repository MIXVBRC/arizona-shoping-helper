local class = {}
function class:new(_symbols)
    local public = {}
    local private = {
        ['symbols'] = _symbols or {},
    }

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
        return _sh.dependencies.md5.sumhexa(string)
    end

    function public:jsonDecode(json)
        return _sh.dependencies.json.decode(json)
    end

    function public:jsonEncode(array)
        return _sh.dependencies.json.encode(array)
    end

    function public:iniLoad(default, name)
        return _sh.dependencies.ini.load(default, name)
    end

    function public:iniSave(data, name)
        _sh.dependencies.ini.save(data, name)
        return public
    end

    function public:textDecode(text)
        local result = {}
        text:gsub('.',
            function(symbol)
                table.insert(result, private.symbols.decode[symbol] or symbol)
            end
        )
        return _sh.helper:implode('', result)
    end

    function public:textEncode(text)
        local result = {}
        text:gsub('.',
            function(symbol)
                table.insert(result, private.symbols.encode[symbol] or symbol)
            end
        )
        return _sh.helper:implode('', result)
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

    function public:explode(separator, text)
        separator = separator or '.'
        local result = {}
        for part in string.gmatch(text, "([^"..separator.."]+)") do
            table.insert(result, part)
        end
        return result
    end

    function public:implode(separator, array, from, to)
        return table.concat(array, separator or '', from or 1, to or #array)
    end

    function public:trim(text)
        text = tostring(text)
        return text:gsub('^%s+', ''):gsub('%s+$', '')
    end

    function public:isNumber(text)
        if text:find('^%d+$') then
            return true
        end
        return false
    end

    function public:getNumber(text)
        text = tostring(text)
        text = text:match('%d+')
        text = tonumber(text)
        return text or 0
    end

    function public:isPrice(text)
        text = text:gsub('%s+', ''):gsub(',', '')
        if text:find('^.*$%d+$') then
            return true
        end
        return false
    end

    function public:isVCPrice(text)
        text = text:gsub('%s+', ''):gsub(',', '')
        if text:find('^VC%$%d+$') then
            return true
        end
        return false
    end

    function public:formatPrice(price)
        price = public:getNumber(price)
        price = tostring(price)
        return '$'..price:reverse():gsub('(%d%d%d)','%1.'):gsub('(%d%d%d).$','%1'):reverse()
    end

    function public:extractPrice(price)
        if public:isVCPrice(price) then
            price = price:gsub('%s+', ''):gsub('^VC%$',''):gsub(',',''):gsub('%s', '')
        else
            price = price:gsub('%s+', ''):gsub('^%$',''):gsub(',',''):gsub('%s', '')
        end
        price = public:getNumber(price)
        return price
    end

    function public:removeColors(text)
        return tostring(text:gsub('{%w%w%w%w%w%w}', ''))
    end

    return public
end
return class