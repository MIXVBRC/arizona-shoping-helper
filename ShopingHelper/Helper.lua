local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['cache'] = _sh.dependencies.cache:new(1),
    }

    function public:normalizePosition(x, y, z, index)
        index = index or 1000
        x = math.floor(x * index) / index
        y = math.floor(y * index) / index
        z = math.floor(z * index) / index
        return {
            ['x'] = x,
            ['y'] = y,
            ['z'] = z,
        }
    end

    function public:md5(string)
        return private.sh.md5.sumhexa(string)
    end

    function public:utf8(string)
        private.sh.encoding.default = 'CP1251'
        return (private.sh.encoding.UTF8):decode(string)
    end

    function public:getObjectsByIds(ids, cacheTime)
        local cacheKey = 'objects_' .. private.sh.json:encode(ids)
        local objects = private.cache:get(cacheKey)
        if objects == nil then
            objects = {}
            for _, object in ipairs(getAllObjects()) do
                local objectId = getObjectModel(object)
                for _, id in ipairs(ids) do
                    if objectId == id then
                        table.insert(objects, object)
                    end
                end
            end
            private.cache:add(cacheKey, objects, cacheTime)
        end
        return objects
    end

    return public
end
return class