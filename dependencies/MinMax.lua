local class = {}
function class:new(_minmax)
    local public = {}
    local private = {
        ['minmax'] = _minmax,
    }

    function private:getMin(name)
        if private.minmax[name] ~= nil then
            return private.minmax[name].min
        end
        return nil
    end

    function private:getMax(name)
        if private.minmax[name] then
            return private.minmax[name].max
        end
        return nil
    end

    function public:get(num, name)
        local min = private:getMin(name)
        local max = private:getMax(name)
        if min ~= nil and num < min then
            num = min
        elseif max ~= nil and num > max then
            num = max
        end
        return num
    end

    return public
end
return class