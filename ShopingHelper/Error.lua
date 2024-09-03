local class = {}
function class:new(_message)
    local public = {}
    local private = {
        ['message'] = _message,
        ['color'] = 'ff4d4d',
        ['prefix'] = '[Error]: ',
        ['postfix'] = '!',
    }

    function private:init()
        _sh.dependencies.chat:new():addPrefix(private.prefix):addPostfix(private.postfix):setColor(private.color):push(private.message)
    end

    private:init()
    return public
end
return class