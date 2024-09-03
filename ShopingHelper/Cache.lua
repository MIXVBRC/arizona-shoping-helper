local class = {}
function class:new()
    local public = {}
    local private = {
        ['time'] = (60 * 60 * 24),
        ['cache'] = {},
    }

    function private:checkTime(time)
        return os.clock() < time
    end

    function public:add(name, data, time)
        time = time or private.time
        if data ~= nil then
            private.cache[name] = {
                ['time'] = os.clock() + time,
                ['data'] = data,
            }
        end
    end

    function public:get(name)
        local cache = private.cache[name]
        if cache ~= nil then
            if private:checkTime(cache.time) then
                return cache.data
            end
        end
        public:clear(name)
        return nil
    end

    function public:clear(name)
        if name ~= nil then
            private.cache[name] = nil
        else
            private.cache = {}
        end
        return public
    end

    return public
end
return class