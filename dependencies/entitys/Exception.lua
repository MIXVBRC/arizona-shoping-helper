local class = {}
function class:new(_message)
    local this = {}
    local private = {
        ['message'] = _message
    }

    function private:init()
        _sh.dependencies.error:new(private.message)
        error(private.message, 4)
    end

    private:init()
    return this
end
return class