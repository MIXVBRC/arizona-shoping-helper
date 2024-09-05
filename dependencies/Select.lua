local class = {}
function class:new(_command, _defaultConfig)
    local public = {}
    local private = {
        ['configManager'] = _sh.dependencies.configManager:new(_command, _sh.config),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:getOption('active')
    end

    function public:toggleActive()
        private.configManager:setOption('active', not private:isActive())
        return public
    end

    -- INITS

    function private:init(defaultConfig)
        for name, value in pairs(defaultConfig) do
            if private.configManager:getOption(name) == nil then
                private.configManager:setOption(name, value)
            end
        end
        private:initCommands()
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
    end

    private:init(_defaultConfig or {})
    return public
end
return class