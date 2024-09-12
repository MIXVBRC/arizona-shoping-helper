local class = {}
function class:new(_, _execute)
    local this = {}
    local private = {
        ['active'] = false,
        ['execute'] = _execute,
        ['events'] = {},
    }

    -- ACTIVE

    function this:isActive()
        return private.active
    end

    function this:active()
        private.active = true
        return this
    end

    -- EXECUTE

    function this:getExecute()
        return private.execute
    end

    -- EVENTS

    function this:getEvent(name)
        return private.events[name]
    end

    function this:addEvent(name, trigger)
        private.events[name] = trigger
        return this
    end

    return this
end
return class