local class = {}
function class:new()
    local public = {}
    local private = {
        ['products'] = {},
    }

    -- PRODUCTS

    function private:getProducts()
        return private.products
    end

    function private:setProducts(products)
        private.products = products
        return public
    end

    function private:addProduct(product)
        table.insert(private.products, product)
        return public
    end

    -- INITS

    function private:init()
        private:initThreads()
        private:initEvents()
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    for _, product in ipairs(private:getProducts()) do
                        if not product:isScanned() then
                            product:scan()
                            _sh.chat:push(product:getName())
                            wait(500)
                        end
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if not _sh.dialogManager:isOpened() then
                        for _, product in ipairs(private:getProducts()) do
                            local color = 'ffffff'
                            local scale = 1
                            if product:isScanned() then
                                color = '00ff00'
                                scale = 5
                            end
                            renderDrawBoxWithBorder(
                                product:getTextdraw():getX(),
                                product:getTextdraw():getY(),
                                product:getTextdraw():getWidth(),
                                product:getTextdraw():getHeight(),
                                '0x00ffffff',
                                scale,
                                '0xff' .. color
                            )
                        end
                    end
                end
            end
        )
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onTextdrawAddChild',
            function (textdraw)
                if _sh.player:inShop() then
                    for _, childTextdraw in ipairs(textdraw:getChilds()) do
                        if _sh.helper:isPrice(childTextdraw:getText()) then
                            private:addProduct(_sh.dependencies.product:new(
                                nil,
                                textdraw:getCode(),
                                _sh.helper:extractPrice(childTextdraw:getText()),
                                'sell',
                                textdraw
                            ))
                            break
                        end
                    end
                end
            end
        )
        _sh.eventManager:add(
            'onDelete—lickableTextdraw',
            function (textdraw)
                local products = {}
                for _, product in ipairs(private:getProducts()) do
                    if textdraw:getId() ~= product:getTextdraw():getId() then
                        table.insert(products, product)
                    end
                end
                private:setProducts(products)
            end
        )
    end

    private:init()
    return public
end
return class