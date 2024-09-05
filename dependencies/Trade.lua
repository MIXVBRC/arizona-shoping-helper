local class = {}
function class:new(_command, _default)
    local public = {}
    local private = {
        ['editShop'] = false,
        ['clickedTextdraw'] = {
            ['textdraw'] = nil,
            ['count'] = 1,
            ['editType'] = 'add',
        },
        ['configManager'] = _sh.dependencies.configManager:new(_command, _sh.config, _default),
        ['commandManager'] = _sh.dependencies.commandManager:new(_command),
    }

    -- ACTIVE

    function private:isActive()
        return private.configManager:getOption('active')
    end

    function private:toggleActive()
        private.configManager:setOption('active', not private:isActive())
        return public
    end

    -- EDIT SHOP

    function private:isEditShop()
        return private.editShop
    end

    function private:setEditShop(boolean)
        private.editShop = boolean
        return public
    end

    -- LAST

    function private:isLast()
        return private.configManager:getOption('last')
    end

    function private:toggleLast()
        private.configManager:setOption('last', not private:isActive())
        return public
    end

    -- CLICKED TEXTDRAW

    function private:getClickedTextdraw()
        return private.clickedTextdraw
    end

    function private:setClickedTextdraw(textdraw, count, editType)
        count = count or 1
        private.clickedTextdraw = {
            ['textdraw'] = textdraw,
            ['count'] = count,
            ['editType'] = editType,
        }
        return public
    end

    function private:clearClickedTextdraw()
        private:setClockedTextdraw(nil, 1, 'add')
        return public
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

    -- INITS

    function private:init()
        private:initCommands()
        private:initEvents()
    end

    function private:initCommands()
        private.commandManager:add('active', private.toggleActive)
        private.commandManager:add('last', private.toggleLast)
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onSendClickTextDraw',
            function (textdrawId)
                if _sh.player:editProducts() and private:isActive() then
                    local textdraw = _sh.textdrawManager:getTextdrawById(textdrawId)
                    if textdraw ~= nil then
                        for _, childTextdraw in ipairs(textdraw:getChilds()) do
                            if _sh.helper:isPrice(childTextdraw:getText()) then
                                private:setClickedTextdraw(textdraw, 1, 'delete')
                                return
                            elseif _sh.helper:isNumber(childTextdraw:getText()) then
                                local count = _sh.helper:getNumber(childTextdraw:getText())
                                if private:isLast() and count > 1 then
                                    count = count - 1
                                end
                                private:setClickedTextdraw(textdraw, count, 'add')
                                return
                            end
                        end
                    end
                end
            end
        )
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if _sh.player:editProducts() and private:isActive() then
                    local clickedTextdraw = private:getClickedTextdraw()
                    if clickedTextdraw.textdraw ~= nil then
                        if clickedTextdraw.editType == 'add' then
                            sampSendDialogResponse(dialogId, 0)
                            text = text:match('^.*%(%s+{.+}(.+){.+}%s+%).*$')
                            print(text)
                            _sh.dialogManager:show(
                                '{65f0c6}Введи цену за предмет',
                                text,
                                'Запомнить',
                                'Отмена',
                                1,
                                function (button, _, input)
                                    if button == 1 then
                                        input = _sh.helper:getNumber(input)
                                        -- _sh.chat:push(input)
                                    end
                                end
                            )
                            _sh.chat:push('add')
                            return false
                        else
                            _sh.chat:push('delete')
                            sampSendDialogResponse(dialogId, 1)
                            return false
                        end
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class