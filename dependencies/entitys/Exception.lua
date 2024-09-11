local class = {}
function class:new(base, _message)
    local this = {}
    local private = {
        ['message'] = _message
    }

    function private:init()
        base:getObject('error'):new(base, private.message)
        error(private.message, 4)
    end

    private:init()
    return this
end
return class