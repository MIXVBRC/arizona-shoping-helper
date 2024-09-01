local class = {}
function class:new(_time)
    local public = {}
    local private = {
        ['time'] = _time or (60 * 60 * 24),
        ['cache'] = {},
    }

    function private:checkTime(time)
        return os.clock() < time
    end

    function public:add(key, data, time)
        time = time or private.time
        if data ~= nil then
            private.cache[key] = {
                ['time'] = os.clock() + time,
                ['data'] = data,
            }
        end
    end

    function public:get(key)
        local cache = private.cache[key]
        if cache ~= nil then
            if private:checkTime(cache.time) then
                return cache.data
            else
                private.cache[key] = nil
            end
        end
        return nil
    end

    return public
end
return class