local class = {}
function class:new(_command, _defaultConfig)
    local public = {}
    local private = {
        ['mods'] = {
            'buy',
            'sell',
        },
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

    -- MOD

    function private:getMod()
        return private.configManager:getOption('mod')
    end

    function public:switchMod()
        for _, mod in ipairs(private.mods) do
            if private:getMod() ~= mod then
                private.configManager:setOption('mod', not private:isActive())
                break
            end
        end
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
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
        private.commandManager:add('mod', public.switchMod)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onVisitShop',
            function (shop, mod, textdraw)
                if mod ~= private:getMod() then
                    local parent = textdraw:getParent()
                    if parent ~= nil then
                        sampSendClickTextdraw(parent:getId())
                    end
                end
            end
        )
    end

    private:init(_defaultConfig or {})
    return public
end
return class