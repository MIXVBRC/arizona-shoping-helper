local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['scanning'] = false,
        ['scanningProduct'] = nil,
        ['border'] = 1,
        ['minmax'] = _base:getNewClass('minMax', _minmax),
        ['configManager'] = _base:getNewClass('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function this:isActive()
        return private.configManager:get('active')
    end

    function this:toggleActive()
        private.configManager:set('active', not this:isActive())
        return this
    end

    -- ADD

    function this:isAdd()
        return private.configManager:get('add')
    end

    function this:toggleAdd()
        private.configManager:set('add', not this:isAdd())
        if this:isAdd() then
            if _base:getClass('select') ~= nil and _base:getClass('select'):isAdd() then
                _base:getClass('select'):toggleAdd()
            end
            if _base:getClass('pricer') ~= nil and _base:getClass('pricer'):isAdd() then
                _base:getClass('pricer'):toggleAdd()
            end
        end
        return this
    end

    -- TIME

    function private:getTime()
        return private.configManager:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.configManager:set('time', private.minmax:get(time, 'time'))
        return this
    end

    -- SCANNING

    function this:isScanning()
        if private:getScanningProduct() ~= nil then
            return true
        end
        return false
    end

    -- SCANNING PRODUCT

    function private:getScanningProduct()
        return private.scanningProduct
    end

    function private:setScanningProduct(product)
        private.scanningProduct = product
        return this
    end

    -- CODES

    function private:getCodes()
        return private.configManager:get('codes') or {}
    end

    function private:setCodes(productCodes)
        productCodes = productCodes or {}
        private.configManager:set('codes', productCodes)
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

    -- function this:extractNameFromDialog(text)
    --     return _base:getClass('helper')
    --     :trim((_base:getClass('helper')
    --     :explode('\n', _base:getClass('helper')
    --     :removeColors(text))[1])
    --     :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_item'),'')
    --     :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_bottle'),'')
    --     :gsub(_base:getClass('message'):get('system_regex_gsub_dialog_text_item_match_accessory'),''))
    -- end

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
                    if this:isActive() and not this:isAdd() and not _base:getClass('swipe'):isSwipe() then
                        local products = {}
                        for _, product in ipairs(_base:getClass('productManager'):getProducts()) do
                            if not product:isScanned() then
                                table.insert(products, product)
                            end
                        end
                        if #products > 0 then
                            for _, product in ipairs(products) do
                                if this:isActive()
                                and not product:isDelete()
                                and private:haveCode(product:getCode())
                                and sampTextdrawIsExists(product:getTextdraw():getId())
                                then
                                    private:setScanningProduct(product)
                                    product:delete()
                                    sampSendClickTextdraw(product:getTextdraw():getId())
                                    wait(private:getTime())
                                end
                            end
                            private:setScanningProduct(nil)
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
                local product = private:getScanningProduct()
                if product ~= nil then
                    _base:getClass('chat'):push(this:extractNameFromDialog(text))
                    _base:getClass('productManager'):createProduct(
                        this:extractNameFromDialog(text),
                        product:getCode(),
                        product:getPrice(),
                        product:getTextdraw()
                    )
                    private:setScanningProduct(nil)
                    _base:getClass('dialogManager'):close()
                    return false
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