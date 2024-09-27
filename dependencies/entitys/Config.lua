local class = {}
function class:new(_base, _name, _default, _force)
    local this = {}
    local private = {
        ['name'] = (_name or 'config') .. '.ini',
        ['data'] = {},
        ['default'] = _default or {},
        ['force'] = _force or false,
        ['arrayName'] = 'json',
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- DATA

    function this:getData()
        return private.data
    end

    function private:setData(data)
        private.data = data
        return private
    end

    -- DEFAULT

    function this:getDefault()
        return private.default
    end

    function this:addDefault(title, default)
        private.default[title] = default
        return this
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
        local data = {}
        for title, values in pairs(private.data) do
            data[title] = data[title] or {}
            for name, value in pairs(values) do
                data[title][name] = value
                if type(value) == 'table' then
                    data.json = data.json or {}
                    data.json[private:getArrayDataName(title, name)] = _base:get('helper'):jsonEncode(value)
                    data[title][name] = private:getArrayName()
                end
            end
        end
        private.data = data
        return private
    end

    -- DISASSEMBLE

    function private:disassemble()
        local data = {}
        for title, values in pairs(private.data) do
            if title ~= private:getArrayName() then
                data[title] = data[title] or {}
                for name, value in pairs(values) do
                    data[title][name] = value
                    if value == private:getArrayName() then
                        data[title][name] = _base:get('helper'):jsonDecode(private.data.json[private:getArrayDataName(title, name)] or '[]')
                    end
                end
            end
        end
        private.data = data
        return private
    end

    -- LOAD

    function private:load()
        private:setData(_base:get('helper'):iniLoad(this:getDefault(), private:getName()))
        private:disassemble()
        return private
    end

    -- SAVE

    function private:save()
        private:collect()
        _base:get('helper'):iniSave(this:getData(), private:getName())
        private:disassemble()
        return private
    end

    -- INITS

    function private:init()
        if not private:isForce() then
            private:load()
        end
        private:save()
        return this
    end

    return private:init()
end
return class