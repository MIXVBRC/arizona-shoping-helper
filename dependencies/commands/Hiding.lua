local class = {}
function class:new(_name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _sh.dependencies.minMax:new(_minmax),
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

    -- ALPHA

    function private:getAlpha()
        return private.configManager:get('alpha')
    end

    function private:setAlpha(alpha)
        private.configManager:set('alpha', private.minmax:get(alpha, 'alpha'))
        return this
    end

    -- WIRK

    function private:work()
        if _sh.player:isShoping() and not _sh.dialogManager:isOpened() and not _sh.swipe:isSwipe() then
            for _, product in ipairs(_sh.productManager:getProducts()) do
                _sh.boxManager:push(
                    product:getTextdraw():getX(),
                    product:getTextdraw():getY(),
                    product:getTextdraw():getWidth(),
                    product:getTextdraw():getHeight(),
                    _sh.color:getAlpha(private:getAlpha()) .. '1f1f1f',
                    0,
                    '0x00000000',
                    10
                )
            end
        end
    end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initCommands():initThreads()
        return this
    end

    function private:initCommands()
        private.commandManager
        :add('active', private.toggleActive)
        :add('alpha', function (alpha)
            private:setAlpha(_sh.helper:getNumber(alpha))
        end)
        return private
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        private:work()
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class