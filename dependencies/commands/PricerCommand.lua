local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _base:getNewClass('minMax', _minmax),
        ['configManager'] = _base:getNewClass('configManager', _name, _default),
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
            if _base:getClass('scan'):isAdd() then
                _base:getClass('scan'):toggleAdd()
            end
            if _base:getClass('select') ~= nil and _base:getClass('select'):isAdd() then
                _base:getClass('select'):toggleAdd()
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
        if _base:getClass('playerManager'):isShoping() and not _base:getClass('dialogManager'):isOpened() and not _base:getClass('swipe'):isSwipe() then
            for _, product in ipairs(private:getProducts()) do
                for _, _product in ipairs(_base:getClass('productManager'):getProducts()) do
                    if product.sign == _product:getSign() then
                        local mod = _base:getClass('shopManager'):getMod()
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
                            _base:getClass('boxManager'):push(
                                _product:getTextdraw():getX(),
                                _product:getTextdraw():getY(),
                                _product:getTextdraw():getWidth(),
                                _product:getTextdraw():getHeight(),
                                '0x00000000',
                                private:getBorder(),
                                _base:getClass('color'):getAlpha(100) .. color,
                                2
                            )
                            _base:getClass('render'):pushText(
                                _base:getClass('font'):get('Verdana', 8, 9),
                                _base:getClass('helper'):formatPrice(price),
                                _product:getTextdraw():getX() + 5,
                                _product:getTextdraw():getY() + 5,
                                _base:getClass('color'):getAlpha(100) .. color
                            )
                        end
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if _base:getClass(private:getName()) ~= nil then
            return _base:getClass(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _base:getClass('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'border'}, function (border)
            private:setBorder(_base:getClass('helper'):getNumber(border))
        end)
        :add({private:getName(), 'commission'}, function (commission)
            private:setCommission(_base:getClass('helper'):getNumber(commission))
        end)
        return private
    end

    function private:initThreads()
        _base:getClass('threadManager')
        :add(
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
        _base:getClass('eventManager')
        :add(
            'onClickProduct',
            function (product)
                if not _base:getClass('scan'):isScanning() and _base:getClass('playerManager'):isShoping() and this:isActive() and this:isAdd() then
                    _base:getClass('dialogManager'):show(
                        _base:getClass('message'):get('message_dialog_title_enter_price_zero'),
                        product:getName(),
                        _base:getClass('message'):get('message_dialog_button_ready'),
                        _base:getClass('message'):get('message_dialog_button_cancel'),
                        1,
                        function (button, _, input)
                            if button == 1 then
                                input = _base:getClass('helper'):getNumber(input)
                                local _product = private:getProduct(product:getSign())
                                local mod = _base:getClass('shopManager'):getMod()
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