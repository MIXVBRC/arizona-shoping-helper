local class = {}
function class:new(_defaultConfig)

    if _defaultConfig == nil then return nil end

    local public = {}
    local private = {
        ['name'] = 'visit',
        ['defaultConfig'] = _defaultConfig,
        ['colors'] = {
            ['white'] = 'ffffff',
            ['black'] = '000000',
            ['player'] = 'e06936',
            ['sell'] = '36e03c',
            ['buy'] = '3647e0',
            ['sell_buy'] = '36e0e0',
            ['edit'] = 'd2e036',
            ['visit'] = 'e03636',
            ['empty'] = 'cc36e0',
        },
        ['cache'] = _sh.dependencies.cache:new(1),
    }

    function private:getName()
        return private.name
    end

    function private:setOption(name, value)
        _sh.config:set(private:getName(), name, value)
    end

    function private:getOption(name)
        return _sh.config:get(private:getName(), name)
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

    function private:getColor(name)
        local color = private:getOption('color')
        if color ~= nil then
            return color[name]
        end
        return 'ffffff'
    end

    function private:getVisited()
        return private:getOption('visited') or {}
    end

    function private:setVisited(visited)
        return private:setOption('visited', visited)
    end

    function private:getVisit(id)
        local visited = private:getVisited()
        return private:getVisited()[id]
    end

    function private:addVisit(id, data)
        local visited = private:getVisited()
        visited[id] = data
        private:setOption('visited', visited)
        return public
    end

    function private:changeVisit(_id, _data)
        local visited = private:getVisited()
        for id, visit in pairs(private:getVisited()) do
            if _id == id then
                for key, value in pairs(_data) do
                    visit[key] = value
                end
            end
        end
        private:setOption('visited', visited)
        return public
    end

    function private:init()
        for name, value in pairs(private.defaultConfig) do
            if private:getOption(name) == nil then
                private:setOption(name, value)
            end
        end
        private:initThreads()
    end

    function private:initThreads()

        lua_thread.create(function () while true do wait(5000)
            local visited = private:getVisited()
            if visited ~= nil and #visited > 0 then
                local time = os.time()
                local newVisited = {}
                for id, visit in pairs(visited) do
                    if (time - visit.date) < 60 * 60 * 24 then
                        newVisited[id] = visit
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

    function private:work()
        local time = os.time()
        local shops = _sh.shopManager:getAll()

        for _, shop in ipairs(shops) do

            local text = ''
            local color = private:getColor('while')
            local polygons = 4
            local rotation = 0

            if _sh.player.name == shop:getPlayer() then
                color = private:getColor('player')
                polygons = 3
                rotation = 180
            else
                if shop:getMod() == _sh.message:get('message_shop_sell') then -- visit_shop_mod_sell
                    color = private:getColor('sell')
                elseif shop:getMod() == _sh.message:get('message_shop_buy') then
                    color = private:getColor('buy')
                elseif shop:getMod() == _sh.message:get('message_shop_sell_buy') then
                    color = private:getColor('sell_buy')
                elseif shop:getMod() == _sh.message:get('message_shop_edit') then
                    color = private:getColor('edit')
                elseif shop:getMod() == _sh.message:get('message_shop_empty') then
                    if private:isEmpty() then
                        color = private:getColor('empty')
                    else
                        goto continue
                    end
                end
            end

            local visitShop = private:getVisit(shop:getId())

            if visitShop ~= nil and visitShop.time ~= nil then

                if time <= visitShop.time and (visitShop.mod == shop:getMod() or visitShop.mod == _sh.message:get('message_shop_edit')) then
                    color = private:getColor('visit')
                    if private:isHiding() then
                        goto continue
                    end
                else
                    visitShop.time = nil
                    private:changeVisit(shop:getId(), {
                        ['time'] = visitShop.time,
                        ['mod'] = shop:getMod(),
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

            local distance = _sh.helper:distanceToPlayer3d(shop:getX(), shop:getY(), shop:getZ())
            local alpha = _sh.color:alpha(1 - math.floor(distance * 100 / private:getDistance()) / 100)

            if isPointOnScreen(shop:getX(), shop:getY(), shop:getZ(), 0) and distance < private:getDistance() then
                local sceenX, sceenY = convert3DCoordsToScreen(shop:getX(), shop:getY(), shop:getZ() - 1)
                renderDrawLine(sceenX, sceenY, sceenX, sceenY - 90, 1, alpha .. 'ffffff')
                renderDrawPolygon(sceenX, sceenY - 100, 20, 20, polygons, rotation, alpha .. color)
                renderFontDrawText(_sh.font:get('Arial', 12, 4), text, sceenX + 15, sceenY - 100, alpha .. 'ffffff', alpha .. '000000')
            end

            ::continue::
        end
    end

    _sh.customEvents:add('onVisitShop', function (shop, mod, textdrawId)
        local time = os.time() + 60 * private:getTime()
        if private:getVisit(shop:getId()) ~= nil then
            private:changeVisit(
                shop:getId(),
                {
                    ['date'] = os.time(),
                    ['time'] = time,
                    ['mod'] = shop:getMod(),
                }
            )
        else
            private:addVisit(
                shop:getId(),
                {
                    ['date'] = os.time(),
                    ['time'] = time,
                    ['mod'] = shop:getMod(),
                }
            )
        end
    end)

    private:init()

    return public
end
return class