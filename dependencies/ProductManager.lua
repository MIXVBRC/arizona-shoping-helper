local class = {}
function class:new()
    local public = {}
    local private = {
        ['products'] = {},
        ['linkIds'] = {},
    }

    function private:getProducts()
        return private.products
    end

    function private:setProducts(products)
        private:setLinkIds({})
        for _, product in ipairs(products) do
            private:addLinkId(product)
        end
        private.products = products
        return public
    end

    function private:addProduct(product)
        private:addLinkId(product)
        table.insert(private.products, product)
        return public
    end

    function private:getLinkId(texsdrawId)
        return private.linkIds[texsdrawId]
    end

    function private:addLinkId(product)
        private.linkIds[product:getTextdraw():getId()] = product
        return public
    end

    function private:setLinkIds(linkIds)
        private.linkIds = linkIds
        return public
    end

    function private:init()
        private:initThreads()
    end

    function private:initThreads()
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do wait(0)
        --             if _sh.player:inShop() then
        --                 local textdraws = _sh.textdrawManager:getTextdraws()
        --                 for _, textdraw in ipairs(textdraws) do
        --                     if sampTextdrawIsExists(textdraw:getId()) and private:getLinkId(textdraw:getId()) == nil then
        --                         for _, childTextdraw in ipairs(textdraw:getChilds()) do
        --                             if _sh.helper:isPrice(childTextdraw:getText()) then
        --                                 private:addProduct(_sh.dependencies.product:new(
        --                                     nil,
        --                                     textdraw:getCode(),
        --                                     _sh.helper:extractPrice(childTextdraw:getText()),
        --                                     'sell',
        --                                     textdraw
        --                                 ))
        --                                 break
        --                             end
        --                         end
        --                     end
        --                 end
        --             end
        --         end
        --     end
        -- )
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do wait(0)
        --             local flag = false
        --             local exists = {}
        --             local products = private:getProducts()
        --             for _, product in ipairs(products) do
        --                 if sampTextdrawIsExists(product:getTextdraw():getId()) and product:getTextdraw():isSelectable() then
        --                     table.insert(exists, product)
        --                 else
        --                     flag = true
        --                 end
        --             end
        --             if flag then
        --                 private:setProducts(exists)
        --             end
        --         end
        --     end
        -- )
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do
        --             for _, product in ipairs(private:getProducts()) do
        --                 product:scan() wait(1000)
        --             end
        --         end
        --     end
        -- )
    end

    private:init()
    return public
end
return class