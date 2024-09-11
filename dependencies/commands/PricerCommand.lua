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
            if base:getClass('scan'):isAdd() then
                base:getClass('scan'):toggleAdd()
            end
            if base:getClass('select') ~= nil and base:getClass('select'):isAdd() then
                base:getClass('select'):toggleAdd()
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
        if base:getClass('playerManager'):isShoping() and not base:getClass('dialogManager'):isOpened() and not base:getClass('swipe'):isSwipe() then
            for _, product in ipairs(private:getProducts()) do
                for _, _product in ipairs(base:getClass('productManager'):getProducts()) do
                    if product.sign == _product:getSign() then
                        local mod = base:getClass('shopManager'):getMod()
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
                            base:getClass('boxManager'):push(
                                _product:getTextdraw():getX(),
                                _product:getTextdraw():getY(),
                                _product:getTextdraw():getWidth(),
                                _product:getTextdraw():getHeight(),
                                '0x00000000',
                                private:getBorder(),
                                base:getClass('color'):getAlpha(100) .. color,
                                2
                            )
                            base:getClass('render'):pushText(
                                base:getClass('font'):get('Verdana', 8, 9),
                                base:getClass('helper'):formatPrice(price),
                                _product:getTextdraw():getX() + 5,
                                _product:getTextdraw():getY() + 5,
                                base:getClass('color'):getAlpha(100) .. color
                            )
                        end
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if base:getClass(private:getName()) ~= nil then
            return base:getClass(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        base:getClass('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'border'}, function (border)
            private:setBorder(base:getClass('helper'):getNumber(border))
        end)
        :add({private:getName(), 'commission'}, function (commission)
            private:setCommission(base:getClass('helper'):getNumber(commission))
        end)
        return private
    end

    function private:initThreads()
        base:getClass('threadManager'):add(
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
        base:getClass('eventManager'):add(
            'onClickProduct',
            function (product)
                if not base:getClass('scan'):isScanning() and base:getClass('playerManager'):isShoping() and this:isActive() and this:isAdd() then
                    base:getClass('dialogManager'):show(
                        base:getClass('message'):get('message_dialog_title_enter_price_zero'),
                        product:getName(),
                        base:getClass('message'):get('message_dialog_button_ready'),
                        base:getClass('message'):get('message_dialog_button_cancel'),
                        1,
                        function (button, _, input)
                            if button == 1 then
                                input = base:getClass('helper'):getNumber(input)
                                local _product = private:getProduct(product:getSign())
                                local mod = base:getClass('shopManager'):getMod()
                                if _product ~= nil then
                                    _product.price[mod] = input
                                    private:changeProduct(product:getSign(), _product)
                                else
                                    private:addProduct({
                                        ['sign'] = product:getSign(),
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