local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['scanning'] = false,
        ['border'] = 10,
        ['products'] = {},
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
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
            if _base:get('select') ~= nil and _base:get('select'):isAdd() then
                _base:get('select'):toggleAdd()
            end
            if _base:get('pricer') ~= nil and _base:get('pricer'):isAdd() then
                _base:get('pricer'):toggleAdd()
            end
            if _base:get('buyer') ~= nil and _base:get('buyer'):isAdd() then
                _base:get('buyer'):toggleAdd()
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
        return private.products
    end

    function private:setScanningProduct(product)
        private.products = product
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

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'clear'}, function ()
            private:setCodes({})
        end)
        :add({private:getName(), 'time'}, function (time)
            private:setTime(_base:get('helper'):getNumber(time))
        end)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() and _base:get('playerManager'):isShoping() then
                        for _, product in ipairs(_base:get('productManager'):getProducts()) do
                            if not product:isScanned() and private:haveCode(product:getCode()) then
                                product:scan(private:getTime())
                            end
                        end
                    end
                end
            end
        )
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
                    if not _base:get('dialogManager'):isOpened() and _base:get('playerManager'):isShoping() then
                        for _, product in ipairs(_base:get('productManager'):getProducts()) do
                            local haveCode = private:haveCode(product:getCode())
                            if product:isScanned() then
                                _base:get('textManager'):push(
                                    _base:get('font'):get('Arial', 8, 0),
                                    'S',
                                    product:getTextdraw():getX() + product:getTextdraw():getWidth() - 15,
                                    product:getTextdraw():getY() + 5,
                                    _base:get('color'):getAlpha(100) .. _base:get('color'):get('blue'),
                                    5
                                )
                            end
                            if haveCode and not product:isScanned() then
                                _base:get('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private.border,
                                    _base:get('color'):getAlpha(50) .. _base:get('color'):get('white'),
                                    1
                                )
                            elseif not haveCode and product:isScanned() and this:isAdd() then
                                _base:get('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private.border,
                                    _base:get('color'):getAlpha(50) .. _base:get('color'):get('orange'),
                                    1
                                )
                            end
                        end
                    end
                end
            end
        )
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onClickProduct',
            function (product)
                if this:isAdd() and _base:get('playerManager'):isShoping() then
                    private:toggleCode(product:getCode())
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