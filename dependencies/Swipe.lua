local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['mods'] = {
            'buy',
            'sell',
        },
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
        return public
    end

    -- MOD

    function private:getMod()
        return private.configManager:get('mod')
    end

    function private:switchMod()
        for _, mod in ipairs(private.mods) do
            if private:getMod() ~= mod then
                private.configManager:set('mod', not private:isActive())
                break
            end
        end
        return public
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('mod', private.switchMod)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onVisitShop',
            function (shop, mod, textdraw)
                if private:isActive() and mod ~= private:getMod() then
                    local parent = textdraw:getParent()
                    if parent ~= nil then
                        sampSendClickTextdraw(parent:getId())
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class