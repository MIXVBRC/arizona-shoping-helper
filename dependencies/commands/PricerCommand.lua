local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _base:getNewClass('minMax', _minmax),
        ['config'] = _base:getNewClass('configManager', _name, _default),
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
            if _base:getClass('scan') ~= nil and _base:getClass('scan'):isAdd() then
                _base:getClass('scan'):toggleAdd()
            end
            if _base:getClass('select') ~= nil and _base:getClass('select'):isAdd() then
                _base:getClass('select'):toggleAdd()
            end
            if _base:getClass('buyer') ~= nil and _base:getClass('buyer'):isAdd() then
                _base:getClass('buyer'):toggleAdd()
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
            for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                local _product = private:getProduct(product:getSign())
                if _product ~= nil then
                    local mod = _base:getClass('shopManager'):getMod()
                    local price = _product.price[mod]
                    if price ~= nil and price > 0 then
                        local color = 'ff0000'
                        if mod == 'buy' then
                            price = price - (product:getPrice() + (product:getPrice() / 100 * private:getCommission()))
                        else
                            price = (product:getPrice() + (product:getPrice() / 100 * private:getCommission())) - price
                        end
                        if price >= 0 then
                            color = '00ff00'
                        end
                        _base:getClass('boxManager'):push(
                            product:getTextdraw():getX(),
                            product:getTextdraw():getY(),
                            product:getTextdraw():getWidth(),
                            product:getTextdraw():getHeight(),
                            '0x00000000',
                            private:getBorder(),
                            _base:getClass('color'):getAlpha(100) .. color,
                            50
                        )
                        _base:getClass('render'):pushText(
                            _base:getClass('font'):get('Verdana', 8, 9),
                            _base:getClass('helper'):formatPrice(price),
                            product:getTextdraw():getX() + 5,
                            product:getTextdraw():getY() + 5,
                            _base:getClass('color'):getAlpha(100) .. color
                        )
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
        :add({private:getName(), 'clear'}, function ()
            private:setProducts({})
        end)
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