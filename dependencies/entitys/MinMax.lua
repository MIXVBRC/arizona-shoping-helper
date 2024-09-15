local class = {}
function class:new(_base, _minmax)
    local this = {}
    local private = {
        ['minmax'] = _minmax,
    }

    function this:getMin(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].min
    end

    function this:getMax(name)
        private.minmax[name] = private.minmax[name] or {}
        return private.minmax[name].max
    end

    function this:get(num, name)
        local min = this:getMin(name) or num
        local max = this:getMax(name) or num
        if num < min then num = min
        elseif num > max then num = max
        end
        return num
    end

    return this
end
return class