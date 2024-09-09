local class = {}
function class:new(_prefix)
    local this = {}
    local private = {
        ['prefix'] = _prefix,
    }

    function this:getCommandName(_name)
        if type(_name) == 'table' then
            _name = _sh.helper:implode('-', _name)
        end
        return _sh.helper:implode('-', {_sh.script.command, private.prefix, _name})
    end

    function this:getCommandMessageName(_name)
        if type(_name) == 'table' then
            _name = _sh.helper:implode('_', _name)
        end
        return 'command_' .. _sh.helper:implode('_', {_sh.script.command, private.prefix, _name}) .. '_description'
    end

    function this:add(_name, _function)
        local command = this:getCommandName(_name)
        table.insert(_sh.commands, {
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