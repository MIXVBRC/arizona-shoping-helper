local class = {}
function class:new(_centralModelIds)
    local public = {}
    local private = {
        ['shops'] = {},
        ['mod'] = 'sell',
        ['mods'] = {
            [_sh.message:get('system_mod_sale')] = 'sale',
            [_sh.message:get('system_mod_buy')] = 'buy',
        },
        ['centralModelIds'] = _centralModelIds or {},
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- SHOPS

    function public:getShops()
        return private.shops or {}
    end

    function private:setShops(shops)
        private.shops = shops or {}
        return public
    end

    function private:addShop(shop)
        table.insert(private.shops, shop)
        return public
    end

    -- MOD

    function public:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return public
    end

    -- MODS

    function private:getModByName(name)
        return private.mods[name]
    end

    -- CENTRAL MODEL IDS

    function public:getCentralModelIds()
        return private.centralModelIds
    end

    -- LOGIC

    function public:getNearby()
        local nearbyShop = nil
        local minDistance = nil
        for _, shop in ipairs(public:getShops()) do
            local x, y, z = shop:getX(), shop:getY(), shop:getZ()
            if shop:getAdmin() ~= nil then
                x, y, z = shop:getAdmin():getX(), shop:getAdmin():getY(), shop:getAdmin():getZ()
            end
            local distance = _sh.helper:distanceToPlayer3d(x, y, z)
            if minDistance == nil or distance < minDistance then
                minDistance = distance
                nearbyShop = shop
            end
        end
        return nearbyShop
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
                    if private.cache:get('shops') == nil then
                        private:setShops({})
                        local shops = {}
                        local titles = {}
                        local admins = {}
                        for _, textId in ipairs(_sh.helper:getTextIds()) do
                            local text, _, x, y, z, _, _, _, _ = sampGet3dTextInfoById(textId)
                            if text == _sh.message:get('system_shop') then
                                table.insert(shops, {
                                    ['x'] = x,
                                    ['y'] = y,
                                    ['z'] = z,
                                })
                            elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
                                table.insert(titles, _sh.dependencies.shopTitle:new(
                                    text,
                                    x,
                                    y,
                                    z
                                ))
                            elseif text:find('^' .. _sh.message:get('system_product_management') .. '$') then
                                table.insert(admins, _sh.dependencies.shopAdmin:new(
                                    text,
                                    x,
                                    y,
                                    z
                                ))
                            end
                        end
                        for _, shop in ipairs(shops) do
                            local title = nil
                            local admin = nil
                            for _, _title in ipairs(titles) do
                                if 3 > getDistanceBetweenCoords3d(shop.x, shop.y, shop.z, _title:getX(), _title:getY(), _title:getZ()) then
                                    title = _title
                                    break
                                end
                            end
                            if title ~= nil then
                                for _, _admin in ipairs(admins) do
                                    if 3 > getDistanceBetweenCoords3d(title:getX(), title:getY(), title:getZ(), _admin:getX(), _admin:getY(), _admin:getZ()) then
                                        admin = _admin
                                        break
                                    end
                                end
                            end
                            private:addShop(_sh.dependencies.shop:new(
                                shop.x,
                                shop.y,
                                shop.z,
                                title,
                                admin
                            ))
                        end
                        private.cache:add('shops', public:getShops(), 1)
                    end
                end
            end
        )
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onAfterChangeTextdraw',
            function (textdraw)
                if textdraw:getText() ~= '' then
                    local cacheKey = 'text_'..textdraw:getText()
                    local text = private.cache:get(cacheKey)
                    if text == nil then
                        text = _sh.helper:textDecode(textdraw:getText())
                        private.cache:add(cacheKey, text)
                    end
                    local mod = private:getModByName(text)
                    if mod ~= nil then
                        private:setMod(mod)
                        local shop = public:getNearby()
                        if shop ~= nil then
                            _sh.eventManager:trigger('onVisitShop', shop, mod, textdraw)
                        end
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class