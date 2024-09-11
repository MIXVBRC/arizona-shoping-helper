local class = {}
function class:new(base)
    local this = {}

    function this:getCommandName(_name)
        if type(_name) == 'table' then
            _name = base:getClass('helper'):implode('-', _name)
        end
        return base:getClass('helper'):implode('-', {base:getCommand(), _name})
    end

    function this:getCommandMessageName(_name)
        if type(_name) == 'table' then
            _name = base:getClass('helper'):implode('_', _name)
        end
        return 'command_' .. base:getClass('helper'):implode('_', {base:getCommand(), _name}) .. '_description'
    end

    function this:add(_name, _function)
        local command = this:getCommandName(_name)
        base:addCommand({
            ['command'] = command,
            ['message'] = this:getCommandMessageName(_name),
            ['_function'] = _function,
        })
        sampRegisterChatCommand(
            command,
            _function
        )
        return this
    end

    return this
end

return class