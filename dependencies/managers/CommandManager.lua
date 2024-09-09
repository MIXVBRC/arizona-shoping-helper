local class = {}
function class:new(_prefix)
    local public = {}
    local private = {
        ['prefix'] = _prefix,
    }

    function public:getCommandName(_name)
        if type(_name) == 'table' then
            _name = _sh.helper:implode('-', _name)
        end
        return _sh.helper:implode('-', {_sh.script.command, private.prefix, _name})
    end

    function public:getCommandMessageName(_name)
        if type(_name) == 'table' then
            _name = _sh.helper:implode('_', _name)
        end
        return 'command_' .. _sh.helper:implode('_', {_sh.script.command, private.prefix, _name}) .. '_description'
    end

    function public:add(_name, _function)
        local command = public:getCommandName(_name)
        table.insert(_sh.commands, {
            ['command'] = command,
            ['message'] = public:getCommandMessageName(_name),
            ['_function'] = _function,
        })
        sampRegisterChatCommand(
            command,
            _function
        )
    end

    return public
end

return class