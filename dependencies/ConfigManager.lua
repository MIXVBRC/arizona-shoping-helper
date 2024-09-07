local class = {}
function class:new(_name, _default, _config)
    local public = {}
    local private = {
        ['name'] = _name,
        ['config'] = _config or _sh.config,
    }

    function private:getName()
        return private.name
    end

    function public:set(name, value)
        private.config:set(private:getName(), name, value)
        return public
    end

    function public:get(name)
        return private.config:get(private:getName(), name)
    end

    function public:delete(name)
        private.config:delete(private:getName(), name)
        return public
    end

    function public:init(default)
        for name, value in pairs(default or {}) do
            if public:get(name) == nil then
                public:set(name, value)
            end
        end
        return public
    end

    public:init(_default)
    return public
end

return class