local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['minmax'] = _sh.dependencies.minMax:new({
            ['border'] = {
                ['min'] = 1,
                ['max'] = 5,
            },
            ['alpha'] = {
                ['min'] = 1,
                ['max'] = 100,
            },
        }),
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function public:isActive()
        return private.configManager:get('active')
    end

    function public:toggleActive()
        private.configManager:set('active', not public:isActive())
        return public
    end

    -- ADD

    function public:isAdd()
        return private.configManager:get('add')
    end

    function public:toggleAdd()
        private.configManager:set('add', not public:isAdd())
        if public:isAdd() and _sh.scan:isAdd() then
            _sh.scan:toggleAdd()
        end
        return public
    end

    -- BORDER

    function private:getBorder()
        return private.configManager:get('border') or private.minmax:getMin('border')
    end

    function private:setBorder(border)
        private.configManager:set('border', private.minmax:get(border, 'border'))
        return public
    end

    -- COLOR

    function private:getColor()
        return private.configManager:get('color')
    end

    function private:setColor(color)
        return private.configManager:set('color', color or '0000ff')
    end

    -- ALPHA

    function private:getAlpha()
        return private.configManager:get('alpha') or private.minmax:getMin('alpha')
    end

    function private:setAlpha(alpha)
        return private.configManager:set('alpha', private.minmax:get(alpha, 'alpha'))
    end

    -- PRODUCTS

    function private:getProducts()
        return private.configManager:get('products') or {}
    end

    function private:setProducts(productNames)
        productNames = productNames or {}
        private.configManager:set('products', productNames)
        return public
    end

    function private:addProduct(name)
        local productNames = private:getProducts()
        table.insert(productNames, name)
        private:setProducts(productNames)
        return public
    end

    function private:deleteProduct(name)
        local productNames = {}
        for _, productName in ipairs(private:getProducts()) do
            if name ~= productName then
                table.insert(productNames, productName)
            end
        end
        private:setProducts(productNames)
        return public
    end

    function private:toggleProduct(name)
        for _, productName in ipairs(private:getProducts()) do
            if name == productName then
                private:deleteProduct(name)
                return public
            end
        end
        private:addProduct(name)
        return public
    end

    -- WORK

    function private:work()
        if _sh.player:inShop() then
            for _, name in ipairs(private:getProducts()) do
                for _, product in ipairs(_sh.productManager:getProducts()) do
                    if name == product:getName() then
                        _sh.boxManager:push(
                            product:getTextdraw():getX(),
                            product:getTextdraw():getY(),
                            product:getTextdraw():getWidth(),
                            product:getTextdraw():getHeight(),
                            '0x00ffffff',
                            private:getBorder(),
                            _sh.color:getAlpha(private:getAlpha()) .. private:getColor(),
                            2
                        )
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initThreads()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
        private.commandManager:add('add', public.toggleAdd)
        private.commandManager:add('border', function (border)
            private:setBorder(_sh.helper:getNumber(border))
        end)
        private.commandManager:add('color', function (color)
            if color:find('^......$') then
                private:setColor(color)
            end
        end)
        private.commandManager:add('alpha', function (border)
            private:setAlpha(_sh.helper:getNumber(border))
        end)
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if public:isActive() then
                        private:work()
                    end
                end
            end
        )
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onClickProduct',
            function (product)
                if not _sh.scan:isScanning() and _sh.player:inShop() and public:isActive() and public:isAdd() then
                    private:toggleProduct(product:getName())
                end
            end
        )
        _sh.eventManager:add(
            'onShowDialog',
            function ()
                if not _sh.scan:isScanning() and _sh.player:inShop() and public:isActive() and public:isAdd() then
                    _sh.dialogManager:close()
                    return false
                end
            end
        )
    end

    private:init()
    return public
end
return class