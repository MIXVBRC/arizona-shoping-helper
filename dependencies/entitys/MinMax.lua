local this = {}
function this:new(base, _minmax)
    local class = {}
    local private = {
        ['minmax'] = _minmax,
    }

    function class:getMin(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].min
    end

    function class:getMax(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].max
    end

    function class:get(num, name)
        local min = class:getMin(name) or num
        local max = class:getMax(name) or num
        if num < min then num = min
        elseif num > max then num = max
        end
        return num
    end

    return class
end
return this