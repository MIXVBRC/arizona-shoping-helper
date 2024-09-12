local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['buying'] = nil,
        ['products'] = {},
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
            if _base:getClass('pricer') ~= nil and _base:getClass('pricer'):isAdd() then
                _base:getClass('pricer'):toggleAdd()
            end
        end
        return this
    end

    -- BUYING

    function this:isBuying()
        return private.buying ~= nil
    end

    function this:getBuying()
        return private.buying
    end

    function this:setBuying(buying)
        private.buying = buying
        return this
    end

    -- PRICE

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

    function private:getProduct(name)
        for _, product in ipairs(private:getProducts()) do
            if name == product.name then
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
        :add({private:getName(), 'time'}, function (time)
            private:setTime(_base:getClass('helper'):getNumber(time))
        end)
        return private
    end

    function private:initThreads()
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if _base:getClass('playerManager'):isShoping() and not _base:getClass('dialogManager'):isOpened() then
                        local products = {}
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if product:isScanned() and not product:isDelete() then
                                local _product = private:getProduct(product:getCode())
                                if _product ~= nil and product:getPrice() <= _product.price then
                                    table.insert(products, product)
                                end
                            end
                        end
                        private.products = products
                        if #products > 0 and not _base:getClass('dialogManager'):isOpened() then
                            for _, product in ipairs(products) do
                                _base:getClass('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private:getBorder(),
                                    _base:getClass('color'):getAlpha(100) .. _base:getClass('color'):get('orange'),
                                    25
                                )
                            end
                        end
                    end
                end
            end
        )
        :add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() and not this:isAdd() and not _base:getClass('scan'):isScanning() then
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if product:isScanned() and not product:isDelete() then
                                local _product = private:getProduct(product:getName())
                                if _product ~= nil and not product:isDelete() and product:getPrice() <= _product.price and product:getName() == _product.name then
                                    this:setBuying(product)
                                    sampSendClickTextdraw(product:getTextdraw():getId())
                                    wait(private:getTime())
                                    this:setBuying(nil)
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
        _base:getClass('eventManager')
        :add(
            'onClickProduct',
            function (product)
                if this:isActive() and this:isAdd() and not _base:getClass('scan'):isScanning() and _base:getClass('playerManager'):isShoping() then
                    if product:isScanned() then
                        _base:getClass('dialogManager'):show(
                            _base:getClass('message'):get('message_dialog_title_enter_price_zero'),
                            product:getName(),
                            _base:getClass('message'):get('message_dialog_button_ready'),
                            _base:getClass('message'):get('message_dialog_button_cancel'),
                            1,
                            function (button, _, input)
                                if button == 1 then
                                    input = _base:getClass('helper'):getNumber(input)
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
                                            ['price'] = input
                                        })
                                    end
                                end
                            end
                        )
                    else
                        _base:getClass('chat'):push('Товар не отсканирован!')
                    end
                    return false
                end
            end
        )
        :add(
            'onShowDialogBuyProduct',
            function (id, _, _, _, _, text)
                if this:isActive() and this:isBuying() then
                    local product = this:getBuying()
                    if product ~= nil then
                        local name = _base:getClass('scan'):extractNameFromDialog(text)
                        if name == product:getName() then
                            _base:getClass('dialogManager'):send(id, 1)
                        else
                            _base:getClass('dialogManager'):close(id)
                        end
                    else
                        _base:getClass('dialogManager'):close(id)
                    end
                    this:setBuying(nil)
                    return false
                end
            end,
            1000
        )
        :add(
            'onShowDialogBuyProductCount',
            function (id, _, _, _, _, text)
                if this:isActive() and this:isBuying() then
                    local product = this:getBuying()
                    if product ~= nil then
                        local name = _base:getClass('scan'):extractNameFromDialog(text)
                        if name == product:getName() then
                            local count = _base:getClass('scan'):extractCountFromDialog(text)
                            local enoughCount = _base:getClass('scan'):extractEnoughCountFromDialog(text)
                            if enoughCount < count then
                                count = enoughCount
                            end
                            _base:getClass('dialogManager'):send(id, 1, nil, count)
                        else
                            _base:getClass('dialogManager'):close(id)
                        end
                    else
                        _base:getClass('dialogManager'):close(id)
                    end
                    this:setBuying(nil)
                    return false
                end
            end,
            1000
        )
        :add(
            'onShowDialogBuyProductList',
            function (id)
                if this:isActive() and this:isBuying() then
                    _base:getClass('dialogManager'):send(id, 1, 0)
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