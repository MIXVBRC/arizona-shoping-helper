local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['name'] = 'visit',
        ['colors'] = {
            ['white'] = 'ffffff',
            ['black'] = 'ffffff',
            ['player'] = 'e06936',
            ['sell'] = '36e03c',
            ['buy'] = '3647e0',
            ['sell_buy'] = '36e0e0',
            ['edit'] = 'd2e036',
            ['visit'] = 'cc36e0',
            ['empty'] = 'cc36e0',
        },
        ['cache'] = _sh.dependencies.cache:new(1),
    }

    function private:getName()
        return private.name
    end

    function private:getColor(name)
        return private.colors[name]
    end

    function private:setOption(name, value)
        private.sh.config:set(private:getName(), name, value)
    end

    function private:getOption(name)
        return private.sh.config:get(private:getName(), name)
    end

    function private:isActive()
        return private:getOption('active')
    end

    function public:toggleActive()
        private:setOption('active', not private:isActive())
        return public
    end

    function private:isEmpty()
        return private:getOption('empty')
    end

    function public:toggleEmpty()
        private:setOption('empty', not private:isEmpty())
        return public
    end

    function private:isHiding()
        return private:getOption('hiding')
    end

    function public:toggleHiding()
        private:setOption('hiding', not public:isHiding())
        return public
    end

    function private:getDistance()
        return private:getOption('distance')
    end

    function public:setDistance(distance)
        private:setOption('distance', distance)
        return public
    end

    function private:getTime()
        return private:getOption('time')
    end

    function public:setTime(time)
        private:setOption('time', time)
        return public
    end

    function private:getVisited()
        return private:getOption('visited')
    end

    function private:setVisited(visited)
        return private:setOption('visited', visited)
    end

    function private:getVisitByCode(code)
        return private:getVisited()[code]
    end

    function private:addVisit(code, data)
        local visited = private:getVisited()
        visited[code] = data
        private:setOption('visited', visited)
        return public
    end

    function private:changeVisit(code, data)
        local visit = private:getVisitByCode(code)
        for key, value in pairs(data) do
            visit[code][key] = value
        end
        private:setOption('visited', visit)
        return public
    end

    function private:initThreads()

        lua_thread.create(function () while true do wait(5000)
            local visited = private:getVisited()
            if visited ~= nil and #visited > 0 then
                local time = os.time()
                local newVisited = {}
                for code, shop in pairs(visited) do
                    if (time - shop.date) < 60 * 60 * 24 then
                        newVisited[code] = shop
                    end
                end
                private:setVisited(newVisited)
            end
        end end)

        lua_thread.create(function () while true do wait(0)
            if private:isActive() then
                private:work()
            end
        end end)

    end

    -- function private:getTiketsAndShops()
    --     local result = private.cache:get('tikets_shops')
    --     if result == nil then
    --         for textId = 0, 2048 do
    --             if sampIs3dTextDefined(textId) then
    --                 local text, _, posX, posY, posZ, _, _, _, _ = sampGet3dTextInfoById(textId)
    --                 if text == private.sh.message:get('message_shop') then
    --                     table.insert(result.tikets, {
    --                         ['text'] = text,
    --                         ['position'] = {
    --                             ['x'] = posX,
    --                             ['y'] = posY,
    --                             ['z'] = posZ,
    --                         },
    --                     })
    --                 elseif text:find('^%a+_%a+%s{......}.+{......}.+$') then
    --                     table.insert(result.shops, {
    --                         ['text'] = text,
    --                         ['position'] = {
    --                             ['x'] = posX,
    --                             ['y'] = posY,
    --                             ['z'] = posZ,
    --                         },
    --                     })
    --                 end
    --             end
    --         end
    --         private.cache:add('tikets_shops', result)
    --     end
    --     return result
    -- end

    -- function private:getNearby()
    --     local nearby = {}
    --     local result = private:getTiketsAndShops()
    --     local distance = nil
    --     local playerX, playerY, playerZ = getCharCoordinates(playerPed)

    --     for _, tiket in ipairs(result.tikets) do
    --         local newDistance = getDistanceBetweenCoords3d(
    --             playerX, playerY, playerZ,
    --             tiket.position.x, tiket.position.y, tiket.position.z
    --         )
    --         if distance == nil or newDistance < distance then
    --             distance = newDistance
    --             nearby = {
    --                 ['position'] = {
    --                     ['x'] = tiket.position.x,
    --                     ['y'] = tiket.position.y,
    --                     ['z'] = tiket.position.z,
    --                 },
    --             }
    --         end
    --     end

    --     distance = nil
    --     local shopInfo = {}
    --     for _, cacheShop in ipairs(result.shop) do
    --         local newDistance = getDistanceBetweenCoords3d(
    --             result.position.x, result.position.y, result.position.z,
    --             cacheShop.position.x, cacheShop.position.y, cacheShop.position.z
    --         )
    --         if newDistance < 3 and (distance == nil or newDistance < distance) then
    --             distance = newDistance
    --             shopInfo = cacheShop
    --         end
    --     end

    --     if shopInfo.text ~= nil then
    --         nearby = {
    --             ['text'] = shopInfo.text,
    --             ['player'] = shopInfo.text:match('^(.+)%s{......}.+{......}.+$'),
    --             ['mod'] = shopInfo.text:match('^.+{......}(.+){......}.+$'),
    --             ['position'] = shopInfo.position,
    --         }
    --     else
    --         nearby = {
    --             ['text'] = 'none',
    --             ['player'] = 'none',
    --             ['mod'] = private.sh.message:get('message_shop_empty'),
    --             ['position'] = nearby.position,
    --         }
    --     end

    --     nearby.position = private.sh.helper:normalizePosition(nearby.position.x, nearby.position.y, nearby.position.z)
    --     nearby.code = private.sh.helper:md5(nearby.player .. nearby.position.x .. nearby.position.y .. nearby.position.z)

    --     return nearby
    -- end

    function private:work()
        local time = os.time()
        local data = private.sh.shop:getTiketsAndShops()

        for _, tiket in ipairs(data.tikets) do

            local text = ''
            local color = private:getColor('while')
            local polygons = 4
            local rotation = 0
            local distance = getDistanceBetweenCoords3d(
                private.sh.player:getX(), private.sh.player:getY(), private.sh.player:getZ(),
                tiket.position.x, tiket.position.y, tiket.position.z
            )
            local x, y = convert3DCoordsToScreen(tiket.position.x, tiket.position.y, tiket.position.z - 1)
            local alpha = '0x' .. private.sh.color:getByNum(1 - math.floor(distance * 100 / private.distance) / 100)

            local shopInfo = {}
            local shopDistance = nil

            for _, shop in ipairs(data.shops) do
                local newDistance = getDistanceBetweenCoords3d(
                    tiket.position.x, tiket.position.y, tiket.position.z,
                    shop.position.x, shop.position.y, shop.position.z
                )
                if newDistance < 3 and (shopDistance == nil or newDistance < shopDistance) then
                    shopDistance = newDistance
                    shopInfo = shop
                end
            end

            if shopInfo.text ~= nil then
                shopInfo = {
                    ['text'] = shopInfo.text,
                    ['player'] = shopInfo.text:match('^(.+)%s{......}.+{......}.+$'),
                    ['mod'] = shopInfo.text:match('^.+{......}(.+){......}.+$'),
                    ['position'] = {
                        ['x'] = shopInfo.position.x,
                        ['y'] = shopInfo.position.y,
                        ['z'] = shopInfo.position.z,
                    },
                }
            else
                shopInfo = {
                    ['text'] = 'none',
                    ['player'] = 'none',
                    ['mod'] = private.sh.message:get('message_shop_empty'),
                    ['position'] = {
                        ['x'] = tiket.position.x,
                        ['y'] = tiket.position.y,
                        ['z'] = tiket.position.z,
                    },
                }
            end

            if private.sh.player.name == shopInfo.player then
                color = private:getColor('player')
                polygons = 3
                rotation = 180
            else
                if shopInfo.mod == private.sh.message:get('message_shop_sell') then
                    color = private:getColor('sell')
                elseif shopInfo.mod == private.sh.message:get('message_shop_buy') then
                    color = private:getColor('buy')
                elseif shopInfo.mod == private.sh.message:get('message_shop_sell_buy') then
                    color = private:getColor('sell_buy')
                elseif shopInfo.mod == private.sh.message:get('message_shop_edit') then
                    color = private:getColor('edit')
                elseif shopInfo.mod == private.sh.message:get('message_shop_empty') then
                    if private:isEmpty() then
                        color = private:getColor('empty')
                    else
                        goto continue
                    end
                end
            end

            shopInfo.position = private.sh.helper:normalizePosition(shopInfo.position.x, shopInfo.position.y, shopInfo.position.z)
            local shopCode = private.sh.helper:md5(shopInfo.player .. shopInfo.position.x .. shopInfo.position.y .. shopInfo.position.z)
            local visitShop = private:getVisitByCode(shopCode)

            if visitShop ~= nil and visitShop.time ~= nil then

                if time <= visitShop.time and (visitShop.mod == shopInfo.mod or visitShop.mod == private.sh.message:get('message_shop_edit')) then
                    color = private:getColor('visit')
                    if private:isHiding() and not visitShop.select then
                        goto continue
                    end
                else
                    visitShop.time = nil
                    private:changeVisit(shopCode, {
                        ['time'] = visitShop.time,
                        ['mod'] = shopInfo.mod,
                    })
                end

                if visitShop.select then
                    color = private:getColor('while')
                    polygons = 3
                    rotation = 180
                end

                if visitShop.select then
                    text = visitShop.text
                elseif visitShop.time ~= nil then
                    text = math.ceil((visitShop.time - time) / 60) .. ' min'
                end

            end

            if isPointOnScreen(tiket.position.x, tiket.position.y, tiket.position.z, 0) and distance < private:getDistance() and not shopInfo.status then
                renderDrawLine(x, y, x, y - 90, 1, alpha .. 'ffffff')
                renderDrawPolygon(x, y - 100, 20, 20, polygons, rotation, alpha .. color)
                renderFontDrawText(fonts.time, text, x + 15, y - 100, alpha .. 'ffffff', alpha .. '000000')
            end

            ::continue::

        end
    end

    function private.sh.events.onTextDrawSetString(textdrawId, text)
        local shop = private:getNearbyShop()

        local time = os.time() + 60 * private:getTime()

        if private:getVisitByCode(shop.code) ~= nil then
            private:changeVisit(shop.code, {
                ['time'] = time,
            })
        else
            private:addVisit({
                ['code'] = shop.code,
                ['time'] = time,
                ['select'] = false,
                ['mod'] = shop.mod,
                ['text'] = '',
                ['date'] = os.time()
            })
        end
    end

    private:initThreads()
    return public
end
return class