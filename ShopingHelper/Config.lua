local class = {}
function class:new(_sh, _name, _default)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['name'] = (_name or 'config') .. '.ini',
        ['data'] = {
            ['json'] = {},
        },
        ['default'] = _default or {
            ['json'] = {},
        },
    }

    function private:getName()
        return private.name
    end

    function private:getDefault()
        return private.default
    end

    function private:getJsonName(title, name)
        return title .. '-' .. name
    end

    function private:decode(data)
        return private.sh.json:decode(data)
    end;

    function private:encode(data)
        return private.sh.json:encode(data)
    end;

    function private:addJson(title, name, data)
        private.data.json[private:getJsonName(title, name)] = private:encode(data)
        return public
    end

    function private:load()
        local data = private.sh.ini.load(private:getDefault(), private:getName())
        for _, json in pairs(data.json) do
            json = private:decode(json)
        end
        private.data = data
        return public
    end

    function private:save()
        local data = private.data
        for _, list in pairs(data.json) do
            list = private:encode(list)
        end
        private.sh.ini.save(data, private:getName())
        return public
    end

    function public:get(title, name)
        local data = nil
        if private.data[title] ~= nil then
            data = private.data[title][name]
            if data == 'json' then
                data = private.data.json[private:getJsonName(title, name)]
            end
            return private.data[title][name]
        end
        return data
    end

    function public:set(title, name, data)
        if title ~= 'json' and data ~= 'json' then
            if type(data) == 'table' then
                private:addJson(title, name, data)
                data = 'json'
            end
            if private.data[title] == nil then
                private.data[title] = {}
            end
            private.data[title][name] = data
            private:save()
        end
        return public
    end

    function public:init()
        if private.default.json == nil then
            private.default.json = {}
        end
        for title, settings in pairs(private.default) do
            if title ~= 'json' then
                for name, data in pairs(settings) do
                    if type(data) == 'table' then
                        private.default.json[private:getJsonName(title, name)] = private:encode(data)
                        data = 'json'
                    end
                end
            end
        end
        private:load()
        private:save()
        return public
    end

    public:init()
    return public
end
return class