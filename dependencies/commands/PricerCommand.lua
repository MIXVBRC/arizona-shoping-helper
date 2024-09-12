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

    function this:isActive()
        return private.config:get('active')
    end

    function this:toggleActive()
        private.config:set('active', not this:isActive())
        return this
    end

    -- ADD

    function this:isAdd()
        return private.config:get('add')
    end

    function this:setAdd(add)
        private.config:set('add', add)
        return this
    end

    function this:toggleAdd()
        private.config:set('add', not this:isAdd())
        if this:isAdd() then
            if _base:get('scan') ~= nil and _base:get('scan'):isAdd() then
                _base:get('scan'):toggleAdd()
            end
            if _base:get('select') ~= nil and _base:get('select'):isAdd() then
                _base:get('select'):toggleAdd()
            end
            if _base:get('buyer') ~= nil and _base:get('buyer'):isAdd() then
                _base:get('buyer'):toggleAdd()
            end
        end
        return this
    end

    -- BORDER

    function private:getBorder()
        return private.config:get('border') or private.minmax:getMin('border')
    end

    function private:setBorder(border)
        private.config:set('border', private.minmax:get(border, 'border'))
        return this
    end

    -- COMMISSION

    function private:getCommission()
        return private.config:get('commission') or private.minmax:getMin('commission')
    end

    function private:setCommission(commission)
        private.config:set('commission', private.minmax:get(commission, 'commission'))
        return this
    end

    -- PRODUCTS

    function private:getProducts()
        return private.config:get('products') or {}
    end

    function private:setProducts(products)
        private.config:set('products', products or {})
        return this
    end

    function private:getProduct(sign)
        for _, product in ipairs(private:getProducts()) do
            if sign == product.name or sign == product.code then
                return product
            end
        end
        return nil
    end

    function private:addProduct(name, code, mod, price)
        local products = private:getProducts()
        table.insert(products, {
            ['name'] = name,
            ['code'] = code,
            ['prices'] = {
                {
                    ['mod'] = mod,
                    ['value'] = price
                }
            }
        })
        private:setProducts(products)
        return this
    end

    function private:deleteProduct(name)
        local products = {}
        for _, product in ipairs(private:getProducts()) do
            if name ~= product.name then
                table.insert(products, product)
            end
        end
        private:setProducts(products)
        return this
    end

    function private:changeProductPrice(name, mod, price)
        local products = private:getProducts()
        if price ~= nil and price > 0 then
            for _, product in ipairs(products) do
                if name == product.name then
                    for indexPrice, _price in ipairs(product.prices) do
                        if mod == _price.mod then
                            product.prices[indexPrice].value = price
                        end
                    end
                    break
                end
            end
        else
            for indexProduct, product in ipairs(products) do
                if name == product.name then
                    for indexPrice, _price in ipairs(product.prices) do
                        if mod == _price.mod then
                            table.remove(product.prices, indexPrice)
                        end
                    end
                    if #product.prices <= 0 then
                        table.remove(products, indexProduct)
                    end
                    break
                end
            end
        end
        private:setProducts(products)
        return this
    end

    -- DIALOG

    function private:dialog(product)
        if product:isScanned() then
            _base:get('dialogManager'):show(
                _base:get('message'):get('message_dialog_title_enter_price_zero'),
                product:getName(),
                _base:get('message'):get('message_dialog_button_ready'),
                _base:get('message'):get('message_dialog_button_cancel'),
                1,
                function (button, _, input)
                    if button == 1 then
                        input = _base:get('helper'):getNumber(input)
                        local _product = private:getProduct(product:getName())
                        local mod = _base:get('shopManager'):getMod()
                        if _product ~= nil then
                            private:changeProductPrice(product:getName(), mod, input)
                        else
                            private:addProduct(
                                product:getName(),
                                product:getCode(),
                                mod,
                                input
                            )
                        end
                    end
                end
            )
        end
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'clear'}, function ()
            private:setProducts({})
        end)
        :add({private:getName(), 'border'}, function (border)
            private:setBorder(_base:get('helper'):getNumber(border))
        end)
        :add({private:getName(), 'commission'}, function (commission)
            private:setCommission(_base:get('helper'):getNumber(commission))
        end)
        :add({private:getName(), 'remove'}, function ()
            _base:get('dialogManager'):close()
            local dialogTable = {
                {
                    _base:get('message'):get('message_dialog_table_title_name'),
                    _base:get('message'):get('message_dialog_table_title_price'),
                    _base:get('message'):get('message_dialog_table_title_price'),
                },
            }
            for _, product in ipairs(private:getProducts()) do
                for _, price in ipairs(product.prices) do
                    table.insert(dialogTable, {
                        product.name,
                        _base:get('message'):get('message_mod_' .. price.mod),
                        _base:get('helper'):implode({
                            '{',
                            _base:get('color'):get('green'),
                            '}',
                            _base:get('helper'):formatPrice(price.value)
                        }),
                    })
                end
            end
            _base:get('dialogManager'):show(
                _base:get('message'):get('message_dialog_title_remove_product'),
                dialogTable,
                _base:get('message'):get('message_dialog_button_delete'),
                _base:get('message'):get('message_dialog_button_cancel'),
                5,
                function (button, list)
                    if button == 1 then
                        local count = 0
                        for _, product in ipairs(private:getProducts()) do
                            for _, price in ipairs(product.prices) do
                                if list == count then
                                    _base:get('chat'):push(product.name)
                                    _base:get('chat'):push(price.mod)
                                    private:changeProductPrice(product.name, price.mod, 0)
                                    return
                                end
                                count = count + 1
                            end
                        end
                    end
                end
            )
        end)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() then
                        if _base:get('playerManager'):isShoping() and not _base:get('dialogManager'):isOpened() then
                            for _, product in ipairs(_base:get('productManager'):getProducts()) do
                                local _product = private:getProduct(product:getSign()) or private:getProduct(product:getCode())
                                if _product ~= nil then
                                    local mod = _base:get('shopManager'):getMod()
                                    for _, _price in ipairs(_product.prices) do
                                        if mod == _price.mod then
                                            local color = 'ff0000'
                                            local price = _price.value
                                            if mod == 'buy' then
                                                price = price - (product:getPrice() + (product:getPrice() / 100 * private:getCommission()))
                                            else
                                                price = (product:getPrice() + (product:getPrice() / 100 * private:getCommission())) - price
                                            end
                                            if price >= 0 then
                                                color = '00ff00'
                                            end
                                            _base:get('boxManager'):push(
                                                product:getTextdraw():getX(),
                                                product:getTextdraw():getY(),
                                                product:getTextdraw():getWidth(),
                                                product:getTextdraw():getHeight(),
                                                '0x00000000',
                                                private:getBorder(),
                                                _base:get('color'):getAlpha(100) .. color,
                                                50
                                            )
                                            _base:get('textManager'):push(
                                                _base:get('font'):get('Verdana', 8, 9),
                                                _base:get('helper'):formatPrice(price),
                                                product:getTextdraw():getX() + 5,
                                                product:getTextdraw():getY() + 5,
                                                _base:get('color'):getAlpha(100) .. color,
                                                50
                                            )
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        )
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onClickProduct',
            function (clickedProduct)
                if this:isAdd() and _base:get('playerManager'):isShoping() then
                    if clickedProduct:isScanned() then
                        private:dialog(clickedProduct)
                    else
                        clickedProduct:scan(500,
                            function (scannedProduct)
                                if scannedProduct:isScanned() then
                                    private:dialog(scannedProduct)
                                end
                            end
                        )
                    end
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