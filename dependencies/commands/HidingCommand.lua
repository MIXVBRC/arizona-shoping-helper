local class = {}
function class:new(base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = base:getObject('minMax'):new(base, _minmax),
        ['configManager'] = base:getObject('configManager'):new(base, _name, _default),
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

    -- ALPHA

    function private:getAlpha()
        return private.configManager:get('alpha')
    end

    function private:setAlpha(alpha)
        private.configManager:set('alpha', private.minmax:get(alpha, 'alpha'))
        return this
    end

    -- INITS

    function private:init()
        if base:getClass(private:getName()) ~= nil then
            return base:getClass(private:getName())
        end
        private:initCommands():initThreads()
        return this
    end

    function private:initCommands()
        base:getClass('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'alpha'}, function (alpha)
            private:setAlpha(base:getClass('helper'):getNumber(alpha))
        end)
        return private
    end

    function private:initThreads()
        base:getClass('threadManager'):add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        if base:getClass('playerManager'):isShoping() and not base:getClass('dialogManager'):isOpened() and not base:getClass('swipe'):isSwipe() then
                            for _, product in ipairs(base:getClass('productManager'):getProducts()) do
                                base:getClass('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    base:getClass('color'):getAlpha(private:getAlpha()) .. '1f1f1f',
                                    0,
                                    '0x00000000',
                                    10
                                )
                            end
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class