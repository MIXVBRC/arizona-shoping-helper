local class = {}
function class:new()
    local public = {}
    local private = {
        ['triggers'] = {},
        ['doubleClick'] = nil
    }

    function public:add(name, trigger, sort)
        private.triggers[name] = private.triggers[name] or {}
        table.insert(private.triggers[name], {
            ['sort'] = sort or 100,
            ['entity'] = trigger,
        })
        table.sort(private.triggers[name], function (a, b) return a.sort < b.sort end)
    end

    function public:trigger(name, ...)
        local result = nil
        local triggers = private.triggers[name]
        if triggers ~= nil then
            for _, trigger in ipairs(triggers) do
                if type(trigger.entity) == 'function' then
                    result = trigger.entity(...)
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
        function _sh.dependencies.events.onSendDialogResponse(...)
            return public:trigger('onSendDialogResponse', ...)
        end
    end

    private:init()
    return public
end
return class