local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['product'] = {
            ['textdraw'] = nil,
            ['count'] = 1,
            ['last'] = false,
        },
        ['products'] = {},
        ['config'] = _base:getNew('configManager', _name, _default),
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
        return private
    end

    -- PRODUCT

    function private:getProduct()
        return private.product
    end

    function private:setProduct(textdraw, count, last)
        private.product = {
            ['textdraw'] = textdraw,
            ['count'] = count or 1,
            ['last'] = last or false,
        }
        return private
    end

    -- COUNT

    function private:getCount()
        return private.count
    end

    function private:setCount(count)
        private.count = count or 1
        return private
    end

    -- TEXTDRAW

    function private:getTextdraw()
        return private.textdraw
    end

    function private:setTextdraw(textdraw)
        private.textdraw = textdraw
        return private
    end

    -- PRICES

    function private:getPrices()
        return private.config:get('prices') or {}
    end

    function private:setPrices(prices)
        private.config:set('prices', prices or {})
        return private
    end

    function private:getPrice(name)
        for _, price in ipairs(private:getPrices()) do
            if name == price.name then
                return price.value
            end
        end
        return nil
    end

    function private:addPrice(name, price)
        local prices = private:getPrices()
        table.insert(prices, {
            ['name'] = name,
            ['value'] = price,
        })
        private:setPrices(prices)
        return private
    end

    function private:changePrice(name, value)
        local prices = private:getPrices()
        for _, price in ipairs(prices) do
            if name == price.name then
                price.value = value
            end
        end
        private:setPrices(prices)
        return nil
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
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onClickNotProduct',
            function (textdraw)
                if _base:get('playerManager'):isAdmining() and private:isActive() then
                    local count = 1
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        local text = childTextdraw:getText():gsub(',','')
                        if _base:get('helper'):isNumber(text) then
                            count = _base:get('helper'):getNumber(text)
                            break
                        end
                    end
                    private:setProduct(textdraw, count, isKeyDown(VK_CONTROL))
                end
            end,
            1
        )
        :add(
            'onShowDialogSaleProduct',
            function (id, _, _, _, _, text)
                if _base:get('playerManager'):isAdmining() and private:isActive() then
                    local name = _base:get('helper'):trim(text:match(_base:get('message'):get('system_regex_match_dialog_text_sale_product')))
                    return _base:get('eventManager'):trigger('onShowDialogSaleProductCustom', id, name)
                end
            end
        )
        :add(
            'onShowDialogSaleProductCount',
            function (id, _, _, _, _, text)
                if _base:get('playerManager'):isAdmining() and private:isActive() then
                    local name = _base:get('helper'):trim(text:match(_base:get('message'):get('system_regex_match_dialog_text_sale_product_count')))
                    return _base:get('eventManager'):trigger('onShowDialogSaleProductCustom', id, name, private:getProduct().count)
                end
            end
        )
        :add(
            'onShowDialogSaleProductCustom',
            function (id, name, count)
                if name ~= nil then
                    local price = private:getPrice(name)
                    if price ~= nil and not isKeyDown(VK_SHIFT) then
                        if count ~= nil then
                            if private:getProduct().last then
                                count = count - 1
                                if count <= 0 then
                                    count = 1
                                end
                            end
                            _base:get('chat'):push(_base:get('message'):get('message_trade_add_product_count', {
                                name,
                                count,
                                _base:get('helper'):formatPrice(price),
                            }))
                            price = _base:get('helper'):implode(',', {count, price})
                        else
                            _base:get('chat'):push(_base:get('message'):get('message_trade_add_product', {
                                name,
                                _base:get('helper'):formatPrice(price),
                            }))
                        end
                        _base:get('dialogManager'):send(id, 1, 0, price)
                    else
                        _base:get('dialogManager'):close(id)
                        _base:get('queueManager')
                        :add(
                            function ()
                                _base:get('dialogManager'):show(
                                    _base:get('message'):get('message_dialog_title_enter_price'),
                                    name,
                                    _base:get('message'):get('message_dialog_button_add'),
                                    _base:get('message'):get('message_dialog_button_cancel'),
                                    1,
                                    function (_, input)
                                        input = _base:get('helper'):getNumber(input)
                                        if private:getPrice(name) ~= nil then
                                            private:changePrice(name, input)
                                        else
                                            private:addPrice(name, input)
                                        end
                                        local textdraw = private:getProduct().textdraw
                                        if textdraw ~= nil then
                                            sampSendClickTextdraw(textdraw:getId())
                                        end
                                    end
                                )
                            end,
                            1
                        )
                        :push()
                    end
                end
                return false
            end
        )
        :add(
            'onShowDialogRemoveSaleProduct',
            function (id)
                if _base:get('playerManager'):isAdmining() and private:isActive() then
                    _base:get('dialogManager'):send(id, 1)
                    return false
                end
            end,
            1
        )
        :add(
            'onServerMessage',
            function (_, text)
                text = _base:get('helper'):removeColors(text or '')
                if text:find(_base:get('message'):get('system_regex_find_chat_sale_product'))
                or text:find(_base:get('message'):get('system_regex_find_chat_remove_sale_product'))
                then
                    return false
                end
            end,
            1
        )
        return private
    end

    return private:init()
end
return class