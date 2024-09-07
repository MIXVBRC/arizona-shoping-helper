local class = {}
function class:new(_name, _default)
    local public = {}
    local private = {
        ['name'] = (_name or 'config') .. '.ini',
        ['data'] = _default or {},
        ['arrayName'] = 'json',
    }

    function private:getName()
        return private.name
    end

    function private:getArrayName()
        return private.arrayName
    end

    function private:getArrayDataName(title, name)
        return title .. '-' .. name
    end

    function public:get(title, name)
        if private.data[title] ~= nil then
            return private.data[title][name]
        end
        return nil
    end

    function public:set(title, name, data)
        if title ~= private:getArrayName() and data ~= private:getArrayName() then
            private.data[title] = private.data[title] or {}
            private.data[title][name] = data
            private:save()
        end
        return public
    end

    function public:delete(_title, _name)
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
        return public
    end

    function private:collect()
        for title, values in pairs(private.data) do
            for name, value in pairs(values) do
                if type(value) == 'table' then
                    private.data.json = private.data.json or {}
                    private.data.json[private:getArrayDataName(title, name)] = _sh.helper:jsonEncode(value)
                    private.data[title][name] = private:getArrayName()
                end
            end
        end
    end

    function private:disassemble()
        for title, values in pairs(private.data) do
            if title ~= private:getArrayName() then
                private.data[title] = {}
                for name, value in pairs(values) do
                    private.data[title][name] = value
                    if value == private:getArrayName() then
                        private.data[title][name] = _sh.helper:jsonDecode(private.data.json[private:getArrayDataName(title, name)] or '[]')
                    end
                end
            end
        end
    end

    function private:load()
        private:collect()
        private.data = _sh.helper:iniLoad(private.data, private:getName())
        private:disassemble()
        return public
    end

    function private:save()
        private:collect()
        _sh.helper:iniSave(private.data, private:getName())
        private:disassemble()
        return public
    end

    function public:init()
        private:load()
        private:save()
        return public
    end

    public:init()
    return public
end
return class