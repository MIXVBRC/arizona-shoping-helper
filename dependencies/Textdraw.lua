local class = {}
function class:new(_name, _defaultConfig)
    local public = {}
    local private = {
        ['configManager'] = _sh.dependencies.configManager:new(_name, _sh.config),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
    }

    function private:init(defaultConfig)
        for name, value in pairs(defaultConfig) do
            if private.configManager:getOption(name) == nil then
                private.configManager:setOption(name, value)
            end
        end

        private:initCommands()
    end

    function private:initCommands()
        
    end

    private:init(_defaultConfig or {})
    return public
end
return class