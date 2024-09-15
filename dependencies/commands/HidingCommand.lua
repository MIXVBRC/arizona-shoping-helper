local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _base:getNew('minMax', _minmax),
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

    -- ALPHA

    function private:getAlpha()
        return private.config:get('alpha')
    end

    function private:setAlpha(alpha)
        private.config:set('alpha', private.minmax:get(alpha, 'alpha'))
        return private
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initThreads()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'alpha'}, function (alpha)
            private:setAlpha(_base:get('helper'):getNumber(alpha))
        end)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        if _base:get('playerManager'):isShoping() and not _base:get('dialogManager'):isOpened() then
                            for _, product in ipairs(_base:get('productManager'):getProducts()) do
                                _base:get('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    _base:get('color'):getAlpha(private:getAlpha()) .. '1f1f1f',
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
return class