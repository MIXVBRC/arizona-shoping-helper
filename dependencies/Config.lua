local class = {}
function class:new(_name, _default)
    local public = {}
    local private = {
        ['name'] = (_name or 'config') .. '.ini',
        ['data'] = _default or {},
    }

    function private:getName()
        return private.name
    end

    function private:getJsonName(title, name)
        return title .. '-' .. name
    end

    function public:get(title, name)
        if private.data[title] ~= nil then
            return private.data[title][name]
        end
        return nil
    end

    function public:set(title, name, data)
        if title ~= 'json' and data ~= 'json' then
            private.data[title] = private.data[title] or {}
            private.data[title][name] = data
            private:save()
        end
        return public
    end

    function private:collect()
        for title, values in pairs(private.data) do
            for name, value in pairs(values) do
                if type(value) == 'table' then
                    private.data.json = private.data.json or {}
                    private.data.json[private:getJsonName(title, name)] = _sh.helper:jsonEncode(value)
                    private.data[title][name] = 'json'
                end
            end
        end
    end

    function private:disassemble()
        for title, values in pairs(private.data) do
            if title ~= 'json' then
                private.data[title] = {}
                for name, value in pairs(values) do
                    private.data[title][name] = value
                    if value == 'json' then
                        private.data[title][name] = _sh.helper:jsonDecode(private.data.json[private:getJsonName(title, name)])
                    end
                end
            end
        end
    end

    function private:load()
        private:collect()
        private.data = _sh.ini.load(private.data, private:getName())
        private:disassemble()
        return public
    end

    function private:save()
        private:collect()
        _sh.ini.save(private.data, private:getName())
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