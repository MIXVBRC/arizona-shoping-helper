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

    function this:getShopById(id)
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

    -- NEARBY

    function this:getNearby(player, admining)
        local nearbyShop = nil
        local minDistance = nil
        for _, shop in ipairs(this:getShops()) do
            if not player or shop:getPlayerName() ~= _base:get('playerManager'):getName() then
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
        local windows = {}
        local titles = {}
        local admins = {}
        for id = 0, 2048 do
            if sampIs3dTextDefined(id) then
                local text, _, x, y, z, _, _, _, _ = sampGet3dTextInfoById(id)
                local data = {
                    ['id'] = id,
                    ['x'] = x,
                    ['y'] = y,
                    ['z'] = z,
                }
                if text == _base:get('message'):get('system_shop') then
                    table.insert(windows, data)
                elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
                    table.insert(titles, data)
                elseif text:find('^' .. _base:get('message'):get('system_shop_product_management') .. '$') then
                    table.insert(admins, data)
                end
            end
        end
        local shops = {}
        for _, window in ipairs(windows) do
            local shop = {
                ['window'] = window,
            }
            for indexTitle, title in ipairs(titles) do
                if 3 > getDistanceBetweenCoords3d(window.x, window.y, window.z, title.x, title.y, title.z) then
                    for indexAdmin, admin in ipairs(admins) do
                        if 3 > getDistanceBetweenCoords3d(title.x, title.y, title.z, admin.x, admin.y, admin.z) then
                            shop.admin = admin
                            table.remove(admins, indexAdmin)
                            break
                        end
                    end
                    shop.title = title
                    table.remove(titles, indexTitle)
                    break
                end
            end
            table.insert(shops, shop)
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
                        local newShop = _base:getNew('shop',
                            shop.window.id,
                            (shop.title or {}).id,
                            (shop.admin or {}).id
                        )
                        if newShop ~= nil then
                            local oldShop = this:getShopById(newShop:getId())
                            if oldShop == nil then
                                table.insert(shops, newShop)
                            else
                                table.insert(shops, oldShop)
                            end
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