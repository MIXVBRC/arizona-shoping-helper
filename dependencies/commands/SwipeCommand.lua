local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['button'] = nil,
        ['swipe'] = true,
        ['mods'] = {
            'buy',
            'sale',
        },
        ['configManager'] = _base:getNewClass('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

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
        if _base:getClass(private:getName()) ~= nil then
            return _base:getClass(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _base:getClass('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'mod'}, private.switchMod)
        return private
    end

    function private:initThreads()
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        if _base:getClass('playerManager'):isShoping() then
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
        _base:getClass('eventManager')
        :add(
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