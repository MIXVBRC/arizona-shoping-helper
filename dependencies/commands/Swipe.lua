local class = {}
function class:new(_name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['button'] = nil,
        ['swipe'] = true,
        ['mods'] = {
            'buy',
            'sale',
        },
        ['configManager'] = _sh.dependencies.configManager:new(_name, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
        return this
    end

    -- BUTTON

    function private:getButton()
        return private.button
    end

    function private:setButton(button)
        private.button = button
        return this
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
        return this
    end

    -- SWIPE

    function this:isSwipe()
        if private:isActive() then
            return private.swipe
        end
        return false
    end

    function private:setSwipe(bool)
        private.swipe = bool
        return this
    end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        private.commandManager
        :add('active', private.toggleActive)
        :add('mod', private.switchMod)
        return private
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        if _sh.player:isShoping() then
                            local button = private:getButton()
                            if button ~= nil and button.mod ~= private:getMod() and button.textdraw:getParent() ~= nil then
                                sampSendClickTextdraw(button.textdraw:getParent():getId())
                                wait(500)
                            else
                                private:setSwipe(false)
                            end
                        else
                            private:setSwipe(true)
                        end
                    end
                end
            end
        )
        return private
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
        return private
    end

    return private:init()
end
return class