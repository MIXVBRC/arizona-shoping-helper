local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['editPrice'] = false,
        ['editShop'] = false,
        ['product'] = {
            ['textdraw'] = nil,
            ['count'] = 1,
            ['needCount'] = false,
            ['editType'] = 'add',
        },
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
        return public
    end

    -- EDIT PRICE

    function private:isEditPrice()
        return private.editPrice
    end

    function private:setEditPrice(bool)
        private.editPrice = bool
        return public
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
        return public
    end

    function private:clearProduct()
        private:setProduct(nil, 1, false, 'add')
        return public
    end

    -- PRODUCTPRICES

    function private:getProductPrices()
        return private.configManager:get('prices') or {}
    end

    function private:setProductPrices(prices)
        private.configManager:set('prices', prices or {})
        return public
    end

    function private:getProductPrice(code)
        return private:getProductPrices()[code]
    end

    function private:addProductPrice(code, price)
        local prices = private:getProductPrices()
        prices[code] = price
        private:setProductPrices(prices)
        return public
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('clear', private.setProductPrices)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (textdrawId)
                if private:isEditPrice() then
                    return false
                else
                    if _sh.player:editProducts() and private:isActive() then
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
                            if count > 1 and isKeyDown(VK_CONTROL) then
                                count = count - 1
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
                if _sh.player:editProducts() and private:isActive() then
                    local product = private:getProduct()
                    if product.textdraw ~= nil then
                        if product.editType == 'add' then
                            local name = text:match('^.*%(%s+{.+}(.+){.+}%s+%).*$')
                            local price = private:getProductPrice(name)
                            if price ~= nil and not isKeyDown(VK_SHIFT) then
                                local message = '{00ff00}'.. name
                                local input = price
                                if product.needCount and product.count ~= nil then
                                    input =  table.concat({product.count,price}, ',')
                                    message = message .. '{ffffff} {0000ff}х' .. product.count
                                end
                                _sh.chat:push(input)
                                message = message .. '{ffffff} выставлен за {00ff00}' .. _sh.helper:formatPrice(price)
                                _sh.dialogManager:send(dialogId, 1, 0, input)
                                _sh.chat:push(message)
                                private:clearProduct()
                            else
                                _sh.dialogManager:close()
                                private:setEditPrice(true)
                                _sh.dialogManager:show(
                                    '{65f0c6}Введите цену за предмет',
                                    name,
                                    'Добавить',
                                    'Отмена',
                                    1,
                                    function (button, _, input)
                                        private:setEditPrice(false)
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
                            _sh.dialogManager:send(dialogId, 1)
                            return false
                        end
                    end
                end
            end,
            1000
        )
    end

    private:init()
    return public
end
return class