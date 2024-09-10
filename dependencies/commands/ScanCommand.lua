local class = {}
function class:new(_name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['scanning'] = false,
        ['scanningProduct'] = nil,
        ['border'] = 1,
        ['minmax'] = _sh.dependencies.minMax:new(_minmax),
        ['configManager'] = _sh.dependencies.configManager:new(_name, _default),
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
            if _sh.select ~= nil and _sh.select:isAdd() then
                _sh.select:toggleAdd()
            end
            if _sh.pricer ~= nil and _sh.pricer:isAdd() then
                _sh.pricer:toggleAdd()
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
        return _sh.helper
        :trim((_sh.helper
        :explode('\n', _sh.helper
        :removeColors(text))[1])
        :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_item'),'')
        :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_bottle'),'')
        :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_accessory'),''))
    end

    -- function this:extractNameFromDialog(text)
    --     return _sh.helper
    --     :trim((_sh.helper
    --     :explode('\n', _sh.helper
    --     :removeColors(text))[1])
    --     :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_item'),'')
    --     :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_bottle'),'')
    --     :gsub(_sh.message:get('system_regex_gsub_dialog_text_item_match_accessory'),''))
    -- end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _sh.commandManager
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'time'}, function (time)
            private:setTime(_sh.helper:getNumber(time))
        end)
        return private
    end

    function private:initThreads()
        _sh.threadManager:add(
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
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() and _sh.player:isShoping() and not _sh.swipe:isSwipe() then
                        for _, product in ipairs(_sh.productManager:getProducts()) do
                            if not product:isScanned() and private:haveCode(product:getCode()) then
                                _sh.boxManager:push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private.border,
                                    _sh.color:getAlpha(50)..'ffffff',
                                    1
                                )
                            end
                        end
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() and not this:isAdd() and not _sh.swipe:isSwipe() then
                        local products = {}
                        for _, product in ipairs(_sh.productManager:getProducts()) do
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
        _sh.eventManager:add(
            'onClickProduct',
            function (product)
                if this:isActive() and this:isAdd() and _sh.player:isShoping() then
                    private:toggleCode(product:getCode())
                    return false
                end
            end,
            1
        )
        _sh.eventManager:add(
            'onShowDialogBuyProduct',
            function (_, _, _, _, _, text)
                local product = private:getScanningProduct()
                if product ~= nil then
                    _sh.chat:push(this:extractNameFromDialog(text))
                    _sh.productManager:createProduct(
                        this:extractNameFromDialog(text),
                        product:getCode(),
                        product:getPrice(),
                        product:getTextdraw()
                    )
                    private:setScanningProduct(nil)
                    _sh.dialogManager:close()
                    return false
                end
            end,
            1000
        )
        _sh.eventManager:add(
            'onShowDialogBuyProductList',
            function (id)
                if this:isScanning() then
                    _sh.dialogManager:send(id, 1, 0)
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