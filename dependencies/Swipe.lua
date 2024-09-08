local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['button'] = nil,
        ['mods'] = {
            'buy',
            'sale',
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

    -- BUTTON

    function private:getButton()
        return private.button
    end

    function private:setButton(button)
        private.button = button
        return public
    end

    -- MOD

    function private:getMod()
        return private.configManager:get('mod')
    end

    function private:switchMod()
        for _, mod in ipairs(private.mods) do
            if private:getMod() ~= mod then
                private.configManager:set('mod', mod)
                break
            end
        end
        return public
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initEvents()
        private:initThreads()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('mod', private.switchMod)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onVisitShop',
            function (_, mod, textdraw)
                private:setButton({
                    ['mod'] = mod,
                    ['textdraw'] = textdraw,
                })
            end
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() and _sh.player:inShop() then
                        local button = private:getButton()
                        if button ~= nil and button.mod ~= private:getMod() and button.textdraw:getParent() ~= nil then
                            sampSendClickTextdraw(button.textdraw:getParent():getId())
                            private:setButton(nil)
                            wait(1000)
                        end
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class