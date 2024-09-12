local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['commands'] = {}
    }

    function private:getCommands()
        return private.commands
    end

    function private:addCommand(command)
        table.insert(private.commands, command)
        return this
    end

    function this:getCommandName(_name)
        if type(_name) == 'table' then
            _name = _base:get('helper'):implode('-', _name)
        end
        return _base:get('helper'):implode('-', {_base:getCommand(), _name})
    end

    function this:getCommandMessageName(_name)
        if type(_name) == 'table' then
            _name = _base:get('helper'):implode('_', _name)
        end
        return 'command_' .. _base:get('helper'):implode('_', {_base:getCommand(), _name}) .. '_description'
    end

    function this:add(_name, _function)
        local command = this:getCommandName(_name)
        private:addCommand({
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