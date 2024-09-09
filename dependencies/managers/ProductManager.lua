local class = {}
function class:new(_name)
    local this = {}
    local private = {
        ['name'] = _name,
        ['products'] = {},
        ['lastProduct'] = nil,
    }

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

    function this:createProduct(name, code, price, textdraw)
        if code ~= nil and price ~= nil and textdraw ~= nil then
            local product = _sh.dependencies.product:new(
                name,
                code,
                price,
                textdraw
            )
            private:addProduct(product)
            _sh.eventManager:trigger('onCreateProduct', product)
        end
        return this
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
            if _sh.helper:isPrice(childTextdraw:getText()) then
                params.price = _sh.helper:extractPrice(childTextdraw:getText())
            else
                params.code = _sh.helper:md5(params.code .. childTextdraw:getCode())
            end
        end
        this:createProduct(nil, params.code, params.price, params.textdraw)
    end

    -- INITS

    function private:init()
        if _sh[private.name] ~= nil then
            return _sh[private.name]
        end
        private:initEvents():initThrades()
        return this
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onTextdrawAddChild',
            function (textdraw)
                if _sh.player:isShoping() then
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        if _sh.helper:isPrice(childTextdraw:getText()) then
                            private:checkOrCreate(textdraw)
                            return
                        end
                    end
                end
            end
        )
        _sh.eventManager:add(
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
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (id)
                for _, product in ipairs(this:getProducts()) do
                    if id == product:getTextdraw():getId() then
                        return _sh.eventManager:trigger('onClickProduct', product)
                    end
                end
            end
        )
        return private
    end

    function private:initThrades()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local products = {}
                    local delete = {}
                    for _, product in ipairs(this:getProducts()) do
                        if product:isDelete() then
                            table.insert(delete, product)
                            _sh.eventManager:trigger('onDeleteProduct', product)
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