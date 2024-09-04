local class = {}
function class:new()
    local public = {}
    local private = {
        ['events'] = {},
    }

    function public:add(_name, _function)
        private.events[_name] = private.events[_name] or {}
        table.insert(private.events[_name], _function)
    end

    function public:trigger(_name, ...)
        local _functions = private.events[_name]
        if _functions ~= nil then
            for _, _function in ipairs(_functions) do
                if type(_function) == 'function' then
                    _function(...)
                end
            end
        end
    end

    function private:init()
        function _sh.dependencies.events.onTextDrawSetString(...)
            public:trigger('onTextDrawSetString', ...)
        end
    end

    private:init()
    return public
end
return class