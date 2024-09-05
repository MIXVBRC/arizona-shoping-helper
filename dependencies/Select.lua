local class = {}
function class:new(_command, _defaultConfig)
    local public = {}
    local private = {
        ['minmax'] = _sh.dependencies.minMax:new({
            ['border'] = {
                ['min'] = 1,
                ['max'] = 5,
            },
            ['alpha'] = {
                ['min'] = 1,
                ['max'] = 100,
            },
        }),
        ['configManager'] = _sh.dependencies.configManager:new(_command, _sh.config),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:getOption('active')
    end

    function private:toggleActive()
        private.configManager:setOption('active', not private:isActive())
        return public
    end

    -- ADD

    function private:isAdd()
        return private.configManager:getOption('add')
    end

    function private:toggleAdd()
        private.configManager:setOption('add', not private:isAdd())
        return public
    end

    -- BORDER

    function private:getBorder()
        return private.configManager:getOption('border')
    end

    function private:setBorder(border)
        private.configManager:setOption('border', private.minmax:get(border, 'border'))
        return public
    end

    -- COLOR

    function private:getColor()
        return private.configManager:getOption('color')
    end

    function private:setColor(color)
        return private.configManager:setOption('color', color or '0000ff')
    end

    -- ALPHA

    function private:getAlpha()
        return private.configManager:getOption('alpha')
    end

    function private:setAlpha(alpha)
        return private.configManager:setOption('alpha', private.minmax:get(alpha, 'alpha'))
    end

    -- TEXTDRAWS

    function private:getTextdrawCodes()
        return private.configManager:getOption('items') or {}
    end

    function private:setTextdrawsCodes(textdrawCodes)
        textdrawCodes = textdrawCodes or {}
        private.configManager:setOption('items', textdrawCodes)
        return public
    end

    function private:addTextdrawCode(code)
        local textdrawCodes = private:getTextdrawCodes()
        table.insert(textdrawCodes, code)
        private:setTextdrawsCodes(textdrawCodes)
        return public
    end

    function private:deleteTextdrawCode(code)
        local textdrawCodes = {}
        for _, textdrawCode in ipairs(private:getTextdrawCodes()) do
            if code ~= textdrawCode then
                table.insert(textdrawCodes, textdrawCode)
            end
        end
        private:setTextdrawsCodes(textdrawCodes)
        return public
    end

    function private:toggleTextdrawCode(code)
        for _, textdrawCode in ipairs(private:getTextdrawCodes()) do
            if code == textdrawCode then
                private:deleteTextdrawCode(code)
                return public
            end
        end
        private:addTextdrawCode(code)
        return public
    end

    -- WORK

    function private:work()
        if _sh.player:inShop() then
            for _, code in ipairs(private:getTextdrawCodes()) do
                for _, textdraw in ipairs(_sh.textdrawManager:getTextdraws()) do
                    if code == textdraw:getCode() then
                        renderDrawBoxWithBorder(
                            textdraw:getX(),
                            textdraw:getY(),
                            textdraw:getWidth(),
                            textdraw:getHeight(),
                            '0x00ffffff',
                            private:getBorder(),
                            _sh.color:alpha(private:getAlpha()) .. private:getColor()
                        )
                    end
                end
            end
        end
    end

    -- INITS

    function private:init(defaultConfig)
        for name, value in pairs(defaultConfig) do
            if private.configManager:getOption(name) == nil then
                private.configManager:setOption(name, value)
            end
        end
        private:initCommands()
        private:initThreads()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('add', private.toggleAdd)
        private.commandManager:add('border', function (border)
            private:setBorder(_sh.helper:toNumber(border))
        end)
        private.commandManager:add('color', function (color)
            if color:find('^......$') then
                private:setColor(color)
            end
        end)
        private.commandManager:add('alpha', function (border)
            private:setAlpha(_sh.helper:toNumber(border))
        end)
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    if private:isActive() then
                        private:work()
                    end
                end
            end
        )
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (textdrawId)
                if _sh.player:inShop() and private:isActive() and private:isAdd() then
                    for _, textdraw in ipairs(_sh.textdrawManager:getTextdraws()) do
                        if textdrawId == textdraw:getId() then
                            for _, childTextdraw in ipairs(textdraw:getChilds()) do
                                if _sh.helper:isPrice(childTextdraw:getText()) then
                                    private:toggleTextdrawCode(textdraw:getCode())
                                    return
                                end
                            end
                        end
                    end
                end
            end
        )
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId)
                if _sh.player:inShop() and private:isActive() and private:isAdd() then
                    _sh.chat:push(dialogId)
                    sampSendDialogResponse(dialogId, 0, 0)
                    return false
                end
            end
        )
    end

    private:init(_defaultConfig or {})
    return public
end
return class