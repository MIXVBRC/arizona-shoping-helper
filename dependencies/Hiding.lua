local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['minmax'] = _sh.dependencies.minMax:new({
            ['alpha'] = {
                ['min'] = 0,
                ['max'] = 100,
            },
        }),
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

    -- ALPHA

    function private:getAlpha()
        return private.configManager:get('alpha')
    end

    function private:setAlpha(alpha)
        private.configManager:set('alpha', private.minmax:get(alpha, 'alpha'))
        return public
    end

    -- WIRK

    function private:work()
        if _sh.player:inShop() and not _sh.dialogManager:isOpened() and not _sh.swipe:isSwipe() then
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
        private:initCommands()
        private:initThreads()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('alpha', function (alpha)
            private:setAlpha(_sh.helper:getNumber(alpha))
        end)
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
    end

    private:init()
    return public
end
return class