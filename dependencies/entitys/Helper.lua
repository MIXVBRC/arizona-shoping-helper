local class = {}
function class:new(_symbols)
    local this = {}
    local private = {
        ['symbols'] = _symbols or {},
    }

    function this:normalize(num, index)
        index = index or 1000
        num = math.floor(num * index) / index
        return num
    end

    function this:normalizePosition(x, y, z, index)
        return {
            ['x'] = this:normalize(x, index),
            ['y'] = this:normalize(y, index),
            ['z'] = this:normalize(z, index),
        }
    end

    function this:md5(string)
        return _sh.dependencies.md5.sumhexa(string)
    end

    function this:jsonDecode(json)
        return _sh.dependencies.json.decode(json)
    end

    function this:jsonEncode(array)
        return _sh.dependencies.json.encode(array)
    end

    function this:iniLoad(default, name)
        return _sh.dependencies.ini.load(default, name)
    end

    function this:iniSave(data, name)
        _sh.dependencies.ini.save(data, name)
        return this
    end

    function this:textDecode(text)
        local result = {}
        text:gsub('.',
            function(symbol)
                table.insert(result, private.symbols.decode[symbol] or symbol)
            end
        )
        return _sh.helper:implode('', result)
    end

    function this:textEncode(text)
        local result = {}
        text:gsub('.',
            function(symbol)
                table.insert(result, private.symbols.encode[symbol] or symbol)
            end
        )
        return _sh.helper:implode('', result)
    end

    function this:getObjectsByIds(ids)
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

    function this:getTextIds()
        local textIds = {}
        for textId = 0, 2048 do
            if sampIs3dTextDefined(textId) then
                table.insert(textIds, textId)
            end
        end
        return textIds
    end

    function this:getAngle(x, y)
        local angle = math.atan2(x, y) / math.pi * 180
        if angle < 0 then
            angle = angle + 360
        end
        return angle
    end

    function this:tableClone(_table)
        return {table.unpack(_table)}
    end

    function this:trace(aX, aY, aZ, bX, bY, bZ)
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

    function this:omitPosition(_x, _y, _z, index)
        index = index or 10
        local position = {
            ['x'] = _x,
            ['y'] = _y,
            ['z'] = _z,
        }
        local trace = this:trace(
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

    function this:distanceToPlayer2d(_x, _y)
        return getDistanceBetweenCoords2d(_sh.player:getX(), _sh.player:getY(), _x, _y)
    end

    function this:distanceToPlayer3d(_x, _y, _z)
        return getDistanceBetweenCoords3d(_sh.player:getX(), _sh.player:getY(), _sh.player:getZ(), _x, _y, _z)
    end

    function this:explode(separator, text)
        separator = separator or '.'
        local result = {}
        for part in string.gmatch(text, "([^"..separator.."]+)") do
            table.insert(result, part)
        end
        return result
    end

    function this:implode(separator, array, from, to)
        from = from or 1
        to = to or #array
        for index, value in ipairs(array) do
            if value == '' or value == nil then
                if index < from then
                    from = from - 1
                end
                if index <= to then
                    to = to - 1
                end
                table.remove(array, index)
            end
        end
        return table.concat(array, separator or '', from, to)
    end

    function this:trim(text)
        text = tostring(text)
        return text:gsub('^%s+', ''):gsub('%s+$', '')
    end

    function this:isNumber(text)
        if text:find('^%d+$') then
            return true
        end
        return false
    end

    function this:getNumber(text)
        text = tostring(text)
        text = text:match('%d+')
        text = tonumber(text)
        return text or 0
    end

    function this:isPrice(text)
        text = text:gsub('%s+', ''):gsub(',', '')
        if text:find('^.*$%d+$') then
            return true
        end
        return false
    end

    function this:isVCPrice(text)
        text = text:gsub('%s+', ''):gsub(',', '')
        if text:find('^VC%$%d+$') then
            return true
        end
        return false
    end

    function this:formatPrice(price)
        price = this:getNumber(price)
        price = tostring(price)
        return '$'..price:reverse():gsub('(%d%d%d)','%1.'):gsub('(%d%d%d).$','%1'):reverse()
    end

    function this:extractPrice(price)
        if this:isVCPrice(price) then
            price = price:gsub('%s+', ''):gsub('^VC%$',''):gsub(',',''):gsub('%s', '')
        else
            price = price:gsub('%s+', ''):gsub('^%$',''):gsub(',',''):gsub('%s', '')
        end
        price = this:getNumber(price)
        return price
    end

    function this:removeColors(text)
        return tostring(text:gsub('{%w%w%w%w%w%w}', ''))
    end

    return this
end
return class