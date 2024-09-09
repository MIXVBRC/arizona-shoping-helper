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

    function this:isActive()
        return private.configManager:get('active')
    end

    function this:toggleActive()
        private.configManager:set('active', not this:isActive())
        return this
    end

    -- ADD

    function this:isAdd()
        return private.configManager:get('add')
    end

    function this:toggleAdd()
        private.configManager:set('add', not this:isAdd())
        if this:isAdd() then
            if _sh.scan:isAdd() then
                _sh.scan:toggleAdd()
            end
            if _sh.select ~= nil and _sh.select:isAdd() then
                _sh.select:toggleAdd()
            end
        end
        return this
    end

    -- BORDER

    function private:getBorder()
        return private.configManager:get('border') or private.minmax:getMin('border')
    end

    function private:setBorder(border)
        private.configManager:set('border', private.minmax:get(border, 'border'))
        return this
    end

    -- COMMISSION

    function private:getCommission()
        return private.configManager:get('commission') or private.minmax:getMin('commission')
    end

    function private:setCommission(commission)
        private.configManager:set('commission', private.minmax:get(commission, 'commission'))
        return this
    end

    -- PRODUCTS

    function private:getProducts()
        return private.configManager:get('products') or {}
    end

    function private:setProducts(products)
        private.configManager:set('products', products or {})
        return this
    end

    function private:getProduct(sign)
        for _, product in ipairs(private:getProducts()) do
            if sign == product.sign then
                return product
            end
        end
        return nil
    end

    function private:addProduct(product)
        local products = private:getProducts()
        table.insert(products, product)
        private:setProducts(products)
        return this
    end

    function private:deleteProduct(sign)
        local products = {}
        for _, product in ipairs(private:getProducts()) do
            if sign ~= product.sign then
                table.insert(products, product)
            end
        end
        private:setProducts(products)
        return this
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
        if _sh.player:isShoping() and not _sh.dialogManager:isOpened() and not _sh.swipe:isSwipe() then
            for _, product in ipairs(private:getProducts()) do
                for _, _product in ipairs(_sh.productManager:getProducts()) do
                    if product.sign == _product:getSign() then
                        local mod = _sh.shopManager:getMod()
                        local price = product.price[mod]
                        if price ~= nil and price > 0 then
                            local color = 'ff0000'
                            if mod == 'buy' then
                                price = price - (_product:getPrice() + (_product:getPrice() / 100 * private:getCommission()))
                            else
                                price = (_product:getPrice() + (_product:getPrice() / 100 * private:getCommission())) - price
                            end
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
        :add('active', this.toggleActive)
        :add('add', this.toggleAdd)
        :add('border', function (border)
            private:setBorder(_sh.helper:getNumber(border))
        end)
        :add('commission', function (commission)
            private:setCommission(_sh.helper:getNumber(commission))
        end)
        return private
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() then
                        private:work()
                    end
                end
            end
        )
        return private
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onClickProduct',
            function (product)
                if not _sh.scan:isScanning() and _sh.player:isShoping() and this:isActive() and this:isAdd() then
                    local sign = product:getSign()
                    _sh.dialogManager:show(
                        _sh.message:get('message_pricer_dialog_title'),
                        product:getName(),
                        _sh.message:get('message_pricer_dialog_button_yes'),
                        _sh.message:get('message_pricer_dialog_button_no'),
                        1,
                        function (button, _, input)
                            if button == 1 then
                                input = _sh.helper:getNumber(input)
                                local _product = private:getProduct(sign)
                                local mod = _sh.shopManager:getMod()
                                _sh.chat:push(product:getTextdraw():getId())
                                if _product ~= nil then
                                    _product.price[mod] = input
                                    private:changeProduct(sign, _product)
                                else
                                    private:addProduct({
                                        ['sign'] = sign,
                                        ['price'] = {
                                            [mod] = input
                                        }
                                    })
                                end
                            end
                        end
                    )
                    return false
                end
            end,
            1000
        )
        return private
    end

    return private:init()
end
return class