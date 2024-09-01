local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
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
        return private.sh.md5.sumhexa(string)
    end

    function public:utf8(string)
        private.sh.encoding.default = 'CP1251'
        return (private.sh.encoding.UTF8):decode(string)
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

    return public
end
return class