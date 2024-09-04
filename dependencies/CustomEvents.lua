local class = {}
function class:new()
    local public = {}
    local private = {
        ['events'] = {}
    }

    function public:add(_name, _function)
        private.events[_name] = _function
    end

    function public:trigger(_name, ...)
        local _event = private.events[_name]
        if _event ~= nil and type(_event) == 'function' then
            _event(...)
        end
    end

    return public
end
return class