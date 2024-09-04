local class = {}
function class:new(_name, _defaultConfig)
    local public = {}
    local private = {
        ['lastVisitId'] = nil,
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
        ['configManager'] = _sh.dependencies.configManager:new(_name, _sh.config),
        ['commandManager'] = _sh.dependencies.commandManager:new(_name),
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:getOption('active')
    end

    function public:toggleActive()
        private.configManager:setOption('active', not private:isActive())
        return public
    end

    -- DISTANCE

    function private:getDistance()
        return private.configManager:getOption('distance')
    end

    function private:setDistance(distance)
        private.configManager:setOption('distance', private.minmax:get(distance, 'distance'))
        return public
    end

    -- TIME

    function private:getTime()
        return private.configManager:getOption('time')
    end

    function private:setTime(time)
        private.configManager:setOption('time', private.minmax:get(time, 'time'))
        return public
    end

    -- COLOR

    function private:getColor(name)
        return private.configManager:getOption('colors')[name]
    end

    -- LAST

    function private:getLastVisitId()
        return private.lastVisitId
    end

    function private:setLastVisitId(id)
        private.lastVisitId = id
        return public
    end

    -- HIDINGS

    function private:getHidings()
        return private.configManager:getOption('hiding')
    end

    function private:setHidings(hidings)
        private.configManager:setOption('hiding', hidings)
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

    -- VISITS

    function private:getVisits()
        return private.configManager:getOption('visits') or {}
    end

    function private:setVisits(visits)
        return private.configManager:setOption('visits', visits)
    end

    function private:clearVisits()
        return private:setVisits({})
    end

    function private:getVisit(id)
        return private:getVisits()[id]
    end

    function private:addVisit(id, data)
        local visits = private:getVisits()
        visits[id] = data
        private:setVisits(visits)
        return public
    end

    function private:changeVisit(_id, _data)
        local visits = private:getVisits()
        for id, visit in pairs(private:getVisits()) do
            if _id == id then
                for key, value in pairs(_data) do
                    visit[key] = value
                end
            end
        end
        private:setVisits(visits)
        return public
    end

    -- INITS

    function private:init(defaultConfig)
        for name, value in pairs(defaultConfig) do
            if private.configManager:getOption(name) == nil then
                private.configManager:setOption(name, value)
            end
        end
        private:initThreads()
        private:initCommands()
    end

    function private:initThreads()
        lua_thread.create(function () while true do wait(1000 * 60)
            local visits = private:getVisits()
            if visits ~= nil then
                local time = os.time()
                local flag = false
                local new = {}
                for id, visit in pairs(visits) do
                    if visit.time ~= nil and time < visit.time then
                        new[id] = visit
                    else
                        flag = true
                    end
                end
                if flag then
                    private:setVisits(new)
                end
            end
        end end)
        lua_thread.create(function () while true do wait(0)
            if private:isActive() then
                private:work()
            end
        end end)
    end

    function private:initCommands()
        private.commandManager:add('active', public.toggleActive)
        private.commandManager:add('distance', function (distance)
            distance = _sh.helper:toInt(distance)
            if distance ~= nil then
                private:setDistance(_sh.helper:toInt(distance))
            end
        end)
        private.commandManager:add('time', function (time)
            time = _sh.helper:toInt(time)
            if time ~= nil then
                local differenceTime = private:getTime() - time
                local visits = private:getVisits()
                for _, visit in pairs(visits) do
                    if visit.time == nil then
                        visit.time = time
                    end
                    visit.time = visit.time - differenceTime * 60
                end
                private:setVisits(visits)
                private:setTime(_sh.helper:toInt(time))
            end
        end)
        private.commandManager:add('select', function (text)
            local lastVisitId = private:getLastVisitId()
            if lastVisitId ~= nil then
                local visit = private:getVisit(lastVisitId)
                if visit.select then
                    private:changeVisit(lastVisitId, {
                        ['select'] = false,
                        ['text'] = '',
                    })
                else
                    private:changeVisit(lastVisitId, {
                        ['select'] = true,
                        ['text'] = text,
                    })
                end
            end
        end)
        for hiding, _ in pairs(private:getHidings()) do
            private.commandManager:add(_sh.helper:implode('-', {'active', hiding}), function ()
                private:toggleHiding(hiding)
            end)
        end
    end

    -- WORK

    function private:work()
        local time = os.time()
        local shops = _sh.shopManager:getAll()
        local colors = {
            ['stick'] = private:getColor('stick'),
            ['text'] = private:getColor('text'),
        }

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
                elseif shop:getMod() == _sh.message:get('message_shop_sell') then -- visit_shop_mod_sell
                    shopTypes = {'sell'}
                    render.color = private:getColor('sell')
                elseif shop:getMod() == _sh.message:get('message_shop_buy') then
                    shopTypes = {'buy'}
                    render.color = private:getColor('buy')
                elseif shop:getMod() == _sh.message:get('message_shop_sell_buy') then
                    shopTypes = {'sell','buy'}
                    render.color = private:getColor('sell_buy')
                elseif shop:getMod() == _sh.message:get('message_shop_edit') then
                    shopTypes = {'edit'}
                    render.color = private:getColor('edit')
                elseif shop:getMod() == _sh.message:get('message_shop_empty') then
                    shopTypes = {'empty'}
                    render.color = private:getColor('empty')
                end

                local visit = private:getVisit(shop:getId())
                local show = false

                if visit ~= nil and visit.time ~= nil then
                    if time <= visit.time and (visit.mod == shop:getMod() or visit.mod == _sh.message:get('message_shop_edit')) then
                        shopTypes = {'visit'}
                        render.color = private:getColor('visit')
                        if private:getHiding('time') then
                            render.text = math.ceil((visit.time - timeNow) / 60) .. ' min'
                        end
                    else
                        visit.time = nil
                        private:changeVisit(shop:getId(), {
                            ['time'] = visit.time,
                            ['mod'] = shop:getMod(),
                        })
                    end
                    if visit.select then
                        render.color = private:getColor('select')
                        render.polygons = 3
                        render.rotation = 180
                        render.text = visit.text
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

        if #renders > 0 then
            for _, render in ipairs(renders) do
                local distance = _sh.helper:distanceToPlayer3d(render.x, render.y, render.z)
                local alpha = _sh.color:alpha(1 - math.floor(distance * 100 / private:getDistance()) / 100)
                if isPointOnScreen(render.x, render.y, render.z, 0) and distance < private:getDistance() then
                    local sceenX, sceenY = convert3DCoordsToScreen(render.x, render.y, render.z - 1)
                    renderDrawLine(sceenX, sceenY, sceenX, sceenY - 90, 1, alpha .. colors.stick)
                    renderDrawPolygon(sceenX, sceenY - 100, 20, 20, render.polygons, render.rotation, alpha .. render.color)
                    if render.text ~= nil or render.text ~= '' then
                        renderFontDrawText(_sh.font:get('Arial', 12, 4), render.text, sceenX + 15, sceenY - 110, alpha .. colors.text)
                    else
                        renderFontDrawText(_sh.font:get('Arial', 12, 4), render.text, sceenX + 15, sceenY - 110, alpha .. colors.text)
                    end
                end
            end
        end
    end

    -- EVENTS

    _sh.customEvents:add('onVisitShop', function (shop, mod, textdrawId)
        private:setLastVisitId(shop:getId())
        local date = os.time()
        local time = date + ( private:getTime() * 60 )
        if private:getVisit(shop:getId()) ~= nil then
            private:changeVisit(
                shop:getId(),
                {
                    ['date'] = date,
                    ['time'] = time,
                    ['mod'] = shop:getMod(),
                }
            )
        else
            private:addVisit(
                shop:getId(),
                {
                    ['date'] = date,
                    ['time'] = time,
                    ['mod'] = shop:getMod(),
                    ['select'] = false,
                    ['text'] = '',
                }
            )
        end
    end)

    private:init(_defaultConfig or {})
    return public
end
return class