local class = {}
function class:new(base, _name, _default, _config)
    local this = {}
    local private = {
        ['name'] = _name,
        ['config'] = _config or base:getClass('config'),
    }

    function private:getName()
        return private.name
    end

    function this:set(name, value)
        private.config:set(private:getName(), name, value)
        return this
    end

    function this:get(name)
        return private.config:get(private:getName(), name)
    end

    function this:delete(name)
        private.config:delete(private:getName(), name)
        return this
    end

    function this:init(default)
        for name, value in pairs(default or {}) do
            if this:get(name) == nil then
                this:set(name, value)
            end
        end
        return this
    end

    this:init(_default)
    return this
end

return class