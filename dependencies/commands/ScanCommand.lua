local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['scanning'] = false,
        ['product'] = nil,
        ['border'] = 1,
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
            if _base:getClass('select') ~= nil and _base:getClass('select'):isAdd() then
                _base:getClass('select'):toggleAdd()
            end
            if _base:getClass('pricer') ~= nil and _base:getClass('pricer'):isAdd() then
                _base:getClass('pricer'):toggleAdd()
            end
            if _base:getClass('buyer') ~= nil and _base:getClass('buyer'):isAdd() then
                _base:getClass('buyer'):toggleAdd()
            end
        end
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

    -- SCANNING

    function this:isScanning()
        return private:getScanningProduct() ~= nil
    end

    -- SCANNING PRODUCT

    function private:getScanningProduct()
        return private.product
    end

    function private:setScanningProduct(product)
        private.product = product
        return this
    end

    -- CODES

    function private:getCodes()
        return private.config:get('codes') or {}
    end

    function private:setCodes(productCodes)
        private.config:set('codes', productCodes or {})
        return this
    end

    function private:haveCode(_code)
        for _, code in ipairs(private:getCodes()) do
            if _code == code then
                return true
            end
        end
        return false
    end

    function private:addCode(name)
        local productCodes = private:getCodes()
        table.insert(productCodes, name)
        private:setCodes(productCodes)
        return this
    end

    function private:deleteCode(code)
        local productCodes = {}
        for _, productCode in ipairs(private:getCodes()) do
            if code ~= productCode then
                table.insert(productCodes, productCode)
            end
        end
        private:setCodes(productCodes)
        return this
    end

    function private:toggleCode(code)
        for _, productCode in ipairs(private:getCodes()) do
            if code == productCode then
                private:deleteCode(code)
                return this
            end
        end
        private:addCode(code)
        return this
    end

    -- EXTRACTS

    function this:extractNameFromDialog(text)
        return _base:getClass('helper')
        :trim((_base:getClass('helper')
        :explode('\n', _base:getClass('helper')
        :removeColors(text))[1])
        :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_item'),'')
        :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_bottle'),'')
        :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_accessory'),''))
    end

    function this:extractCountFromDialog(text)
        local explode = _base:getClass('helper'):explode('\n', _base:getClass('helper'):removeColors(text))
        for index = #explode, 1, -1 do
            if explode[index]:find(_base:getClass('message'):get('system_regex_find_dialog_text_buy_product_count')) then
                return _base:getClass('helper'):getNumber(explode[index]:match(_base:getClass('message'):get('system_regex_match_dialog_text_buy_product_count')))
            end
        end
    end

    function this:extractEnoughCountFromDialog(text)
        local explode = _base:getClass('helper'):explode('\n', _base:getClass('helper'):removeColors(text))
        for index = #explode, 1, -1 do
            if explode[index]:find(_base:getClass('message'):get('system_regex_find_dialog_text_buy_product_enough_count')) then
                return _base:getClass('helper'):getNumber(explode[index]:match(_base:getClass('message'):get('system_regex_match_dialog_text_buy_product_enough_count')))
            end
        end
    end

    function this:scan(product)
        if not this:isScanning() then
            private:setScanningProduct(product)
        end
    end

    -- WORK

    function private:work(text)
        if this:isScanning() then
            local product = private:getScanningProduct()
            if product ~= nil then
                product:delete()
                product = _base:getClass('productManager'):createProduct(
                    this:extractNameFromDialog(text),
                    product:getCode(),
                    product:getPrice(),
                    this:extractCountFromDialog(text),
                    product:getTextdraw()
                )
                private:setScanningProduct(nil)
                _base:getClass('dialogManager'):close()
                _base:getClass('eventManager'):trigger('onScanProduct', product)
                return false
            end
        end
        private:setScanningProduct(nil)
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
            private:setCodes({})
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
                while true do wait(50)
                    private.border = private.border - 1
                    if private.border <= 0 then
                        private.border = 10
                    end
                end
            end
        )
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if not _base:getClass('dialogManager'):isOpened() then
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if product:isScanned() then
                                _base:getClass('render'):pushText(
                                    _base:getClass('font'):get('Arial', 12, 0),
                                    'S',
                                    product:getTextdraw():getX() + product:getTextdraw():getWidth() - 15,
                                    product:getTextdraw():getY() + 3,
                                    _base:getClass('color'):getAlpha(100) .. _base:getClass('color'):get('blue')
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
                    if this:isActive() and _base:getClass('playerManager'):isShoping() and not _base:getClass('swipe'):isSwipe() then
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if not product:isScanned() and private:haveCode(product:getCode()) then
                                _base:getClass('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private.border,
                                    _base:getClass('color'):getAlpha(50)..'ffffff',
                                    1
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
                    if this:isActive()
                    and not this:isAdd()
                    and _base:getClass('playerManager'):isShoping()
                    and not _base:getClass('swipe'):isSwipe() then
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if not product:isScanned() and private:haveCode(product:getCode()) and sampTextdrawIsExists(product:getTextdraw():getId()) then
                                private:setScanningProduct(product)
                                sampSendClickTextdraw(product:getTextdraw():getId())
                                while this:isScanning() do wait(0) end
                                wait(private:getTime())
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
                if this:isActive() and this:isAdd() and _base:getClass('playerManager'):isShoping() then
                    private:toggleCode(product:getCode())
                    return false
                end
            end,
            1
        )
        :add(
            'onShowDialogBuyProduct',
            function (_, _, _, _, _, text)
                if this:isScanning() then
                    return private:work(text)
                end
            end,
            1000
        )
        :add(
            'onShowDialogBuyProductCount',
            function (_, _, _, _, _, text)
                if this:isScanning() then
                    return private:work(text)
                end
            end,
            1000
        )
        :add(
            'onShowDialogBuyProductList',
            function (id)
                if this:isScanning() then
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