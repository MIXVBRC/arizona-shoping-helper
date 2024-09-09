local class = {}
function class:new(_command, _default, _minmax)
    local public = {}
    local private = {
        ['scanning'] = false,
        ['border'] = 1,
        ['minmax'] = _sh.dependencies.minMax:new(_minmax),
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function public:isActive()
        return private.configManager:get('active')
    end

    function public:toggleActive()
        private.configManager:set('active', not public:isActive())
        return public
    end

    -- ADD

    function public:isAdd()
        return private.configManager:get('add')
    end

    function public:toggleAdd()
        private.configManager:set('add', not public:isAdd())
        if public:isAdd() then
            if _sh.select ~= nil and _sh.select:isAdd() then
                _sh.select:toggleAdd()
            end
            if _sh.pricer ~= nil and _sh.pricer:isAdd() then
                _sh.pricer:toggleAdd()
            end
        end
        return public
    end

    -- TIME

    function private:getTime()
        return private.configManager:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.configManager:set('time', private.minmax:get(time, 'time'))
        return public
    end

    -- SCANNING

    function public:isScanning()
        return private.scanning
    end

    function private:setScanning(bool)
        private.scanning = bool
        return public
    end

    -- PRODUCTS

    function private:getCodes()
        return private.configManager:get('codes') or {}
    end

    function private:setCodes(productCodes)
        productCodes = productCodes or {}
        private.configManager:set('codes', productCodes)
        return public
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
        return public
    end

    function private:deleteCode(code)
        local productCodes = {}
        for _, productCode in ipairs(private:getCodes()) do
            if code ~= productCode then
                table.insert(productCodes, productCode)
            end
        end
        private:setCodes(productCodes)
        return public
    end

    function private:toggleCode(code)
        for _, productCode in ipairs(private:getCodes()) do
            if code == productCode then
                private:deleteCode(code)
                return public
            end
        end
        private:addCode(code)
        return public
    end

    -- INITS

    function private:init()
        private:initCommands()
        private:initThreads()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
        private.commandManager:add('add', public.toggleAdd)
        private.commandManager:add('time', function (time)
            private:setTime(_sh.helper:getNumber(time))
        end)
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if public:isActive() and not public:isAdd() and not _sh.swipe:isSwipe() then
                        local products = {}
                        for _, product in ipairs(_sh.productManager:getProducts()) do
                            if not product:isScanned() then
                                table.insert(products, product)
                            end
                        end
                        if #products > 0 then
                            private:setScanning(true)
                            for _, product in ipairs(products) do
                                if product:isExist() and public:isActive() and private:haveCode(product:getCode()) then
                                    product:scan()
                                    wait(private:getTime())
                                end
                            end
                            private:setScanning(false)
                        end
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if public:isActive() and _sh.player:isShoping() and not _sh.swipe:isSwipe() then
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
                while true do wait(50)
                    private.border = private.border - 1
                    if private.border <= 0 then
                        private.border = 10
                    end
                end
            end
        )
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onClickProduct',
            function (product)
                if _sh.player:isShoping() and public:isActive() and public:isAdd() then
                    private:toggleCode(product:getCode())
                    return false
                end
            end,
            1
        )
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if public:isScanning() then
                    for _, product in ipairs(_sh.productManager:getProducts()) do
                        if product:isScanning() then
                            product:scanDialogName(dialogId, text)
                            _sh.dialogManager:close()
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