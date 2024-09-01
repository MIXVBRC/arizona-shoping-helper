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

    function private:isCentral(shop)
        local cacheKey = private.sh.json:encode(shop.position)
        if private.cache:get(cacheKey) == nil then
            local objects = private.sh.helper:getObjectsByIds(private.centralModelIds, 3)
            for _, object in ipairs(objects) do
                local _, x, y, z = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    shop.position.x, shop.position.y, shop.position.z,
                    x, y, z
                )
                if distance < 2 then
                    private.cache:add(cacheKey, shop)
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
                for textId = 0, 2048 do
                    if sampIs3dTextDefined(textId) then
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
                end
                for _, shop in ipairs(shops) do
                    local minDistance = nil
                    for _, title in ipairs(titles) do
                        local distance = getDistanceBetweenCoords3d(
                            shop.position.x, shop.position.y, shop.position.z,
                            title.position.x, title.position.y, title.position.z
                        )
                        if distance < 5 and minDistance == nil or distance < minDistance then
                            minDistance = distance
                            shop.title = title
                        end
                    end
                    shop.distance = getDistanceBetweenCoords3d(
                        shop.position.x, shop.position.y, shop.position.z,
                        private.sh.player:getX(), private.sh.player:getY(), private.sh.player:getZ()
                    )
                    if shop.title.text ~= nil then
                        shop.empty = false
                        shop.player = shop.title.text:match('^(.+)%s{......}.+{......}.+$')
                        shop.mod = shop.title.text:match('^.+{......}(.+){......}.+$')
                    else
                        shop.empty = true
                        shop.player = nil
                        shop.mod = private.sh.message:get('message_shop_empty')
                    end
                    shop.position = private.sh.helper:normalizePosition(shop.position.x, shop.position.y, shop.position.z)
                    shop.central = private:isCentral(shop)
                    shop.id = private.sh.helper:md5(shop.player .. shop.position.x .. shop.position.y .. shop.position.z)
                    private.shops[shop.id] = shop
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
            private.sh.customEvents:trigger('onVisitShop', textdrawId, mod, shop)
        end
    end

    private:initThreads()
    return public
end
return class