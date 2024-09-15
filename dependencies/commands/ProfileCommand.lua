local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        return this
    end

    return private:init()
end
return class