local class = {}
function class:new(_customDialogId)
    local this = {}
    local private = {
        ['customDialogId'] = _customDialogId,
        ['opened'] = false,
        ['openedId'] = nil,
    }

    function private:getCustomDialogId()
        return private.customDialogId
    end

    function this:isOpened()
        return private.opened
    end

    function private:setOpened(bool)
        private.opened = bool
        return this
    end

    function this:getOpenedId()
        return private.openedId
    end

    function private:setOpenedId(id)
        private.openedId = id
        return this
    end

    -- LOGIC

    function this:close()
        if this:isOpened() and this:getOpenedId() ~= nil then
            this:send(this:getOpenedId())
        end
        return this
    end

    function this:send(id, button, list, input)
        if id ~= nil then
            _sh.eventManager:trigger('onSendDialogResponse', id, button, list, input)
            sampSendDialogResponse(
                id,
                button or 0,
                list or 0,
                input or ''
            )
        end
        return this
    end

    function this:show(title, text, submitButtonText, closeButtonText, dialogType, execute)
        private:setOpened(true)
        private:setOpenedId(private:getCustomDialogId())
        _sh.dependencies.dialog:new(
            private:getCustomDialogId(),
            title,
            text,
            submitButtonText,
            closeButtonText,
            dialogType,
            function (button, list, input)
                execute(button, list, input)
                private:setOpened(false)
                private:setOpenedId(nil)
            end
        )
    end

    -- INITS

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onShowDialog',
            function (id, style, title, button1, button2, text)
                private:setOpened(true)
                private:setOpenedId(id)
                button1 = _sh.helper:removeColors(button1)
                button2 = _sh.helper:removeColors(button2)
                text = _sh.helper:removeColors(text)
                title = _sh.helper:removeColors(title)
                if title:find(_sh.message:get('system_regex_find_dialog_title_shop_id')) then
                    return _sh.eventManager:trigger('onShowDialogShopAdmining', id, style, title, button1, button2, text)
                elseif title:find(_sh.message:get('system_regex_find_dialog_title_buy_product')) then
                    if style == 0 or style == 1 then
                        _sh.chat:push(_sh.scan:extractNameFromDialog(text))
                        return _sh.eventManager:trigger('onShowDialogBuyProduct', id, style, title, button1, button2, text)
                    elseif style == 2 then
                        return _sh.eventManager:trigger('onShowDialogListBuyProduct', id, style, title, button1, button2, text)
                    end
                elseif title:find(_sh.message:get('system_regex_find_dialog_title_remove_sale')) then
                    return _sh.eventManager:trigger('onShowDialogRemoveSaleProduct', id, style, title, button1, button2, text)
                end
            end,
            1
        )
        _sh.eventManager:add(
            'onSendDialogResponse',
            function ()
                private:setOpened(false)
                private:setOpenedId(nil)
            end,
            1
        )
    end

    private:init()
    return this
end
return class