local this = {}
function this:new(_base)
    local class = {}
    local private = {
        ['base'] = 'onEvent',
        ['triggers'] = {},
    }

    function private:getBaseEvent()
        return private.base
    end

    function class:add(name, trigger, sort)
        private.triggers[name] = private.triggers[name] or {}
        table.insert(private.triggers[name], {
            ['sort'] = sort or 100,
            ['entity'] = trigger,
        })
        table.sort(private.triggers[name], function (a, b) return a.sort < b.sort end)
        return class
    end

    function class:trigger(name, ...)
        local result = nil
        local triggers = private.triggers[name]
        if name ~= private:getBaseEvent() then
            result = class:trigger(private:getBaseEvent(), name, ...)
            if result ~= nil then
                return result
            end
        end
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
        local events = _base:getObject('events')
        function events.onShowTextDraw(...)
            return class:trigger('onShowTextDraw', ...)
        end
        function events.onTextDrawSetString(...)
            return class:trigger('onTextDrawSetString', ...)
        end
        function events.onSendClickTextDraw(...)
            return class:trigger('onSendClickTextDraw', ...)
        end
        function events.onShowDialog(...)
            return class:trigger('onShowDialog', ...)
        end
        function events.onSendDialogResponse(...)
            return class:trigger('onSendDialogResponse', ...)
        end
    end

    private:init()
    return class
end
return this