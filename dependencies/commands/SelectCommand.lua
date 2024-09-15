local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
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
            if _base:get('scan') ~= nil then
                _base:get('scan'):setAdd(false)
            end
            if _base:get('pricer') ~= nil then
                _base:get('pricer'):setAdd(false)
            end
        end
        return this
    end

    -- BORDER

    function private:getBorder()
        return private.config:get('border') or private.minmax:getMin('border')
    end

    function private:setBorder(border)
        private.config:set('border', private.minmax:get(border, 'border'))
        return private
    end

    -- COLOR

    function private:getColor()
        return private.config:get('color')
    end

    function private:setColor(color)
        return private.config:set('color', color or '0000ff')
    end

    -- ALPHA

    function private:getAlpha()
        return private.config:get('alpha') or private.minmax:getMin('alpha')
    end

    function private:setAlpha(alpha)
        return private.config:set('alpha', private.minmax:get(alpha, 'alpha'))
    end

    -- PRODUCTS

    function private:getProducts()
        return private.config:get('products') or {}
    end

    function private:setProducts(products)
        private.config:set('products', products or {})
        return private
    end

    function private:getProduct(sign)
        for _, productSign in ipairs(private:getProducts()) do
            if sign == productSign then
                return productSign
            end
        end
        return nil
    end

    function private:addProduct(sign)
        local products = private:getProducts()
        table.insert(products, sign)
        private:setProducts(products)
        return private
    end

    function private:deleteProduct(sign)
        local products = {}
        for _, productSign in ipairs(private:getProducts()) do
            if sign ~= productSign then
                table.insert(products, productSign)
            end
        end
        private:setProducts(products)
        return private
    end

    function private:toggleProduct(sign)
        for _, productSign in ipairs(private:getProducts()) do
            if sign == productSign then
                private:deleteProduct(sign)
                return this
            end
        end
        private:addProduct(sign)
        return private
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
            private:setProducts({})
        end)
        :add({private:getName(), 'border'}, function (border)
            private:setBorder(_base:get('helper'):getNumber(border))
        end)
        :add({private:getName(), 'color'}, function (color)
            if color:find('^%w%w%w%w%w%w$') then
                private:setColor(color)
            end
        end)
        :add({private:getName(), 'alpha'}, function (border)
            private:setAlpha(_base:get('helper'):getNumber(border))
        end)
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if this:isActive() and _base:get('playerManager'):isShoping() and not _base:get('dialogManager'):isOpened() then
                        for _, product in ipairs(_base:get('productManager'):getProducts()) do
                            local sign = private:getProduct(product:getSign()) or private:getProduct(product:getCode())
                            if sign ~= nil then
                                _base:get('boxManager'):push(
                                    product:getTextdraw():getX(),
                                    product:getTextdraw():getY(),
                                    product:getTextdraw():getWidth(),
                                    product:getTextdraw():getHeight(),
                                    '0x00000000',
                                    private:getBorder(),
                                    _base:get('color'):getAlpha(private:getAlpha()) .. private:getColor(),
                                    5
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
                if this:isAdd() and not isKeyDown(VK_CONTROL) and _base:get('playerManager'):isShoping() then
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