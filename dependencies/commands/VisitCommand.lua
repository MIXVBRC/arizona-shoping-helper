local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['lastShopId'] = nil,
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
        ['cache'] = _base:getNew('cache'),
        ['text3dManager'] = _base:getNew('text3dManager'),
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

    -- LAST SHOP ID

    function private:getLastShopId()
        return private.lastShopId
    end

    function private:setLastShopId(id)
        private.lastShopId = id
        return private
    end

    -- HIDINGS

    function private:getHidings()
        return private.config:get('hiding')
    end

    function private:setHidings(hidings)
        private.config:set('hiding', hidings)
        return private
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
        return private
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
                    if private:isActive() then
                        local time = os.time()
                        for _, shop in ipairs(_base:get('shopManager'):getShops()) do
                            local text3d = shop:getText3d()
                            local distance = _base:get('helper'):distanceToPlayer3d(shop:getX(), shop:getY(), shop:getZ())
                            local aplpha = _base:get('color'):getAlpha(100 - math.floor(distance * 100 / private:getDistance()))
                            text3d:setAlpha(aplpha)
                            text3d:setDistance(private:getDistance())
                            text3d:setXray(private:isXray())
                            if distance > 20 then
                                text3d:setZ(shop:getZ() + 2)
                            else
                                text3d:setZ(shop:getZ() + distance / 10)
                            end
                            local shopTypes = {'player'}
                            text3d:setText(shop:getMod())
                            if _base:get('playerManager'):getName() == shop:getPlayer() then
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
                            elseif shop:getMod() == _base:get('message'):get('system_shop_empty') then
                                shopTypes = {'empty'}
                                text3d:setColor(private:getColor('empty'))
                            end
                            local show = false
                            local visitShop = private:getShop(shop:getId())
                            if visitShop ~= nil then
                                if time <= visitShop.time and (visitShop.mod == shop:getMod() or visitShop.mod == _base:get('message'):get('system_shop_edit')) then
                                    shopTypes = {'visit'}
                                    text3d:setColor(private:getColor('visit'))
                                    if private:isHidingActive('time') then
                                        text3d:setText(_base:get('helper'):implode(' ', {
                                            text3d:getText(),
                                            math.ceil((visitShop.time - time) / 60),
                                            'min'
                                        }))
                                    end
                                else
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
                                    if private:isHidingActive(shopType) then
                                        show = true
                                    end
                                end
                            end
                            if show then
                                text3d:update()
                            elseif text3d:getDistance() > 0 then
                                text3d:setDistance(0):update()
                            end
                        end
                    else
                        for _, shop in ipairs(_base:get('shopManager'):getShops()) do
                            local text3d = shop:getText3d()
                            if text3d:getDistance() > 0 then
                                text3d:setDistance(0):update()
                            end
                        end
                        wait(1000)
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
            'onEnterShop',
            function ()
                local shop = _base:get('shopManager'):getNearby()
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