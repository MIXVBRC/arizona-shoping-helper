local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['lastShopId'] = nil,
        ['checkTime'] = 60,
        ['minmax'] = _sh.dependencies.minMax:new({
            ['distance'] = {
                ['min'] = 30,
                ['max'] = 200,
            },
            ['time'] = {
                ['min'] = 1,
                ['max'] = 1440,
            },
        }),
        ['configManager'] = _sh.dependencies.configManager:new(_command, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:get('active')
    end

    function private:toggleActive()
        private.configManager:set('active', not private:isActive())
        return public
    end

    -- DISTANCE

    function private:getDistance()
        return private.configManager:get('distance') or private.minmax:getMin('distance')
    end

    function private:setDistance(distance)
        private.configManager:set('distance', private.minmax:get(distance, 'distance'))
        return public
    end

    -- TIME

    function private:getTime()
        return private.configManager:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.configManager:set('time', private.minmax:get(time, 'time'))
        return public
    end

    -- COLOR

    function private:getColor(name)
        return private.configManager:get('colors')[name]
    end

    -- LAST SHOP ID

    function private:getLastShopId()
        return private.lastShopId
    end

    function private:setLastShopId(id)
        private.lastShopId = id
        return public
    end

    -- CHECK TIME

    function private:getCheckTime()
        return private.checkTime
    end

    -- HIDINGS

    function private:getHidings()
        return private.configManager:get('hiding')
    end

    function private:setHidings(hidings)
        private.configManager:set('hiding', hidings)
        return public
    end

    function private:getHiding(name)
        return private:getHidings()[name]
    end

    function private:toggleHiding(name)
        local hidings = private:getHidings()
        hidings[name] = not hidings[name]
        private:setHidings(hidings)
        return public
    end

    -- SHOPS

    function private:getShops()
        return private.configManager:get('shops') or {}
    end

    function private:setShops(shops)
        return private.configManager:set('shops', shops)
    end

    function private:clearShops()
        return private:setShops({})
    end

    function private:getShop(id)
        for _, shop in ipairs(private:getShops()) do
            if id == shop.id then
                return shop
            end
        end
        return nil
    end

    function private:addShop(shop)
        local shops = private:getShops()
        table.insert(shops, shop)
        private:setShops(shops)
        return public
    end

    function private:changeShop(id, data)
        local shops = private:getShops()
        for _, shop in pairs(shops) do
            if id == shop.id then
                for key, value in pairs(data) do
                    if key ~= 'id' then
                        shop[key] = value
                    end
                end
            end
        end
        private:setShops(shops)
        return public
    end

    -- WORK

    function private:work()
        local time = os.time()
        local shops = _sh.shopManager:getShops()
        local renders = private.cache:get('renders')
        if renders == nil then
            renders = {}
            local timeNow = os.time()
            for _, shop in ipairs(shops) do
                local render = {
                    ['text'] = '',
                    ['color'] = private:getColor('while'),
                    ['polygons'] = 4,
                    ['rotation'] = 0,
                    ['x'] = shop:getX(),
                    ['y'] = shop:getY(),
                    ['z'] = shop:getZ() + 0.16,
                }
                local shopTypes = {'player'}
                if _sh.player:getName() == shop:getPlayer() then
                    shopTypes = {'player'}
                    render.color = private:getColor('player')
                    render.polygons = 3
                    render.rotation = 180
                elseif shop:getMod() == _sh.message:get('system_shop_sell') then -- visit_shop_mod_sell
                    shopTypes = {'sell'}
                    render.color = private:getColor('sell')
                elseif shop:getMod() == _sh.message:get('system_shop_buy') then
                    shopTypes = {'buy'}
                    render.color = private:getColor('buy')
                elseif shop:getMod() == _sh.message:get('system_shop_sell_buy') then
                    shopTypes = {'sell','buy'}
                    render.color = private:getColor('sell_buy')
                elseif shop:getMod() == _sh.message:get('system_shop_edit') then
                    shopTypes = {'edit'}
                    render.color = private:getColor('edit')
                elseif shop:getMod() == _sh.message:get('system_shop_empty') then
                    shopTypes = {'empty'}
                    render.color = private:getColor('empty')
                end
                local show = false
                local visitShop = private:getShop(shop:getId())
                if visitShop ~= nil then
                    if time <= visitShop.time and (visitShop.mod == shop:getMod() or visitShop.mod == _sh.message:get('system_shop_edit')) then
                        shopTypes = {'visit'}
                        render.color = private:getColor('visit')
                        if private:getHiding('time') then
                            render.text = math.ceil((visitShop.time - timeNow) / 60) .. ' min'
                        end
                    else
                        private:changeShop(shop:getId(), {
                            ['time'] = 0,
                            ['mod'] = shop:getMod(),
                        })
                    end
                    if visitShop.select then
                        render.color = private:getColor('select')
                        render.polygons = 3
                        render.rotation = 180
                        render.text = visitShop.text
                        show = true
                    end
                end
                if not show then
                    for _, shopType in ipairs(shopTypes) do
                        if private:getHiding(shopType) then
                            show = true
                        end
                    end
                end
                if show then
                    table.insert(renders, render)
                end
            end
            private.cache:add('renders', renders, 1)
        end
        private:render(renders)
    end

    function private:render(renders)
        if #renders > 0 then
            for _, render in ipairs(renders) do
                local distance = _sh.helper:distanceToPlayer3d(render.x, render.y, render.z)
                local alpha = _sh.color:getAlpha(100 - math.floor(distance * 100 / private:getDistance()))
                if isPointOnScreen(render.x, render.y, render.z, 0) and distance < private:getDistance() then
                    local sceenX, sceenY = convert3DCoordsToScreen(render.x, render.y, render.z - 1)
                    _sh.render:pushLine(sceenX, sceenY, sceenX, sceenY - 90, 1, alpha .. private:getColor('stick'))
                    _sh.render:pushPoint(sceenX, sceenY - 100, 20, 20, render.polygons, render.rotation, alpha .. render.color)
                    if render.text ~= nil and render.text ~= '' then
                        _sh.render:pushText(_sh.font:get('Arial', 12, 4), render.text, sceenX + 15, sceenY - 110, alpha .. private:getColor('text'))
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        private:initThreads()
        private:initCommands()
        private:initEvents()
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() and not _sh.player:inShop() and not _sh.player:editProducts() then
                        private:work()
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(1000 * private:getCheckTime())
                    local time = os.time()
                    local flag = false
                    local shops = {}
                    for _, shop in pairs(private:getShops()) do
                        if not shop.select and time < shop.time then
                            table.insert(shops, shop)
                        else
                            flag = true
                        end
                    end
                    if flag then
                        private:setShops(shops)
                    end
                end
            end
        )
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('clear', private.clearShops)
        private.commandManager:add('distance', function (distance)
            private:setDistance(_sh.helper:getNumber(distance))
        end)
        private.commandManager:add('time', function (time)
            time = _sh.helper:getNumber(time)
            local differenceTime = private:getTime() - time
            local shops = private:getShops()
            for _, shop in pairs(shops) do
                if shop.time == nil then
                    shop.time = time
                end
                shop.time = shop.time - differenceTime * 60
            end
            private:setShops(shops)
            private:setTime(time)
        end)
        private.commandManager:add('select', function (text)
            local lastShopId = private:getLastShopId()
            if lastShopId ~= nil then
                local shop = private:getShop(lastShopId)
                if shop ~= nil then
                    local data = {
                        ['select'] = true,
                        ['text'] = text,
                    }
                    if shop.select then
                        data = {
                            ['select'] = false,
                            ['text'] = '',
                        }
                    end
                    private:changeShop(lastShopId, data)
                end
            end
        end)
        for hiding, _ in pairs(private:getHidings()) do
            private.commandManager:add(table.concat({'active', hiding}, '-'), function ()
                private:toggleHiding(hiding)
            end)
        end
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onVisitShop',
            function (shop)
                private:setLastShopId(shop:getId())
                local time = os.time() + ( private:getTime() * 60 )
                if private:getShop(shop:getId()) ~= nil then
                    private:changeShop(
                        shop:getId(),
                        {
                            ['time'] = time,
                            ['mod'] = shop:getMod(),
                        }
                    )
                else
                    private:addShop({
                        ['id'] = shop:getId(),
                        ['time'] = time,
                        ['mod'] = shop:getMod(),
                        ['select'] = false,
                        ['text'] = '',
                    })
                end
            end
        )
    end

    private:init()
    return public
end
return class