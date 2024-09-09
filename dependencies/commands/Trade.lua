local class = {}
function class:new(_name, _default)
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
        ['configManager'] = _sh.dependencies.configManager:new(_name, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
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
        return private.configManager:get('prices') or {}
    end

    function private:setProductPrices(prices)
        private.configManager:set('prices', prices or {})
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
                _sh.chat:push(_sh.helper:implode(' | ', {
                    product.name,
                    product.count,
                    _sh.helper:formatPrice(product.price),
                    _sh.helper:formatPrice(fullPrice),
                }))
                globalPrice = globalPrice + fullPrice
            end
            _sh.chat:push(_sh.helper:formatPrice(globalPrice))
        end
    end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initCommands():initEvents()
        return this
    end

    function private:initCommands()
        private.commandManager
        :add('active', private.toggleActive)
        :add('clear', private.setProductPrices)
        :add('status', private.getStatusProducts)
        return private
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (textdrawId)
                if private:isEdit() then
                    return false
                else
                    if _sh.player:isAdmining() and private:isActive() then
                        local textdraw = _sh.textdrawManager:getTextdrawById(textdrawId)
                        if textdraw ~= nil then
                            local count = 1
                            local needCount = false
                            for _, childTextdraw in ipairs(textdraw:getChilds()) do
                                if _sh.helper:isPrice(childTextdraw:getText()) then
                                    private:setProduct(textdraw, 1, false, 'delete')
                                    return
                                elseif _sh.helper:isNumber(childTextdraw:getText()) then
                                    count = _sh.helper:getNumber(childTextdraw:getText())
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
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if _sh.player:isAdmining() and private:isActive() then
                    local product = private:getProduct()
                    if product.textdraw ~= nil then
                        if product.editType == 'add' then
                            local name = text:match('^.*%(%s+{.+}(.+){.+}%s+%).*$')
                            local price = private:getProductPrice(name)
                            if price ~= nil and not isKeyDown(VK_SHIFT) then
                                local input = price
                                if product.needCount and product.count ~= nil then
                                    input =  _sh.helper:implode(',', {product.count, price})
                                    _sh.chat:push(_sh.message:get('message_trade_add_product_count', {
                                        name,
                                        product.count,
                                        _sh.helper:formatPrice(price),
                                    }))
                                else
                                    _sh.chat:push(_sh.message:get('message_trade_add_product', {
                                        name,
                                        _sh.helper:formatPrice(price),
                                    }))
                                end
                                private:changeProduct(name, price, product.count)
                                _sh.dialogManager:send(dialogId, 1, 0, input)
                                private:clearProduct()
                            else
                                _sh.dialogManager:close()
                                private:setEdit(true)
                                _sh.dialogManager:show(
                                    _sh.message:get('message_trade_dialog_title'),
                                    name,
                                    _sh.message:get('message_trade_dialog_button_yes'),
                                    _sh.message:get('message_trade_dialog_button_no'),
                                    1,
                                    function (button, _, input)
                                        private:setEdit(false)
                                        if button == 1 then
                                            input = _sh.helper:getNumber(input)
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
                            -- local name = _sh.chat:push(_sh.scan:extractNameFromDialog(text))
                            _sh.dialogManager:send(dialogId, 1)
                            return false
                        end
                    end
                end
            end,
            1000
        )
        -- _sh.eventManager:add(
        --     'onShowDialogRemoveSaleProduct',
        --     function ()
        --         _sh.dialogManager:close()
        --         private:setEdit(true)
        --         _sh.dialogManager:show(
        --             _sh.message:get('message_trade_dialog_title'),
        --             name,
        --             _sh.message:get('message_trade_dialog_button_yes'),
        --             _sh.message:get('message_trade_dialog_button_no'),
        --             1,
        --             function (button, _, input)
        --                 private:setEdit(false)
        --                 if button == 1 then
        --                     input = _sh.helper:getNumber(input)
        --                     private:addProductPrice(name, input)
        --                     sampSendClickTextdraw(product.textdraw:getId())
        --                 else
        --                     private:clearProduct()
        --                 end
        --             end
        --         )
        --     end,
        --     1
        -- )
        return private
    end

    return private:init()
end
return class