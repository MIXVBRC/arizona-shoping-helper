local class = {}
function class:new(_name, _config)
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
    end

    function public:getOption(name)
        return private.config:get(private:getName(), name)
    end

    return public
end

return class