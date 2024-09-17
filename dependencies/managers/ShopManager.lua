local class = {}
function class:new(_base, _centralModelIds)
    local this = {}
    local private = {
        ['shops'] = {},
        ['mod'] = nil,
        ['mods'] = {
            [_base:get('message'):get('system_textdraw_shop_mod_sale')] = 'sale',
            [_base:get('message'):get('system_textdraw_shop_mod_buy')] = 'buy',
        },
        ['centralModelIds'] = _centralModelIds or {},
        ['cache'] = _base:getNew('cache'),
    }

    -- SHOPS

    function this:getShops()
        return private.shops or {}
    end

    function private:setShops(shops)
        private.shops = shops or {}
        return private
    end

    function private:getShopById(id)
        for _, shop in ipairs(this:getShops()) do
            if id == shop:getId() then
                return shop
            end
        end
        return nil
    end

    function private:addShop(shop)
        table.insert(private.shops, shop)
        return private
    end

    -- MOD

    function this:getMod()
        return private.mod
    end

    function private:setMod(mod)
        private.mod = mod
        return private
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

    function this:getNearby(player, admining)
        local nearbyShop = nil
        local minDistance = nil
        for _, shop in ipairs(this:getShops()) do
            if not player or shop:getPlayer() ~= _base:get('playerManager'):getName() then
                local x, y, z = shop:getX(), shop:getY(), shop:getZ()
                if admining and shop:getAdmin() ~= nil then
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

    -- FIND SHOPS

    function private:findShops()
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
                table.insert(titles, _base:getNew('shopTitle',
                    text,
                    x,
                    y,
                    z
                ))
            elseif text:find('^' .. _base:get('message'):get('system_shop_product_management') .. '$') then
                table.insert(admins, _base:getNew('shopAdmin',
                    text,
                    x,
                    y,
                    z
                ))
            end
        end
        for _, shop in ipairs(shops) do
            for _, title in ipairs(titles) do
                if 3 > getDistanceBetweenCoords3d(shop.x, shop.y, shop.z, title:getX(), title:getY(), title:getZ()) then
                    shop.title = title
                    break
                end
            end
            if shop.title ~= nil then
                for _, admin in ipairs(admins) do
                    if 3 > getDistanceBetweenCoords3d(shop.title:getX(), shop.title:getY(), shop.title:getZ(), admin:getX(), admin:getY(), admin:getZ()) then
                        shop.admin = admin
                        break
                    end
                end
            end
        end
        return shops
    end

    -- INITS

    function private:init()
        private:initThreads():initEvents()
        return this
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(1000)
                    local shops = {}
                    for _, shop in ipairs(private:findShops()) do
                        local position = _base:get('helper'):normalizePosition(shop.x, shop.y, shop.z)
                        local playerName = 'none'
                        if shop.title ~= nil then
                            playerName = shop.title:getPlayer()
                        end
                        local id = _base:get('helper'):md5(playerName..position.x..position.y..position.z)
                        local oldShop = private:getShopById(id)
                        if oldShop == nil then
                            table.insert(shops,
                                _base:getNew('shop',
                                    id,
                                    position.x,
                                    position.y,
                                    position.z,
                                    shop.title,
                                    shop.admin
                                )
                            )
                        else
                            table.insert(shops, oldShop)
                        end
                    end
                    private:setShops(shops)
                    collectgarbage()
                end
            end
        )
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onAfterChangeTextdraw',
            function (textdraw)
                if textdraw:getText() ~= '' then
                    local mod = private:getModByName(_base:get('helper'):textDecode(textdraw:getText()))
                    if mod ~= nil then
                        private:setMod(mod)
                        _base:get('eventManager'):trigger('onInitShopModButton', mod, textdraw:getParent())
                            _base:get('threadManager')
                            :add(
                                nil,
                                function ()
                                    while sampTextdrawIsExists(textdraw:getId()) do wait(0) end
                                    private:setMod(nil)
                                end
                            )
                    end
                end
            end
        )
        :add(
            'onSendClickTextDraw',
            function (id)
                for _, textdraw in ipairs(_base:get('textdrawManager'):getTextdraws()) do
                    if id == textdraw:getId() then
                        local mod = private:getModByName(_base:get('helper'):textDecode(textdraw:getText()))
                        if mod ~= nil then
                            _base:get('eventManager'):trigger('onClickShopModButton', textdraw)
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class