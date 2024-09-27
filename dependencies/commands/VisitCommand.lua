local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['text3ds'] = {},
        ['lastShopId'] = nil,
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
        ['cache'] = _base:getNew('cache'),
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
        return private
    end

    -- DISTANCE

    function private:getDistance()
        return private.config:get('distance') or private.minmax:getMin('distance')
    end

    function private:setDistance(distance)
        private.config:set('distance', private.minmax:get(distance, 'distance'))
        return private
    end

    -- XRAY

    function private:isXray()
        return private.config:get('xray')
    end

    function private:toggleXray()
        private.config:set('xray', not private:isXray())
        return private
    end

    -- TIME

    function private:getTime()
        return private.config:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.config:set('time', private.minmax:get(time, 'time'))
        return private
    end

    -- COLOR

    function private:getColor(name)
        return private.config:get('colors')[name]
    end

    -- TEXT3DS

    function private:getText3ds()
        return private.text3ds
    end

    function private:setText3ds(text3ds)
        private.text3ds = text3ds
        return private
    end

    function private:getText3d(id)
        for _, value in ipairs(private:getText3ds()) do
            if id == value.id then
                return value.text3d
            end
        end
        return nil
    end

    -- LAST SHOP ID

    function private:getLastShopId()
        return private.lastShopId
    end

    function private:setLastShopId(id)
        private.lastShopId = id
        return private
    end

    -- TYPES

    function private:getTypes()
        return private.config:get('types')
    end

    function private:setTypes(types)
        private.config:set('types', types)
        return private
    end

    function private:getType(name)
        for _, type in ipairs(private:getTypes()) do
            if name == type.name then
                return type
            end
        end
        return nil
    end

    function private:toggleType(name)
        local types = private:getTypes()
        for _, type in ipairs(types) do
            if name == type.name then
                type.active = not type.active
            end
        end
        private:setTypes(types)
        return private
    end

    function private:isTypeActive(name)
        for _, type in ipairs(private:getTypes()) do
            if name == type.name then
                return type.active
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
        return private
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
        return private
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
        :add({private:getName(), 'xray'}, private.toggleXray)
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
            text = text or ''
            local lastShopId = private:getLastShopId()
            if lastShopId ~= nil then
                local shop = private:getShop(lastShopId)
                if shop ~= nil then
                    if text == '' and shop.select then
                        private:changeShop(lastShopId, {
                            ['select'] = false,
                            ['text'] = '',
                        })
                    else
                        private:changeShop(lastShopId, {
                            ['select'] = true,
                            ['text'] = text,
                        })
                    end
                end
            end
        end)
        for _, type in ipairs(private:getTypes()) do
            _base:get('commandManager'):add({private:getName(), 'active', type.name}, function ()
                private:toggleType(type.name)
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
                    and not sampIsScoreboardOpen()
                    then
                        local time = os.time()
                        local text3ds = {}
                        for _, shop in ipairs(_base:get('shopManager'):getShops()) do
                            if shop:getTitle() ~= nil then
                                local distance = _base:get('helper'):distanceToPlayer3d(shop:getX(), shop:getY(), shop:getZ())
                                if distance <= private:getDistance() then
                                    local text3d = private:getText3d(shop:getId())
                                    if text3d == nil then
                                        text3d = _base:getNew('text3d', nil, nil, nil, nil,
                                            shop:getX(),
                                            shop:getY(),
                                            shop:getZ()
                                        )
                                    end
                                    local aplpha = _base:get('color'):getAlpha(100 - math.floor(distance * 100 / private:getDistance()))
                                    text3d:setAlpha(aplpha)
                                    text3d:setXray(private:isXray())
                                    local shopTypes = {'player'}
                                    text3d:setText(shop:getMod())
                                    if _base:get('playerManager'):getName() == shop:getPlayerName() then
                                        shopTypes = {'player'}
                                        text3d:setColor(private:getColor('player'))
                                    elseif shop:getMod() == _base:get('message'):get('system_shop_sell') then
                                        shopTypes = {'sell'}
                                        text3d:setColor(private:getColor('sell'))
                                    elseif shop:getMod() == _base:get('message'):get('system_shop_buy') then
                                        shopTypes = {'buy'}
                                        text3d:setColor(private:getColor('buy'))
                                    elseif shop:getMod() == _base:get('message'):get('system_shop_sell_buy') then
                                        shopTypes = {'sell','buy'}
                                        text3d:setColor(private:getColor('sell_buy'))
                                    elseif shop:getMod() == _base:get('message'):get('system_shop_edit') then
                                        shopTypes = {'edit'}
                                        text3d:setColor(private:getColor('edit'))
                                    end
                                    local show = false
                                    local visitShop = private:getShop(shop:getId())
                                    if visitShop ~= nil then
                                        if time <= visitShop.time and (visitShop.mod == shop:getMod() or visitShop.mod == _base:get('message'):get('system_shop_edit')) then
                                            shopTypes = {'visit'}
                                            text3d:setColor(private:getColor('visit'))
                                            shop:getWindow():getText3d():setDistance(1):update()
                                        elseif visitShop.time > 0 then
                                            private:changeShop(shop:getId(), {
                                                ['time'] = 0,
                                                ['mod'] = shop:getMod(),
                                            })
                                        end
                                        if visitShop.select then
                                            text3d:setColor(private:getColor('select'))
                                            text3d:setText(visitShop.text)
                                            show = true
                                        end
                                    end
                                    if not show then
                                        for _, shopType in ipairs(shopTypes) do
                                            if private:isTypeActive(shopType) then
                                                show = true
                                            end
                                        end
                                    end
                                    if show then
                                        shop:getWindow():getText3d():setDistance(0):update()
                                        text3d:update()
                                        table.insert(text3ds, {
                                            ['id'] = shop:getId(),
                                            ['text3d'] = text3d,
                                        })
                                    end
                                end
                            end
                        end
                        private:setText3ds(text3ds)
                    elseif #private:getText3ds() > 0 then
                        private:setText3ds({})
                    end
                end
            end
        )
        :add(
            nil,
            function ()
                while true do wait(1000 * 60)
                    local time = os.time()
                    local flag = false
                    local shops = {}
                    for _, shop in pairs(private:getShops()) do
                        if (not shop.select or not time - shop.select > 86400) and time < shop.time then
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
            'onEnterShop',
            function ()
                local shop = _base:get('shopManager'):getNearbyWindow()
                if shop ~= nil then
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
            end
        )
        return private
    end

    return private:init()
end
return class