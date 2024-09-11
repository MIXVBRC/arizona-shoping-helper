local class = {}
function class:new(base)
    local this = {}
    local private = {
        ['time'] = 86400,
        ['cache'] = {},
    }

    function private:checkTime(time)
        return os.clock() < time
    end

    function this:add(name, data, time)
        time = time or private.time
        if data ~= nil then
            private.cache[name] = {
                ['time'] = os.clock() + time,
                ['data'] = data,
            }
        end
    end

    function this:get(name)
        local cache = private.cache[name]
        if cache ~= nil then
            if private:checkTime(cache.time) then
                return cache.data
            end
        end
        this:clear(name)
        return nil
    end

    function this:clear(name)
        if name ~= nil then
            private.cache[name] = nil
        else
            private.cache = {}
        end
        return this
    end

    return this
end
return class