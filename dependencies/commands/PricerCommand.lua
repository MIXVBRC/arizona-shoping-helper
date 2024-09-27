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
            if _base:get('scan') ~= nil then
                _base:get('scan'):setAdd(false)
            end
            if _base:get('select') ~= nil then
                _base:get('select'):setAdd(false)
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
        return private
    end

    -- COMMISSION

    function private:getCommission()
        return private.config:get('commission') or private.minmax:getMin('commission')
    end

    function private:setCommission(commission)
        private.config:set('commission', private.minmax:get(commission, 'commission'))
        return private
    end

    -- PRODUCTS

    function private:getProducts()
        return private.config:get('products') or {}
    end

    function private:setProducts(products)
        private.config:set('products', products or {})
        return private
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
        return private
    end

    function private:deleteProduct(name)
        local products = {}
        for _, product in ipairs(private:getProducts()) do
            if name ~= product.name then
                table.insert(products, product)
            end
        end
        private:setProducts(products)
        return private
    end

    function private:changeProductPrice(name, mod, price)
        local products = private:getProducts()
        if price ~= nil and price > 0 then
            for _, product in ipairs(products) do
                if name == product.name then
                    for indexPrice, _price in ipairs(product.prices) do
                        if mod == _price.mod then
                            product.prices[indexPrice].value = price
                            goto save
                        end
                    end
                    table.insert(product.prices, {
                        ['mod'] = mod,
                        ['value'] = price,
                    })
                    goto save
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
                    goto save
                end
            end
        end
        ::save::
        private:setProducts(products)
        return private
    end

    -- DIALOG

    function private:dialogChange(name, code, mod, back)
        _base:get('dialogManager'):close()
        local product = private:getProduct(name)
        local textList = {
            _base:get('message'):get('message_ad_dialog_text_name', {
                name
            }),
        }
        if product ~= nil then
            for _, price in ipairs(product.prices) do
                if mod == price.mod then
                    table.insert(textList, _base:get('message'):get('message_ad_dialog_text_price', {
                        _base:get('helper'):formatPrice(price.value)
                    }))
                    break
                end
            end
        end
        _base:get('dialogManager'):show(
            _base:get('message'):get('message_dialog_title_enter_price_zero'),
            textList,
            _base:get('message'):get('message_dialog_button_ready'),
            _base:get('message'):get('message_dialog_button_cancel'),
            1,
            function (_, input)
                input = _base:get('helper'):getNumber(input)
                if product ~= nil then
                    private:changeProductPrice(name, mod, input)
                else
                    private:addProduct(
                        name,
                        code,
                        mod,
                        input
                    )
                end
                if back then
                    private:dialogChangeList()
                end
            end,
            function ()
                if back then
                    private:dialogChangeList()
                end
            end
        )
        return private
    end

    function private:dialogChangeList()
        _base:get('dialogManager'):close()
        local dialogTable = {
            {
                _base:get('message'):get('message_dialog_table_title_name'),
                _base:get('message'):get('message_dialog_table_title_mod'),
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
            _base:get('message'):get('message_dialog_title_change_product'),
            dialogTable,
            _base:get('message'):get('message_dialog_button_change'),
            _base:get('message'):get('message_dialog_button_cancel'),
            5,
            function (list)
                local count = 0
                for _, product in ipairs(private:getProducts()) do
                    for _, price in ipairs(product.prices) do
                        count = count + 1
                        if list == count then
                            private:dialogChange(product.name, product.code, price.mod, true)
                            return
                        end
                    end
                end
            end
        )
        return private
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
        :add({private:getName(), 'list'}, private.dialogChangeList)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive()
                    and _base:get('playerManager'):isShoping()
                    and not _base:get('dialogManager'):isOpened()
                    and not _base:get('swipe'):isSwipe()
                    and not sampIsScoreboardOpen()
                    then
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
                                        _base:get('drawManager'):addBox(
                                            product:getTextdraw():getX(),
                                            product:getTextdraw():getY(),
                                            product:getTextdraw():getWidth(),
                                            product:getTextdraw():getHeight(),
                                            '0x00000000',
                                            private:getBorder(),
                                            _base:get('color'):getAlpha(100) .. color,
                                            50
                                        )
                                        _base:get('drawManager'):addText(
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
        )
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onClickProduct',
            function (clickedProduct)
                if this:isAdd() and not isKeyDown(VK_CONTROL) and _base:get('playerManager'):isShoping() then
                    local mod = _base:get('shopManager'):getMod()
                    if clickedProduct:isScanned() then
                        private:dialogChange(clickedProduct:getName(), clickedProduct:getCode(), mod)
                    else
                        clickedProduct:scan(
                            function (scannedProduct)
                                if scannedProduct:isScanned() then
                                    private:dialogChange(scannedProduct:getName(), scannedProduct:getCode(), mod)
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