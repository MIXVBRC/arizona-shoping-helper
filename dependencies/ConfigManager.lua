local class = {}
function class:new(_name, _config, _default)
    local public = {}
    local private = {
        ['name'] = _name,
        ['config'] = _config,
    }

    function private:getName()
        return private.name
    end

    function public:setOption(name, value)
        private.config:set(private:getName(), name, value)
        return public
    end

    function public:getOption(name)
        return private.config:get(private:getName(), name)
    end

    function public:deleteOption(name)
        private.config:delete(private:getName(), name)
        return public
    end

    function public:init(default)
        for name, value in pairs(default or {}) do
            if public:getOption(name) == nil then
                public:setOption(name, value)
            end
        end
        return public
    end

    public:init(_default)
    return public
end

return class