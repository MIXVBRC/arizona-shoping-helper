local class = {}
function class:new()
    local this = {}
    local private = {
        ['indexes'] = {},
        ['table'] = {},
    }

    function this:get(key)
        if key ~= nil then
            return private.table[private.indexes[key]]
        end
        return private.table
    end

    function this:add(key, value)
        table.insert(private.table, value)
        private.indexes[key] = #private.table
        return this
    end

    function this:set(key, value)
        if private.indexes[key] ~= nil then
            private.table[private.indexes[key]] = value
        end
        return this
    end

    function this:remove(key)
        table.remove(private.table, private.indexes[key])
        for index = private.indexes[key], #private.table do
            for k, i in pairs(private.indexes) do
                if index + 1 == i then
                    private.indexes[k] = index
                end
            end
        end
        private.indexes[key] = nil
        return this
    end

    function this:clear()
        private.table = {}
        private.indexes = {}
        return this
    end

    return this
end
return class