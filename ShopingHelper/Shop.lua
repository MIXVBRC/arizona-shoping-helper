local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['shop'] = {},
        ['mods'] = {
            [_sh.message:get('sale_mod_buy')] = 1, -- SALE
            [_sh.message:get('sale_mod_sale')] = 2, -- BUY
            [_sh.message:get('sale_mod_buy_en')] = 1, -- SALE
            [_sh.message:get('sale_mod_sale_en')] = 2, -- BUY
        },
        ['cashe'] = _sh.dependencies.cache:new(1),
    }

    function public:getTiketsAndShops()
        local result = private.cache:get('tikets_shops')
        if result == nil then
            result = {}
            for textId = 0, 2048 do
                if sampIs3dTextDefined(textId) then
                    local text, _, posX, posY, posZ, _, _, _, _ = sampGet3dTextInfoById(textId)
                    if text == private.sh.message:get('message_shop') then
                        table.insert(result.tikets, {
                            ['text'] = text,
                            ['position'] = {
                                ['x'] = posX,
                                ['y'] = posY,
                                ['z'] = posZ,
                            },
                        })
                    elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
                        table.insert(result.shops, {
                            ['text'] = text,
                            ['position'] = {
                                ['x'] = posX,
                                ['y'] = posY,
                                ['z'] = posZ,
                            },
                        })
                    end
                end
            end
            private.cache:add('tikets_shops', result)
        end
        return result
    end

    function public:getNearby()
        local nearby = {}
        local result = public:getTiketsAndShops()
        local distance = nil

        for _, tiket in ipairs(result.tikets) do
            local newDistance = getDistanceBetweenCoords3d(
                private.sh.player:getX(), private.sh.player:getY(), private.sh.player:getZ(),
                tiket.position.x, tiket.position.y, tiket.position.z
            )
            if distance == nil or newDistance < distance then
                distance = newDistance
                nearby = {
                    ['position'] = {
                        ['x'] = tiket.position.x,
                        ['y'] = tiket.position.y,
                        ['z'] = tiket.position.z,
                    },
                }
            end
        end

        distance = nil
        local shopInfo = {}
        for _, cacheShop in ipairs(result.shop) do
            local newDistance = getDistanceBetweenCoords3d(
                result.position.x, result.position.y, result.position.z,
                cacheShop.position.x, cacheShop.position.y, cacheShop.position.z
            )
            if newDistance < 3 and (distance == nil or newDistance < distance) then
                distance = newDistance
                shopInfo = cacheShop
            end
        end

        if shopInfo.text ~= nil then
            nearby = {
                ['text'] = shopInfo.text,
                ['player'] = shopInfo.text:match('^(.+)%s{......}.+{......}.+$'),
                ['mod'] = shopInfo.text:match('^.+{......}(.+){......}.+$'),
                ['position'] = shopInfo.position,
            }
        else
            nearby = {
                ['text'] = 'none',
                ['player'] = 'none',
                ['mod'] = private.sh.message:get('message_shop_empty'),
                ['position'] = nearby.position,
            }
        end

        nearby.position = private.sh.helper:normalizePosition(nearby.position.x, nearby.position.y, nearby.position.z)
        nearby.code = private.sh.helper:md5(nearby.player .. nearby.position.x .. nearby.position.y .. nearby.position.z)

        return nearby
    end

    function private.sh.events.onTextDrawSetString(textdrawId, text)
        local mod = private.mods[text]
        if mod ~= nil then
            local nearby = private:getNearby()
            private.shop = {
                ['status'] = true,
                ['code'] = nearby.code,
                ['mod'] = mod,
                ['textdrawId'] = textdrawId,
                ['position'] = nearby.position,
            }
            private.sh.customEvents:trigger('onVisitShop', private.shop)
        end
    end

    return public
end
return class