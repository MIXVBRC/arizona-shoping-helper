local class = {}
function class:new(_prefix)
    local public = {}
    local private = {
        ['prefix'] = _prefix,
        -- ['commands'] = {},
    }

    function public:getCommandName(_name)
        return _sh.helper:implode('-', {_sh.script.command, private.prefix, _name})
    end

    function public:add(_name, _function)
        local command = public:getCommandName(_name)
        table.insert(_sh.commands, {
            ['name'] = command,
            ['_function'] = _function,
            ['description'] = _sh.message:get('command_'..command..'_description') or '',
        })
        sampRegisterChatCommand(
            command,
            _function
        )
    end

    return public
end

return class