local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['lastShopId'] = nil,
        ['checkTime'] = 60,
        ['minmax'] = _base:getInit('minMax', _minmax),
        ['config'] = _base:getInit('configManager', _name, _default),
        ['cache'] = _base:getInit('cache'),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:toggleActive()
        private.config:set('active', not private:isActive())
        return this
    end

    -- DISTANCE

    function private:getDistance()
        return private.config:get('distance') or private.minmax:getMin('distance')
    end

    function private:setDistance(distance)
        private.config:set('distance', private.minmax:get(distance, 'distance'))
        return this
    end

    -- TIME

    function private:getTime()
        return private.config:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.config:set('time', private.minmax:get(time, 'time'))
        return this
    end

    -- COLOR

    function private:getColor(name)
        return private.config:get('colors')[name]
    end

    -- LAST SHOP ID

    function private:getLastShopId()
        return private.lastShopId
    end

    function private:setLastShopId(id)
        private.lastShopId = id
        return this
    end

    -- CHECK TIME

    function private:getCheckTime()
        return private.checkTime
    end

    -- HIDINGS

    function private:getHidings()
        return private.config:get('hiding')
    end

    function private:setHidings(hidings)
        private.config:set('hiding', hidings)
        return this
    end

    function private:getHiding(name)
        for _, hiding in ipairs(private:getHidings()) do
            if name == hiding.name then
                return hiding
            end
        end
        return nil
    end

    function private:toggleHiding(name)
        local hidings = private:getHidings()
        for _, hiding in ipairs(hidings) do
            if name == hiding.name then
                hiding.active = not hiding.active
            end
        end
        private:setHidings(hidings)
        return this
    end

    function private:isHidingActive(name)
        for _, hiding in ipairs(private:getHidings()) do
            if name == hiding.name then
                return hiding.active
            end
        end
        return nil
    end

    -- SHOPS

    function private:getShops()
        return private.config:get('shops') or {}
    end

    function private:setShops(shops)
        return private.config:set('shops', shops)
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
        return this
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
        return this
    end

    -- WORK

    function private:work()
        local time = os.time()
        local shops = _base:get('shopManager'):getShops()
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
                if _base:get('playerManager'):getName() == shop:getPlayer() then
                    shopTypes = {'player'}
                    render.color = private:getColor('player')
                    render.polygons = 3
                    render.rotation = 180
                elseif shop:getMod() == _base:get('message'):get('system_shop_sell') then
                    shopTypes = {'sell'}
                    render.color = private:getColor('sell')
                elseif shop:getMod() == _base:get('message'):get('system_shop_buy') then
                    shopTypes = {'buy'}
                    render.color = private:getColor('buy')
                elseif shop:getMod() == _base:get('message'):get('system_shop_sell_buy') then
                    shopTypes = {'sell','buy'}
                    render.color = private:getColor('sell_buy')
                elseif shop:getMod() == _base:get('message'):get('system_shop_edit') then
                    shopTypes = {'edit'}
                    render.color = private:getColor('edit')
                elseif shop:getMod() == _base:get('message'):get('system_shop_empty') then
                    shopTypes = {'empty'}
                    render.color = private:getColor('empty')
                end
                local show = false
                local visitShop = private:getShop(shop:getId())
                if visitShop ~= nil then
                    if time <= visitShop.time and (visitShop.mod == shop:getMod() or visitShop.mod == _base:get('message'):get('system_shop_edit')) then
                        shopTypes = {'visit'}
                        render.color = private:getColor('visit')
                        if private:isHidingActive('time') then
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
                        if private:isHidingActive(shopType) then
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
                local distance = _base:get('helper'):distanceToPlayer3d(render.x, render.y, render.z)
                local alpha = _base:get('color'):getAlpha(100 - math.floor(distance * 100 / private:getDistance()))
                if isPointOnScreen(render.x, render.y, render.z, 0) and distance < private:getDistance() then
                    local sceenX, sceenY = convert3DCoordsToScreen(render.x, render.y, render.z - 1)
                    _base:get('render'):pushLine(sceenX, sceenY, sceenX, sceenY - 90, 1, alpha .. private:getColor('stick'))
                    _base:get('render'):pushPoint(sceenX, sceenY - 100, 20, 20, render.polygons, render.rotation, alpha .. render.color)
                    if render.text ~= nil and render.text ~= '' then
                        _base:get('render'):pushText(_base:get('font'):get('Arial', 12, 4), render.text, sceenX + 15, sceenY - 110, alpha .. private:getColor('text'))
                    end
                end
            end
        end
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initThreads():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'clear'}, private.clearShops)
        :add({private:getName(), 'distance'}, function (distance)
            private:setDistance(_base:get('helper'):getNumber(distance))
        end)
        :add({private:getName(), 'time'}, function (time)
            time = _base:get('helper'):getNumber(time)
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
        :add({private:getName(), 'select'}, function (text)
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
        for _, hiding in ipairs(private:getHidings()) do
            _base:get('commandManager'):add({private:getName(), 'active', hiding.name}, function ()
                private:toggleHiding(hiding.name)
            end)
        end
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive()
                    and not _base:get('playerManager'):isSAI()
                    and not _base:get('dialogManager'):isOpened()
                    then
                        private:work()
                    end
                end
            end
        )
        :add(
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
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
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
        return private
    end

    return private:init()
end
return class