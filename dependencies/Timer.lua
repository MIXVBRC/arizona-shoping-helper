local class = {}
function class:new()
    local public = {}
    local private = {
        ['time'] = 0,
    }

    function private:setTime(time)
        private.time = time
        return public
    end

    function private:getTime()
        return private.time
    end

    function public:start()
        private:setTime(os.clock())
    end

    function public:stop()
        local time = 0
        if private:getTime() > 0 then
            time = os.clock() - private:getTime()
        end
        private:setTime(0)
        return time
    end

    return public
end
return class