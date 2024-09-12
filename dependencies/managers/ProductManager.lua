local class = {}
function class:new(_base, _name)
    local this = {}
    local private = {
        ['name'] = _name,
        ['products'] = {},
        ['lastProduct'] = nil,
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- PRODUCTS

    function this:getProducts()
        return private.products
    end

    function private:setProducts(products)
        private.products = products
        return this
    end

    function private:addProduct(product)
        table.insert(private.products, product)
        private:setLastProduct(product)
        return this
    end

    -- LAST PRODUCT

    function private:getLastProduct()
        return private.lastProduct
    end

    function private:setLastProduct(lastProduct)
        private.lastProduct = lastProduct
        return this
    end

    -- LOGIC

    function this:createProduct(name, code, price, count, textdraw)
        local product = nil
        if code ~= nil and price ~= nil and textdraw ~= nil then
            product = _base:getNewClass('product',
                name,
                code,
                price,
                count,
                textdraw
            )
            private:addProduct(product)
            _base:getClass('eventManager'):trigger('onCreateProduct', product)
        end
        return product
    end

    function private:checkOrCreate(textdraw)
        local product = private:getLastProduct()
        if product ~= nil and product:getTextdraw():getId() == textdraw:getId() then
            product:delete()
        end
        local params = {
            ['code'] = textdraw:getCode(),
            ['price'] = nil,
            ['textdraw'] = textdraw,
        }
        for _, childTextdraw in ipairs(textdraw:getChilds()) do
            if _base:getClass('helper'):isPrice(childTextdraw:getText()) then
                params.price = _base:getClass('helper'):extractPrice(childTextdraw:getText())
            else
                params.code = _base:getClass('helper'):md5(params.code .. childTextdraw:getCode())
            end
        end
        this:createProduct(nil, params.code, params.price, nil, params.textdraw)
    end

    -- INITS

    function private:init()
        if _base:getClass(private:getName()) ~= nil then
            return _base:getClass(private:getName())
        end
        private:initEvents():initThrades()
        return this
    end

    function private:initEvents()
        _base:getClass('eventManager')
        :add(
            'onTextdrawAddChild',
            function (textdraw)
                if _base:getClass('playerManager'):isShoping() then
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        if _base:getClass('helper'):isPrice(childTextdraw:getText()) then
                            private:checkOrCreate(textdraw)
                            return
                        end
                    end
                end
            end
        )
        :add(
            'onDeleteÑlickableTextdraw',
            function (textdraw)
                local products = {}
                for _, product in ipairs(this:getProducts()) do
                    if textdraw:getId() ~= product:getTextdraw():getId() then
                        table.insert(products, product)
                    else
                        product:delete()
                    end
                end
                private:setProducts(products)
            end
        )
        :add(
            'onSendClickTextDraw',
            function (id)
                for _, product in ipairs(this:getProducts()) do
                    if id == product:getTextdraw():getId() then
                        return _base:getClass('eventManager'):trigger('onClickProduct', product)
                    end
                end
            end
        )
        return private
    end

    function private:initThrades()
        _base:getClass('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    local products = {}
                    local delete = {}
                    for _, product in ipairs(this:getProducts()) do
                        if product:isDelete() then
                            table.insert(delete, product)
                            _base:getClass('eventManager'):trigger('onDeleteProduct', product)
                        else
                            table.insert(products, product)
                        end
                    end
                    if #delete > 0 then
                        private:setProducts(products)
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class