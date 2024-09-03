local class = {}
function class:new(_prefix)
    local public = {}
    local private = {
        ['prefix'] = _prefix,
        ['commands'] = {},
    }

    function public:getCommandName(_name)
        return _sh.helper:implode('-', {_sh.script.command, private.prefix, _name})
    end

    function public:add(_name, _function)
        local command = public:getCommandName(_name)
        private.commands[command] = {
            ['_function'] = _function,
            ['description'] = _sh.message:get('command_'..command..'_description'),
        }
        sampRegisterChatCommand(
            command,
            _function
        )
    end

    return public
end

return class