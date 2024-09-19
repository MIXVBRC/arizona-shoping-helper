local class = {}
function class:new(_base, _name, _default, _force)
    local this = {}
    local private = {
        ['name'] = (_name or 'config') .. '.ini',
        ['data'] = _default or {},
        ['force'] = _force or false,
        ['arrayName'] = 'json',
        ['params'] = {},
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- FORCE

    function private:isForce()
        return private.force
    end

    -- ARRAY NAME

    function private:getArrayName()
        return private.arrayName
    end

    -- ARRAY DATA NAME

    function private:getArrayDataName(title, name)
        return title .. '-' .. name
    end
    
    -- DEFAULT

    function this:getParams()
        return private.params
    end

    function private:addParam(title, name)
        private.params[title] = private.params[title] or {}
        private.params[title][name] = true
        _base:get('chat'):push(title .. ' | ' .. name)
        return private
    end

    -- GET

    function this:get(title, name)
        if private.data[title] ~= nil then
            return private.data[title][name]
        end
        return nil
    end

    -- SET

    function this:set(title, name, data)
        if title ~= private:getArrayName() and data ~= private:getArrayName() then
            private:addParam(title, name)
            private.data[title] = private.data[title] or {}
            private.data[title][name] = data
            private:save()
        end
        return this
    end

    -- DELETE

    function this:delete(_title, _name)
        if _title ~= private:getArrayName() then
            local data = {}
            local jsonName = private:getArrayDataName(_title, _name)
            for title, values in pairs(private.data) do
                for name, value in pairs(values) do
                    if (title == private:getArrayName() and jsonName ~= name) or (title ~= private:getArrayName() and _name ~= name) then
                        data[title] = data[title] or {}
                        data[title][name] = value
                    end
                end
            end
            private.data = data
            private:save()
        end
        return this
    end

    -- COLLECT

    function private:collect()
        for title, values in pairs(private.data) do
            for name, value in pairs(values) do
                if type(value) == 'table' then
                    private.data.json = private.data.json or {}
                    private.data.json[private:getArrayDataName(title, name)] = _base:get('helper'):jsonEncode(value)
                    private.data[title][name] = private:getArrayName()
                end
            end
        end
        return private
    end

    -- DISASSEMBLE

    function private:disassemble()
        for title, values in pairs(private.data) do
            if title ~= private:getArrayName() then
                private.data[title] = {}
                for name, value in pairs(values) do
                    private.data[title][name] = value
                    if value == private:getArrayName() then
                        private.data[title][name] = _base:get('helper'):jsonDecode(private.data.json[private:getArrayDataName(title, name)] or '[]')
                    end
                end
            end
        end
        return private
    end

    -- LOAD

    function private:load()
        private:collect()
        private.data = _base:get('helper'):iniLoad(private.data, private:getName())
        private:disassemble()
        return private
    end

    -- SAVE

    function private:save()
        private:collect()
        _base:get('helper'):iniSave(private.data, private:getName())
        private:disassemble()
        return private
    end

    -- INITS

    function private:init()
        if not private:isForce() then
            private:load()
        end
        private:initParams():save()
        return this
    end

    function private:initParams()
        for title, values in ipairs(private.data) do
            if title ~= private:getArrayName() then
                for name, _ in pairs(values) do
                    private:addParam(title, name)
                end
            end
        end
        return private
    end

    return private:init()
end
return class