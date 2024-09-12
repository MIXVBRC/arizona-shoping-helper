local class = {}
function class:new(_base, _centralModelIds)
    local this = {}
    local private = {
        ['shops'] = {},
        ['mod'] = 'sell',
        ['mods'] = {
            [_base:get('message'):get('system_textdraw_shop_mod_sale')] = 'sale',
            [_base:get('message'):get('system_textdraw_shop_mod_buy')] = 'buy',
        },
        ['centralModelIds'] = _centralModelIds or {},
        ['cache'] = _base:getInit('cache'),
    }

    -- SHOPS

    function this:getShops()
        return private.shops or {}
    end

    function private:setShops(shops)
        private.shops = shops or {}
        return this
    end

    function private:addShop(shop)
        table.insert(private.shops, shop)
        return this
    end

    -- MOD

    function this:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return this
    end

    -- MODS

    function private:getModByName(name)
        return private.mods[name]
    end

    -- CENTRAL MODEL IDS

    function this:getCentralModelIds()
        return private.centralModelIds
    end

    -- LOGIC

    function this:getNearby(player)
        local nearbyShop = nil
        local minDistance = nil
        for _, shop in ipairs(this:getShops()) do
            if not player or shop:getPlayer() ~= _base:get('playerManager'):getName() then
                local x, y, z = shop:getX(), shop:getY(), shop:getZ()
                if shop:getAdmin() ~= nil then
                    x, y, z = shop:getAdmin():getX(), shop:getAdmin():getY(), shop:getAdmin():getZ()
                end
                local distance = _base:get('helper'):distanceToPlayer3d(x, y, z)
                if minDistance == nil or distance < minDistance then
                    minDistance = distance
                    nearbyShop = shop
                end
            end
        end
        return nearbyShop, minDistance
    end

    -- INITS

    function private:init()
        private:initThreads()
        private:initEvents()
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private.cache:get('shops') == nil then
                        private:setShops({})
                        local shops = {}
                        local titles = {}
                        local admins = {}
                        for _, textId in ipairs(_base:get('helper'):getTextIds()) do
                            local text, _, x, y, z, _, _, _, _ = sampGet3dTextInfoById(textId)
                            if text == _base:get('message'):get('system_shop') then
                                table.insert(shops, {
                                    ['x'] = x,
                                    ['y'] = y,
                                    ['z'] = z,
                                })
                            elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
                                table.insert(titles, _base:getInit('shopTitle',
                                    text,
                                    x,
                                    y,
                                    z
                                ))
                            elseif text:find('^' .. _base:get('message'):get('system_shop_product_management') .. '$') then
                                table.insert(admins, _base:getInit('shopAdmin',
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
                            private:addShop(_base:getInit('shop',
                                shop.x,
                                shop.y,
                                shop.z,
                                title,
                                admin
                            ))
                        end
                        private.cache:add('shops', this:getShops(), 1)
                    end
                end
            end
        )
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onAfterChangeTextdraw',
            function (textdraw)
                if textdraw:getText() ~= '' then
                    local cacheKey = 'text_'..textdraw:getText()
                    local text = private.cache:get(cacheKey)
                    if text == nil then
                        text = _base:get('helper'):textDecode(textdraw:getText())
                        private.cache:add(cacheKey, text)
                    end
                    local mod = private:getModByName(text)
                    if mod ~= nil then
                        private:setMod(mod)
                        local shop = this:getNearby()
                        if shop ~= nil then
                            _base:get('eventManager'):trigger('onVisitShop', shop, mod, textdraw)
                        end
                    end
                end
            end
        )
    end

    private:init()
    return this
end
return class