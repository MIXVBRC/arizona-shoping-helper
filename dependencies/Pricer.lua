local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['minmax'] = _sh.dependencies.minMax:new({
            ['border'] = {
                ['min'] = 1,
                ['max'] = 5,
            },
            ['commission'] = {
                ['min'] = 0,
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
        if public:isAdd() then
            if _sh.scan:isAdd() then
                _sh.scan:toggleAdd()
            end
            if _sh.select ~= nil and _sh.select:isAdd() then
                _sh.select:toggleAdd()
            end
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

    -- COMMISSION

    function private:getCommission()
        return private.configManager:get('commission') or private.minmax:getMin('commission')
    end

    function private:setCommission(commission)
        private.configManager:set('commission', private.minmax:get(commission, 'commission'))
        return public
    end

    -- PRODUCTS

    function private:getProducts()
        return private.configManager:get('products') or {}
    end

    function private:setProducts(products)
        private.configManager:set('products', products or {})
        return public
    end

    function private:haweProduct(sign)
        for _, product in ipairs(private:getProducts()) do
            if sign == product.sign then
                return true
            end
        end
        return false
    end

    function private:addProduct(product)
        local products = private:getProducts()
        table.insert(products, product)
        private:setProducts(products)
        return public
    end

    function private:deleteProduct(sign)
        local products = {}
        for _, product in ipairs(private:getProducts()) do
            if sign ~= product.sign then
                table.insert(products, product)
            end
        end
        private:setProducts(products)
        return public
    end

    function private:changeProduct(sign, data)
        local products = private:getProducts()
        for _, product in ipairs(products) do
            if sign == product.sign then
                for name, value in pairs(data) do
                    if name ~= 'sign' then
                        product[name] = value
                    end
                end
                break
            end
        end
        private:setProducts(products)
    end

    -- WORK

    function private:work()
        if _sh.player:inShop() and not _sh.dialogManager:isOpened() then
            for _, product in ipairs(private:getProducts()) do
                for _, _product in ipairs(_sh.productManager:getProducts()) do
                    if product.sign == _product:getName() or product.sign == _product:getCode() then
                        local color = 'ff0000'
                        local price = product.price - (_product:getPrice() + (_product:getPrice() / 100 * private:getCommission()))
                        if price >= 0 then
                            color = '00ff00'
                        end
                        _sh.boxManager:push(
                            _product:getTextdraw():getX(),
                            _product:getTextdraw():getY(),
                            _product:getTextdraw():getWidth(),
                            _product:getTextdraw():getHeight(),
                            '0x00000000',
                            private:getBorder(),
                            _sh.color:getAlpha(100) .. color,
                            2
                        )
                        _sh.render:pushText(
                            _sh.font:get('Verdana', 8, 9),
                            _sh.helper:formatPrice(price),
                            _product:getTextdraw():getX() + 5,
                            _product:getTextdraw():getY() + 5,
                            _sh.color:getAlpha(100) .. color
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
        private.commandManager:add('commission', function (commission)
            private:setCommission(_sh.helper:getNumber(commission))
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
                    local sign = product:getCode()
                    if product:isScanned() then
                        sign = product:getName()
                    end
                    _sh.dialogManager:show(
                        '{65f0c6}Введите цену за товар',
                        product:getName(),
                        '{'.._sh.color:get('green') .. '}Готово',
                        '{'.._sh.color:get('red') .. '}Отмена',
                        1,
                        function (button, _, input)
                            if button == 1 then
                                input = _sh.helper:getNumber(input)
                                if input > 0 then
                                    if private:haweProduct(sign) then
                                        private:changeProduct(sign, {
                                            ['price'] = input
                                        })
                                    else
                                        private:addProduct({
                                            ['sign'] = sign,
                                            ['price'] = input
                                        })
                                    end
                                else
                                    private:deleteProduct(sign)
                                end
                            end
                        end
                    )
                    return false
                end
            end,
            1000
        )
    end

    private:init()
    return public
end
return class