local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['base'] = 'onEvent',
        ['triggers'] = {},
    }

    function private:getBaseEvent()
        return private.base
    end

    function this:add(name, trigger, sort)
        private.triggers[name] = private.triggers[name] or {}
        table.insert(private.triggers[name], {
            ['sort'] = sort or 100,
            ['entity'] = trigger,
        })
        table.sort(private.triggers[name], function (a, b) return a.sort < b.sort end)
        return this
    end

    function this:trigger(name, ...)
        local result = nil
        local triggers = private.triggers[name]
        if name ~= private:getBaseEvent() then
            result = this:trigger(private:getBaseEvent(), name, ...)
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
            return this:trigger('onShowTextDraw', ...)
        end
        function events.onTextDrawSetString(...)
            return this:trigger('onTextDrawSetString', ...)
        end
        function events.onSendClickTextDraw(...)
            return this:trigger('onSendClickTextDraw', ...)
        end
        function events.onShowDialog(...)
            return this:trigger('onShowDialog', ...)
        end
        function events.onSendDialogResponse(...)
            return this:trigger('onSendDialogResponse', ...)
        end
        function events.onServerMessage(...)
            return this:trigger('onServerMessage', ...)
        end
        function events.onSendChat(...)
            return this:trigger('onSendChat', ...)
        end
        function events.onSendCommand(...)
            return this:trigger('onSendCommand', ...)
        end
        return this
    end

    return private:init()
end
return class