local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['edit'] = false,
        ['product'] = {
            ['textdraw'] = nil,
            ['count'] = 1,
            ['needCount'] = false,
            ['editType'] = 'add',
        },
        ['products'] = {},
        ['config'] = _base:getInit('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:toggleActive()
        private.config:set('active', not private:isActive())
        return this
    end

    -- EDIT

    function private:isEdit()
        return private.edit
    end

    function private:setEdit(bool)
        private.edit = bool
        return this
    end

    -- PRODUCT

    function private:getProduct()
        return private.product
    end

    function private:setProduct(textdraw, count, needCount, editType)
        private.product = {
            ['textdraw'] = textdraw,
            ['count'] = count,
            ['needCount'] = needCount,
            ['editType'] = editType,
        }
        return this
    end

    function private:clearProduct()
        private:setProduct(nil, 1, false, 'add')
        return this
    end

    -- PRODUCTP RICES

    function private:getProductPrices()
        return private.config:get('prices') or {}
    end

    function private:setProductPrices(prices)
        private.config:set('prices', prices or {})
        return this
    end

    function private:getProductPrice(code)
        return private:getProductPrices()[code]
    end

    function private:addProductPrice(code, price)
        local prices = private:getProductPrices()
        prices[code] = price
        private:setProductPrices(prices)
        return this
    end

    -- PRODUCTS

    function this:getProducts()
        return private.products
    end

    function private:setProducts(products)
        private.products = products
        return this
    end

    function private:changeProduct(name, price, count)
        for _, product in ipairs(this:getProducts()) do
            if name == product.name then
                if price ~= nil and price > 0 then
                    product.price = price
                end
                product.count = product.count + count
                if product.count <= 0 then
                    private:deleteProduct(name)
                end
                return this
            end
        end
        if count > 0 then
            table.insert(private.products, {
                ['name'] = name,
                ['price'] = price,
                ['count'] = count,
            })
        end
        return this
    end

    function private:deleteProduct(name)
        local products = {}
        for _, product in ipairs(this:getProducts()) do
            if name ~= product.name then
                table.insert(products, product)
            end
        end
        private:setProducts(products)
        return this
    end

    -- LOGIC

    function private:getStatusProducts()
        if #this:getProducts() > 0 then
            local globalPrice = 0
            for _, product in ipairs(this:getProducts()) do
                local fullPrice = product.price * product.count
                _base:get('chat'):push(_base:get('helper'):implode(' | ', {
                    product.name,
                    product.count,
                    _base:get('helper'):formatPrice(product.price),
                    _base:get('helper'):formatPrice(fullPrice),
                }))
                globalPrice = globalPrice + fullPrice
            end
            _base:get('chat'):push(_base:get('helper'):formatPrice(globalPrice))
        end
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'clear'}, private.setProductPrices)
        :add({private:getName(), 'status'}, private.getStatusProducts)
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onSendClickTextDraw',
            function (textdrawId)
                if private:isEdit() then
                    return false
                else
                    if _base:get('playerManager'):isAdmining() and private:isActive() then
                        local textdraw = _base:get('textdrawManager'):getTextdrawById(textdrawId)
                        if textdraw ~= nil then
                            local count = 1
                            local needCount = false
                            for _, childTextdraw in ipairs(textdraw:getChilds()) do
                                if _base:get('helper'):isPrice(childTextdraw:getText()) then
                                    private:setProduct(textdraw, 1, false, 'delete')
                                    return
                                elseif _base:get('helper'):isNumber(childTextdraw:getText()) then
                                    count = _base:get('helper'):getNumber(childTextdraw:getText())
                                    needCount = true
                                    break
                                end
                            end
                            if isKeyDown(VK_CONTROL) then
                                count = count - 1
                                if count <= 0 then
                                    return false
                                end
                            end
                            private:setProduct(textdraw, count, needCount, 'add')
                        end
                    end
                end
            end,
            1
        )
        :add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if _base:get('playerManager'):isAdmining() and private:isActive() then
                    local product = private:getProduct()
                    if product.textdraw ~= nil then
                        if product.editType == 'add' then
                            local name = text:match('^.*%(%s+{.+}(.+){.+}%s+%).*$')
                            local price = private:getProductPrice(name)
                            if price ~= nil and not isKeyDown(VK_SHIFT) then
                                local input = price
                                if product.needCount and product.count ~= nil then
                                    input =  _base:get('helper'):implode(',', {product.count, price})
                                    _base:get('chat'):push(_base:get('message'):get('message_trade_add_product_count', {
                                        name,
                                        product.count,
                                        _base:get('helper'):formatPrice(price),
                                    }))
                                else
                                    _base:get('chat'):push(_base:get('message'):get('message_trade_add_product', {
                                        name,
                                        _base:get('helper'):formatPrice(price),
                                    }))
                                end
                                private:changeProduct(name, price, product.count)
                                _base:get('dialogManager'):send(dialogId, 1, 0, input)
                                private:clearProduct()
                            else
                                _base:get('dialogManager'):close()
                                private:setEdit(true)
                                _base:get('dialogManager'):show(
                                    _base:get('message'):get('message_dialog_title_enter_price'),
                                    name,
                                    _base:get('message'):get('message_dialog_button_add'),
                                    _base:get('message'):get('message_dialog_button_cancel'),
                                    1,
                                    function (button, _, input)
                                        private:setEdit(false)
                                        if button == 1 then
                                            input = _base:get('helper'):getNumber(input)
                                            private:addProductPrice(name, input)
                                            sampSendClickTextdraw(product.textdraw:getId())
                                        else
                                            private:clearProduct()
                                        end
                                    end
                                )
                            end
                            return false
                        elseif product.editType == 'delete' then
                            -- local name = _base:get('chat'):push(_base:get('scan'):extractNameFromDialog(text))
                            _base:get('dialogManager'):send(dialogId, 1)
                            return false
                        end
                    end
                end
            end,
            1000
        )
        return private
    end

    return private:init()
end
return class