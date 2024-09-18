local class = {}
function class:new(_, _key, _table)
    local this = {}
    local private = {
        ['key'] = _key,
        ['indexes'] = {},
        ['table'] = _table or {},
    }

    function private:getKey()
        return private.key
    end

    function private:getIndex(key)
        return private.indexes[key]
    end

    function private:addIndex(key, index)
        private.indexes[key] = index
        return private
    end

    function private:recalculate()
        private.indexes = {}
        for index, value in ipairs(this:get()) do
            if value[private:getKey()] then
                private:addIndex(value[private:getKey()], index)
            else
                return nil
            end
        end
        return private
    end

    function this:get(key)
        if key ~= nil then
            return private.table[private:getIndex(key)]
        end
        return private.table
    end

    function this:add(value)
        if value[private:getKey()] ~= nil then
            table.insert(this:get(), value)
            private:addIndex(value[private:getKey()], #this:get())
        end
        return this
    end

    function this:set(array)
        private.table = array
        private:recalculate()
        return this
    end

    function this:update(key, value)
        if key ~= nil and value ~= nil and this:get(key) ~= nil then
            private.table[private:getIndex(key)] = value
        end
        return this
    end

    function this:remove(key)
        if key ~= nil then
            local index = private:getIndex(key)
            table.remove(private.table, index)
            for i = index, #private.table do
                private.indexes[private.table[i][private:getKey()]] = i
            end
        end
        return this
    end

    function this:clear()
        private.indexes = {}
        private.table = {}
        return this
    end

    -- INITS

    function private:init()
        if private:getKey() ~= nil then
            if #this:get() > 0 then
                private:recalculate()
            else
                this:clear()
            end
            return this
        end
        return nil
    end

    return private:init()
end
return class