local class = {}
function class:new(_prefix)
    local public = {}
    local private = {
        ['prefix'] = _prefix,
    }

    function public:getCommandName(_name)
        return table.concat({_sh.script.command, private.prefix, _name}, '-')
    end

    function public:getCommandMessageName(_name)
        return 'command_' .. table.concat({_sh.script.command, private.prefix, _name}, '_') .. '_description'
    end

    function public:add(_name, _function)
        local command = public:getCommandName(_name)
        table.insert(_sh.commands, {
            ['name'] = command,
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