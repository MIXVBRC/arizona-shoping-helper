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
        local result = nil
        local _functions = private.events[_name]
        if _functions ~= nil then
            for _, _function in ipairs(_functions) do
                if type(_function) == 'function' then
                    result = _function(...)
                    if result ~= nil then
                        return result
                    end
                end
            end
        end
    end

    function private:init()
        function _sh.dependencies.events.onShowTextDraw(...)
            return public:trigger('onShowTextDraw', ...)
        end
        function _sh.dependencies.events.onTextDrawSetString(...)
            return public:trigger('onTextDrawSetString', ...)
        end
        function _sh.dependencies.events.onSendClickTextDraw(...)
            return public:trigger('onSendClickTextDraw', ...)
        end
        function _sh.dependencies.events.onShowDialog(...)
            return public:trigger('onShowDialog', ...)
        end
    end

    private:init()
    return public
end
return class