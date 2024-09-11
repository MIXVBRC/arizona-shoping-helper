local class = {}
function class:new(base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = base:getObject('minMax'):new(base, _minmax),
        ['configManager'] = base:getObject('configManager'):new(base, _name, _default),
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
            if base:getClass('scan'):isAdd() then
                base:getClass('scan'):toggleAdd()
            end
            if base:getClass('pricer') ~= nil and base:getClass('pricer'):isAdd() then
                base:getClass('pricer'):toggleAdd()
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
        if base:getClass('playerManager'):isShoping() and not base:getClass('dialogManager'):isOpened() and not base:getClass('swipe'):isSwipe() then
            for _, sign in ipairs(private:getProducts()) do
                for _, product in ipairs(base:getClass('productManager'):getProducts()) do
                    if sign == product:getSign() then
                        base:getClass('boxManager'):push(
                            product:getTextdraw():getX(),
                            product:getTextdraw():getY(),
                            product:getTextdraw():getWidth(),
                            product:getTextdraw():getHeight(),
                            '0x00000000',
                            private:getBorder(),
                            base:getClass('color'):getAlpha(private:getAlpha()) .. private:getColor(),
                            5
                        )
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if base:getClass(private:getName()) ~= nil then
            return base:getClass(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        base:getClass('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'add'}, this.toggleAdd)
        :add({private:getName(), 'border'}, function (border)
            private:setBorder(base:getClass('helper'):getNumber(border))
        end)
        :add({private:getName(), 'color'}, function (color)
            if color:find('^%w%w%w%w%w%w$') then
                private:setColor(color)
            end
        end)
        :add({private:getName(), 'alpha'}, function (border)
            private:setAlpha(base:getClass('helper'):getNumber(border))
        end)
        return private
    end

    function private:initThreads()
        base:getClass('threadManager'):add(
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
        base:getClass('eventManager'):add(
            'onClickProduct',
            function (product)
                if not base:getClass('scan'):isScanning() and base:getClass('playerManager'):isShoping() and this:isActive() and this:isAdd() then
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