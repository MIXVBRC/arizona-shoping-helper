local class = {}
function class:new(_base, _message)
    local this = {}
    local private = {
        ['message'] = _message
    }

    function private:init()
        _base:getInit('error', private.message)
        error(private.message, 4)
    end

    private:init()
    return this
end
return class