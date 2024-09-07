local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['scanning'] = false,
        ['border'] = 1,
        ['minmax'] = _sh.dependencies.minMax:new({
            ['time'] = {
                ['min'] = 200,
                ['max'] = 1000,
            },
        }),
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

    function private:setCodes(productNames)
        productNames = productNames or {}
        private.configManager:set('codes', productNames)
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
        local productNames = private:getCodes()
        table.insert(productNames, name)
        private:setCodes(productNames)
        return public
    end

    function private:deleteCode(name)
        local productNames = {}
        for _, productName in ipairs(private:getCodes()) do
            if name ~= productName then
                table.insert(productNames, productName)
            end
        end
        private:setCodes(productNames)
        return public
    end

    function private:toggleCode(name)
        for _, productName in ipairs(private:getCodes()) do
            if name == productName then
                private:deleteCode(name)
                return public
            end
        end
        private:addCode(name)
        return public
    end

    -- WORK

    function private:work()
        local products = {}
        for _, product in ipairs(_sh.productManager:getProducts()) do
            if not product:isScanned() then
                table.insert(products, product)
            end
        end
        if #products > 0 then
            private:setScanning(true)
            for _, product in ipairs(products) do
                if product:isExist() and public:isActive() and private:haveCode(product:getTextdraw():getCode()) then
                    product:scan()
                    wait(private:getTime())
                end
            end
            private:setScanning(false)
        end
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
                    if public:isActive() and not public:isAdd() then
                        private:work()
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if public:isActive() then
                        for _, product in ipairs(_sh.productManager:getProducts()) do
                            if not product:isScanned() and private:haveCode(product:getTextdraw():getCode()) then
                                _sh.render:pushBox(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private.border,
                                    _sh.color:getAlpha(50)..'ffffff'
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
                if _sh.player:inShop() and public:isActive() and public:isAdd() then
                    private:toggleCode(product:getTextdraw():getCode())
                end
            end
        )
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if _sh.player:inShop() and public:isActive() and public:isAdd() then
                    _sh.dialogManager:close()
                    return false
                else
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