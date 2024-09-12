local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['buying'] = nil,
        ['products'] = {},
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
            if _base:get('pricer') ~= nil and _base:get('pricer'):isAdd() then
                _base:get('pricer'):toggleAdd()
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

    -- TIME

    function private:getTime()
        return private.config:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.config:set('time', private.minmax:get(time, 'time'))
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

    function private:addProduct(product)
        local products = private:getProducts()
        table.insert(products, product)
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

    function private:changeProduct(name, data)
        local products = private:getProducts()
        for _, product in ipairs(products) do
            if name == product.name then
                for index, value in pairs(data) do
                    if index ~= 'name' then
                        product[index] = value
                    end
                end
                break
            end
        end
        private:setProducts(products)
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
                        if _product ~= nil then
                            if input > 0 then
                                _product.price = input
                                private:changeProduct(product:getName(), _product)
                            else
                                private:deleteProduct(product:getName())
                            end
                        else
                            private:addProduct({
                                ['name'] = product:getName(),
                                ['code'] = product:getCode(),
                                ['price'] = input
                            })
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
        :add({private:getName(), 'time'}, function (time)
            private:setTime(_base:get('helper'):getNumber(time))
        end)
        :add({private:getName(), 'remove'}, function ()
            _base:get('dialogManager'):close()
            local dialogTable = {
                {
                    _base:get('message'):get('message_dialog_table_title_name'),
                    _base:get('message'):get('message_dialog_table_title_price'),
                },
            }
            for _, product in ipairs(private:getProducts()) do
                table.insert(dialogTable, {
                    product.name,
                    _base:get('helper'):implode({
                        '{',
                        _base:get('color'):get('green'),
                        '}',
                        _base:get('helper'):formatPrice(product.price)
                    }),
                })
            end
            _base:get('dialogManager'):show(
                _base:get('message'):get('message_dialog_title_remove_product'),
                dialogTable,
                _base:get('message'):get('message_dialog_button_delete'),
                _base:get('message'):get('message_dialog_button_cancel'),
                5,
                function (button, list)
                    if button == 1 then
                        private:deleteProduct(dialogTable[list+2][1])
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
                    if _base:get('playerManager'):isShoping() and not _base:get('dialogManager'):isOpened() then
                        for _, product in ipairs(_base:get('productManager'):getProducts()) do
                            local _product = private:getProduct(product:getSign())
                            if _product ~= nil then
                                _base:get('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private:getBorder(),
                                    _base:get('color'):getAlpha(100) .. _base:get('color'):get('orange'),
                                    25
                                )
                                _base:get('textManager'):push(
                                    _base:get('font'):get('Verdana', 8, 9),
                                    _base:get('helper'):formatPrice(_product.price),
                                    product:getTextdraw():getX() + 5,
                                    product:getTextdraw():getY() + 5,
                                    _base:get('color'):getAlpha(100) .. _base:get('color'):get('orange'),
                                    25
                                )
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
            'onCreateProduct',
            function (createdProduct)
                if this:isActive() then
                    local product = private:getProduct(createdProduct:getCode())
                    if product ~= nil and createdProduct:getPrice() <= product.price then

                        if createdProduct:isScanned() then
                            createdProduct:buy(private:getTime())
                        else
                            createdProduct:scan(private:getTime(),
                                function (scannedProduct)
                                    product = private:getProduct(scannedProduct:getName())
                                    if product ~= nil and scannedProduct:getPrice() <= product.price then
                                        scannedProduct:buy(private:getTime())
                                    end
                                end
                            )
                        end
                    end
                end
            end
        )
        :add(
            'onClickProduct',
            function (clickedProduct)
                if _base:get('playerManager'):isShoping() then
                    if _base:get('shopManager'):getMod() == 'buy' then
                        if this:isAdd() then
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
                        elseif isKeyDown(VK_CONTROL) then
                            clickedProduct:buy(private:getTime())
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