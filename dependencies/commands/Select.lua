local class = {}
function class:new(_name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _sh.dependencies.minMax:new(_minmax),
        ['configManager'] = _sh.dependencies.configManager:new(_name, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
    }

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
            if _sh.scan:isAdd() then
                _sh.scan:toggleAdd()
            end
            if _sh.price ~= nil and _sh.price:isAdd() then
                _sh.price:toggleAdd()
            end
        end
        return this
    end

    -- BORDER

    function private:getBorder()
        return private.configManager:get('border') or private.minmax:getMin('border')
    end

    function private:setBorder(border)
        private.configManager:set('border', private.minmax:get(border, 'border'))
        return this
    end

    -- COLOR

    function private:getColor()
        return private.configManager:get('color')
    end

    function private:setColor(color)
        return private.configManager:set('color', color or '0000ff')
    end

    -- ALPHA

    function private:getAlpha()
        return private.configManager:get('alpha') or private.minmax:getMin('alpha')
    end

    function private:setAlpha(alpha)
        return private.configManager:set('alpha', private.minmax:get(alpha, 'alpha'))
    end

    -- PRODUCTS

    function private:getProducts()
        return private.configManager:get('products') or {}
    end

    function private:setProducts(products)
        products = products or {}
        private.configManager:set('products', products)
        return this
    end

    function private:addProduct(sign)
        local products = private:getProducts()
        table.insert(products, sign)
        private:setProducts(products)
        return this
    end

    function private:deleteProduct(sign)
        local products = {}
        for _, productSign in ipairs(private:getProducts()) do
            if sign ~= productSign then
                table.insert(products, productSign)
            end
        end
        private:setProducts(products)
        return this
    end

    function private:toggleProduct(sign)
        for _, productSign in ipairs(private:getProducts()) do
            if sign == productSign then
                private:deleteProduct(sign)
                return this
            end
        end
        private:addProduct(sign)
        return this
    end

    -- WORK

    function private:work()
        if _sh.player:isShoping() and not _sh.dialogManager:isOpened() and not _sh.swipe:isSwipe() then
            for _, sign in ipairs(private:getProducts()) do
                for _, product in ipairs(_sh.productManager:getProducts()) do
                    if sign == product:getSign() then
                        _sh.boxManager:push(
                            product:getTextdraw():getX(),
                            product:getTextdraw():getY(),
                            product:getTextdraw():getWidth(),
                            product:getTextdraw():getHeight(),
                            '0x00000000',
                            private:getBorder(),
                            _sh.color:getAlpha(private:getAlpha()) .. private:getColor(),
                            5
                        )
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        private.commandManager
        :add('active', this.toggleActive)
        :add('add', this.toggleAdd)
        :add('border', function (border)
            private:setBorder(_sh.helper:getNumber(border))
        end)
        :add('color', function (color)
            if color:find('^%w%w%w%w%w%w$') then
                private:setColor(color)
            end
        end)
        :add('alpha', function (border)
            private:setAlpha(_sh.helper:getNumber(border))
        end)
        return private
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() then
                        private:work()
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
                if not _sh.scan:isScanning() and _sh.player:isShoping() and this:isActive() and this:isAdd() then
                    private:toggleProduct(product:getSign())
                    return false
                end
            end
        )
        return private
    end

    return private:init()
end
return class