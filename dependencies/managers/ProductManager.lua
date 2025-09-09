local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['products'] = {},
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
        return this
    end

    -- CREATE PRODUCT

    function this:createProduct(name, code, price, textdraw)
        local product = nil
        if code ~= nil and price ~= nil and textdraw ~= nil then
            product = _base:getNew('product',
                name,
                code,
                price,
                textdraw
            )
            private:addProduct(product)
            _base:get('eventManager'):trigger('onCreateProduct', product)
        end
        return product
    end

    -- INITS

    function private:init()
        private:initEvents():initThrades()
        return this
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onTextdrawAddChild',
            function (textdraw)
                if _base:get('playerManager'):isShoping() then
                    local price = nil
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        if _base:get('helper'):isPrice(childTextdraw:getText()) then
                            price = _base:get('helper'):extractPrice(childTextdraw:getText())
                            break
                        end
                    end
                    if price ~= nil then
                        if #this:getProducts() > 0 then
                            for _, product in ipairs(this:getProducts()) do
                                if textdraw:getId() == product:getTextdraw():getId() then
                                    product:delete()
                                end
                            end
                        end
                        local code = textdraw:getCode()
                        for _, childTextdraw in ipairs(textdraw:getChilds()) do
                            if not _base:get('helper'):isPrice(childTextdraw:getText()) then
                                code = _base:get('helper'):md5(code .. childTextdraw:getCode())
                            end
                        end
                        this:createProduct(nil, code, price, textdraw)
                    end
                end
            end
        )
        :add(
            'onDeleteClickableTextdraw',
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
                        return _base:get('eventManager'):trigger('onClickProduct', product)
                    end
                end
                for _, textdraw in ipairs(_base:get('textdrawManager'):getTextdraws()) do
                    if id == textdraw:getId() then
                        return _base:get('eventManager'):trigger('onClickNotProduct', textdraw)
                    end
                end
            end
        )
        return private
    end

    function private:initThrades()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    local products = {}
                    local delete = {}
                    for _, product in ipairs(this:getProducts()) do
                        if product:isDelete() or not sampTextdrawIsExists(product:getTextdraw():getId()) then
                            table.insert(delete, product)
                            _base:get('eventManager'):trigger('onDeleteProduct', product)
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