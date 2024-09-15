local class = {}
function class:new()
    local this = {}
    local private = {
        ['time'] = 0,
    }

    function private:setTime(time)
        private.time = time
        return private
    end

    function private:getTime()
        return private.time
    end

    function this:start()
        private:setTime(os.clock())
    end

    function this:stop()
        local time = 0
        if private:getTime() > 0 then
            time = os.clock() - private:getTime()
        end
        private:setTime(0)
        return time
    end

    return this
end
return class