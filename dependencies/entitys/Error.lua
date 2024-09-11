local class = {}
function class:new(base, _message)
    local this = {}
    local private = {
        ['message'] = _message,
        ['color'] = 'ff4d4d',
        ['prefix'] = '[Error]: ',
        ['postfix'] = '!',
    }

    function private:init()
        base:getObject('chat'):new(base):addPrefix(private.prefix):addPostfix(private.postfix):setColor(private.color):push(private.message)
    end

    private:init()
    return this
end
return class