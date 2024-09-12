local this = {}
function this:new(_base, _name, _default, _minmax)
    local class = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _base:getNewClass('minMax', _minmax),
        ['config'] = _base:getNewClass('configManager', _name, _default),
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
        return class
    end

    -- ALPHA

    function private:getAlpha()
        return private.config:get('alpha')
    end

    function private:setAlpha(alpha)
        private.config:set('alpha', private.minmax:get(alpha, 'alpha'))
        return class
    end

    -- INITS

    function private:init()
        if _base:getClass(private:getName()) ~= nil then
            return _base:getClass(private:getName())
        end
        private:initCommands():initThreads()
        return class
    end

    function private:initCommands()
        _base:getClass('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'alpha'}, function (alpha)
            private:setAlpha(_base:getClass('helper'):getNumber(alpha))
        end)
        return private
    end

    function private:initThreads()
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        if _base:getClass('playerManager'):isShoping() and not _base:getClass('dialogManager'):isOpened() and not _base:getClass('swipe'):isSwipe() then
                            for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                                _base:getClass('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    _base:getClass('color'):getAlpha(private:getAlpha()) .. '1f1f1f',
                                    0,
                                    '0x00000000',
                                    100
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
return this