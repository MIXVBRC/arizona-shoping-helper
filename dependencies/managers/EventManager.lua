local class = {}
function class:new()
    local this = {}
    local private = {
        ['triggers'] = {},
    }

    function this:add(name, trigger, sort)
        private.triggers[name] = private.triggers[name] or {}
        table.insert(private.triggers[name], {
            ['sort'] = sort or 100,
            ['entity'] = trigger,
        })
        table.sort(private.triggers[name], function (a, b) return a.sort < b.sort end)
    end

    function this:trigger(name, ...)
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
            return this:trigger('onShowTextDraw', ...)
        end
        function _sh.dependencies.events.onTextDrawSetString(...)
            return this:trigger('onTextDrawSetString', ...)
        end
        function _sh.dependencies.events.onSendClickTextDraw(...)
            return this:trigger('onSendClickTextDraw', ...)
        end
        function _sh.dependencies.events.onShowDialog(...)
            return this:trigger('onShowDialog', ...)
        end
        function _sh.dependencies.events.onSendDialogResponse(...)
            return this:trigger('onSendDialogResponse', ...)
        end
    end

    private:init()
    return this
end
return class