local class = {}
function class:new(_customDialogId)
    local this = {}
    local private = {
        ['customDialogId'] = _customDialogId,
        ['opened'] = false,
        ['openedId'] = nil,
        ['dialogEvents'] = {
            {
                ['name'] = 'onShowDialogShopAdmining',
                ['style'] = 2,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_shop_id'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProduct',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProductCount',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProductList',
                ['style'] = 2,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogRemoveSaleProduct',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_remove_sale'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSubmittingEnterMessage',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_ad_submitting'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSelectType',
                ['style'] = 5,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_ad_submitting'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSelectRadioStation',
                ['style'] = 5,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_select_radio_station'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdConfirmation',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _sh.message:get('system_regex_find_dialog_title_ad_submitting_confirmation'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogSaleProduct',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = '',
                    ['text'] = _sh.message:get('system_regex_find_dialog_text_sale_product'),
                },
            },
            {
                ['name'] = 'onShowDialogSaleProductCount',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = '',
                    ['text'] = _sh.message:get('system_regex_find_dialog_text_sale_product_count'),
                },
            },
        }
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

    function private:getDialogEvents()
        return private.dialogEvents
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
                for _, event in ipairs(private:getDialogEvents()) do
                    if style == event.style
                    and ((event.regexp.title ~= '' and title:find(event.regexp.title)) or (event.regexp.text ~= '' and text:find(event.regexp.text)))
                    then
                        return _sh.eventManager:trigger(event.name, id, style, title, button1, button2, text)
                    end
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