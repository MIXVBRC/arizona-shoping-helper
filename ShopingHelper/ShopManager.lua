local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['shops'] = {},
        ['visit'] = nil,
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
        return private.shops[id]
    end

    function public:getAll()
        return private.shops
    end

    function public:getVisit()
        return private.shops[private.visit]
    end

    function private:setVisit(id)
        private.visit = id
        return public
    end

    function public:getNearby()
        local result = nil
        local minDistance = nil
        if private.shops ~= nil then
            for _, shop in pairs(private.shops) do
                local distance = getDistanceBetweenCoords3d(
                    shop.position.x, shop.position.y, shop.position.z,
                    private.sh.player:getX(), private.sh.player:getY(), private.sh.player:getZ()
                )
                if minDistance == nil or distance < minDistance then
                    minDistance = distance
                    result = shop
                end
            end
        end
        return result
    end

    function private:isCentral(x, y, z)
        local cacheKeyShop = private.sh.json:encode({x, y, z})
        if private.cache:get(cacheKeyShop) == nil then
            local cacheKeyObjects = 'objects_' .. private.sh.json:encode(private.centralModelIds)
            local objects = private.cache:get(cacheKeyObjects)
            if objects == nil then
                objects = private.sh.helper:getObjectsByIds(private.centralModelIds)
                private.cache:add(cacheKeyObjects, objects, 3)
            end
            for _, object in ipairs(objects) do
                local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    objectX, objectY, objectZ,
                    x, y, z
                )
                if distance < 2 then
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
                for _, textId in ipairs(private.sh.helper:getTextIds()) do
                    local text, _, x, y, z, _, _, _, _ = sampGet3dTextInfoById(textId)
                    if text == private.sh.message:get('message_shop') then
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
                        if distance < 5 and minDistance == nil or distance < minDistance then
                            minDistance = distance
                            shop.title = title
                            table.remove(titles, titleIndex)
                        end
                    end
                    if shop.title.text ~= nil then
                        shop.empty = false
                        shop.player = shop.title.text:match('^(.+)%s{......}.+{......}.+$')
                        shop.mod = shop.title.text:match('^.+{......}(.+){......}.+$')
                    else
                        shop.empty = true
                        shop.player = 'none'
                        shop.mod = private.sh.message:get('message_shop_empty')
                    end
                    shop.position = private.sh.helper:normalizePosition(shop.position.x, shop.position.y, shop.position.z)
                    shop.central = private:isCentral(shop.position.x, shop.position.y, shop.position.z)
                    shop.id = private.sh.helper:md5(shop.player .. shop.position.x .. shop.position.y .. shop.position.z)
                    private.shops[shop.id] = private.sh.dependencies.shop:new(
                        shop.id,
                        shop.position,
                        shop.player,
                        shop.mod,
                        shop.empty,
                        shop.central
                    )
                end
                private.cache:add('shops', private.shops, 1)
            end
        end end)
    end

    function private.sh.events.onTextDrawSetString(textdrawId, text)
        local mod = private.mods[text]
        if mod ~= nil then
            local shop = private:getNearby()
            private:setVisit(shop.id)
            private.sh.customEvents:trigger('onVisitShop', shop, mod, textdrawId)
        end
    end

    private:initThreads()
    return public
end
return class