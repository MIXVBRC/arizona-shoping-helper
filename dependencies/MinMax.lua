local class = {}
function class:new(_minmax)
    local public = {}
    local private = {
        ['minmax'] = _minmax,
    }

    function public:getMin(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].min
    end

    function public:getMax(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].max
    end

    function public:get(num, name)
        local min = public:getMin(name) or num
        local max = public:getMax(name) or num
        if num < min then num = min
        elseif num > max then num = max
        end
        return num
    end

    return public
end
return class