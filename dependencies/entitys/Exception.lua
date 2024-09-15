local class = {}
function class:new(_base, _message)
    local this = {}
    local private = {
        ['message'] = _message
    }

    function private:init()
        _base:getNew('error', private.message)
        error(private.message, 4)
        return this
    end

    return private:init()
end
return class