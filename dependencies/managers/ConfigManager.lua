local class = {}
function class:new(_base, _name, _default, _config)
    local this = {}
    local private = {
        ['name'] = _name,
        ['default'] = _default or {},
        ['config'] = _config or _base:get('config'),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- DEFAULT

    function private:getDefault()
        return private.default
    end

    -- CONFIG

    function private:getConfig()
        return private.config
    end

    -- SET

    function this:set(name, value)
        private:getConfig():set(private:getName(), name, value)
        return this
    end

    -- GET

    function this:get(name)
        return private:getConfig():get(private:getName(), name)
    end

    -- DELETE

    function this:delete(name)
        private:getConfig():delete(private:getName(), name)
        return this
    end

    -- INITS

    function private:init()
        private:initDefault()
        return this
    end

    function private:initDefault()
        for name, value in pairs(private:getDefault()) do
            if this:get(name) == nil then
                this:set(name, value)
            end
        end
        return private
    end

    return private:init()
end

return class