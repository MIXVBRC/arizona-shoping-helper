local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['swipe'] = true,
        ['mods'] = {
            'buy',
            'sale',
        },
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:toggleActive()
        private.config:set('active', not private:isActive())
        return private
    end

    -- MOD

    function private:getMod()
        return private.config:get('mod')
    end

    function private:switchMod()
        for _, mod in ipairs(private.mods) do
            if private:getMod() ~= mod then
                private.config:set('mod', mod)
                break
            end
        end
        return private
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
        return private
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'mod'}, private.switchMod)
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onInitShopModButton',
            function (mod, textdraw)
                private:setSwipe(true)
                if private:isActive() and private:getMod() ~= mod then
                    sampSendClickTextdraw(textdraw:getId())
                    return false
                else
                    private:setSwipe(false)
                end
            end,
            1
        )
        return private
    end

    return private:init()
end
return class