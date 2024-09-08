local class = {}
function class:new()
    local public = {}
    local private = {
        ['products'] = {},
        ['lastProduct'] = nil,
    }

    -- PRODUCTS

    function public:getProducts()
        return private.products
    end

    function private:setProducts(products)
        private.products = products
        return public
    end

    function private:addProduct(product)
        table.insert(private.products, product)
        private:setLastProduct(product)
        return public
    end

    function private:deleteProduct(_product)
        local products = {}
        for _, product in ipairs(public:getProducts()) do
            if _product:getTextdraw():getId() ~= product:getTextdraw():getId() then
                table.insert(products, product)
            else
                product:delete()
            end
        end
        private:setProducts(products)
        return public
    end

    -- LAST PRODUCT

    function private:getLastProduct()
        return private.lastProduct
    end

    function private:setLastProduct(lastProduct)
        private.lastProduct = lastProduct
        return public
    end

    -- LOGIC

    function private:createProduct(textdraw)
        if private:getLastProduct() ~= nil and private:getLastProduct():getTextdraw():getId() == textdraw:getId() then
            private:deleteProduct(private:getLastProduct())
        end
        local params = {
            ['name'] = textdraw:getCode(),
            ['price'] = nil,
            ['mod'] = 'sell',
            ['textdraw'] = textdraw,
        }
        for _, childTextdraw in ipairs(textdraw:getChilds()) do
            if _sh.helper:isPrice(childTextdraw:getText()) then
                params.price = _sh.helper:extractPrice(childTextdraw:getText())
            else
                params.name = _sh.helper:md5(params.name .. childTextdraw:getCode())
            end
        end
        local product = _sh.dependencies.product:new(
            params.name,
            params.price,
            params.mod,
            params.textdraw
        )
        private:addProduct(product)
        _sh.eventManager:trigger('onCreateProduct', product)
    end

    -- INITS

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onTextdrawAddChild',
            function (textdraw)
                if _sh.player:inShop() then
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        if _sh.helper:isPrice(childTextdraw:getText()) then
                            private:createProduct(textdraw)
                            return
                        end
                    end
                end
            end
        )
        _sh.eventManager:add(
            'onDelete—lickableTextdraw',
            function (textdraw)
                local products = {}
                for _, product in ipairs(public:getProducts()) do
                    if textdraw:getId() ~= product:getTextdraw():getId() then
                        table.insert(products, product)
                    else
                        private:deleteProduct(product)
                    end
                end
                private:setProducts(products)
            end
        )
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (id)
                for _, product in ipairs(public:getProducts()) do
                    if id == product:getTextdraw():getId() then
                        _sh.eventManager:trigger('onClickProduct', product)
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class