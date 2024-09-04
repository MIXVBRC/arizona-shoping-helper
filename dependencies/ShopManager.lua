local class = {}
function class:new()
    local public = {}
    local private = {
        ['shops'] = {},
        ['mods'] = {
            [_sh.message:get('sale_mod_sale')] = 'sale',
            [_sh.message:get('sale_mod_buy')] = 'buy',
            [_sh.message:get('sale_mod_sale_en')] = 'sale',
            [_sh.message:get('sale_mod_buy_en')] = 'buy',
        },
        ['centralModelIds'] = {
            3861,
            14211,
            14210,
        },
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function public:getById(id)
        for _, shop in ipairs(private.shops) do
            if shop.id == id then
                return shop
            end
        end
        return nil
    end

    function public:getAll()
        return private.shops
    end

    function public:getNearby()
        local result = nil
        local minDistance = nil
        if private.shops ~= nil then
            for _, shop in ipairs(private.shops) do
                local distance = _sh.helper:distanceToPlayer3d(shop:getX(), shop:getY(), shop:getZ())
                if minDistance == nil or distance < minDistance then
                    minDistance = distance
                    result = shop
                end
            end
        end
        return result
    end

    function private:isCentral(x, y, z)
        local cacheKeyShop = _sh.helper:md5(x..y..z)
        if private.cache:get(cacheKeyShop) == nil then
            local objects = _sh.helper:getObjectsByIds(private.centralModelIds)
            for _, object in ipairs(objects) do
                local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    objectX, objectY, objectZ,
                    x, y, z
                )
                if distance < 3 then
                    private.cache:add(cacheKeyShop, true)
                    return true
                end
            end
        else
            return true
        end
        return false
    end

    function private:initThreads()
        lua_thread.create(function () while true do wait(0)
            private.shops = private.cache:get('shops')
            if private.shops == nil then
                private.shops = {}
                local shops = {}
                local titles = {}
                for _, textId in ipairs(_sh.helper:getTextIds()) do
                    local text, _, x, y, z, _, _, _, _ = sampGet3dTextInfoById(textId)
                    if text == _sh.message:get('message_shop') then
                        table.insert(shops, {
                            ['position'] = {
                                ['x'] = x,
                                ['y'] = y,
                                ['z'] = z,
                            },
                        })
                    elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
                        table.insert(titles, {
                            ['text'] = text,
                            ['position'] = {
                                ['x'] = x,
                                ['y'] = y,
                                ['z'] = z,
                            },
                        })
                    end
                end
                for _, shop in ipairs(shops) do
                    local minDistance = nil
                    for titleIndex, title in ipairs(titles) do
                        local distance = getDistanceBetweenCoords3d(
                            shop.position.x, shop.position.y, shop.position.z,
                            title.position.x, title.position.y, title.position.z
                        )
                        if distance < 3 and (minDistance == nil or distance < minDistance) then
                            minDistance = distance
                            shop.title = title
                            table.remove(titles, titleIndex)
                            break
                        end
                    end
                    if shop.title ~= nil then
                        shop.empty = false
                        shop.player = shop.title.text:match('^(.+)%s{......}.+{......}.+$')
                        shop.mod = shop.title.text:match('^.+{......}(.+){......}.+$')
                    else
                        shop.empty = true
                        shop.player = 'none'
                        shop.mod = _sh.message:get('message_shop_empty')
                    end
                    shop.position = _sh.helper:normalizePosition(shop.position.x, shop.position.y, shop.position.z)
                    shop.central = private:isCentral(shop.position.x, shop.position.y, shop.position.z)
                    table.insert(private.shops, _sh.dependencies.shop:new(
                        shop.position.x,
                        shop.position.y,
                        shop.position.z,
                        shop.player,
                        shop.mod,
                        shop.empty,
                        shop.central
                    ))
                end
                private.cache:add('shops', private.shops, 2)
            end
        end end)
    end

    function _sh.events.onTextDrawSetString(textdrawId, text)
        local mod = private.mods[text]
        if mod ~= nil then
            local shop = public:getNearby()
            if shop ~= nil then
                _sh.customEvents:trigger('onVisitShop', shop, mod, textdrawId)
            end
        end
    end

    private:initThreads()
    return public
end
return class