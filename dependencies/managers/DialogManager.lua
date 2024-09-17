local class = {}
function class:new(_base, _dialogId)
    local this = {}
    local private = {
        ['dialogId'] = _dialogId,
        ['opened'] = false,
        ['openedId'] = nil,
        ['dialogs'] = {},
        ['dialogEvents'] = {
            {
                ['name'] = 'onShowDialogShopAdmining',
                ['style'] = 2,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_shop_id'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProduct',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProductCount',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogSaleProduct',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_sale_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogSaleProductCount',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_sale_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogBuyProductList',
                ['style'] = 2,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_buy_product'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogRemoveSaleProduct',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_remove_sale'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSubmittingEnterMessage',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_ad_submitting'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSelectRadioStation',
                ['style'] = 5,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_select_radio_station'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdSelectType',
                ['style'] = 5,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_ad_submitting'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdConfirmation',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_ad_submitting_confirmation'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogAdCancel',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = _base:get('message'):get('system_regex_find_dialog_title_ad_cancel'),
                    ['text'] = '',
                },
            },
            {
                ['name'] = 'onShowDialogSaleProduct',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = '',
                    ['text'] = _base:get('message'):get('system_regex_find_dialog_text_sale_product'),
                },
            },
            {
                ['name'] = 'onShowDialogSaleProductCount',
                ['style'] = 1,
                ['regexp'] = {
                    ['title'] = '',
                    ['text'] = _base:get('message'):get('system_regex_find_dialog_text_sale_product_count'),
                },
            },
            {
                ['name'] = 'onShowDialogVR',
                ['style'] = 0,
                ['regexp'] = {
                    ['title'] = '',
                    ['text'] = _base:get('message'):get('system_regex_find_dialog_text_vr'),
                },
            },
        }
    }

    function private:getDialogId()
        return private.dialogId
    end

    function this:isOpened()
        return private.opened
    end

    function private:setOpened(bool)
        private.opened = bool
        return private
    end

    function this:getOpenedId()
        return private.openedId
    end

    function private:setOpenedId(id)
        private.openedId = id
        return private
    end

    function private:getDialogs()
        return private.dialogs
    end

    function private:addDialog(dialog)
        table.insert(private.dialogs, dialog)
        return private
    end

    function private:deleteDialog(index)
        table.remove(private.dialogs, index)
        return private
    end

    function private:getDialogEvents()
        return private.dialogEvents
    end

    -- FORMAT TEXT

    function private:formatText(text)
        local result = text
        if type(text) == 'table' then
            result = {}
            for _, n in ipairs(text) do
                if type(n) == 'table' then
                    n = _base:get('helper'):implode('\t', n)
                end
                table.insert(result, n)
            end
            result = _base:get('helper'):implode('\n', result)
        end
        return result
    end

    -- CLOSE

    function this:close(id)
        id = id or this:getOpenedId()
        if id ~= nil and this:isOpened() then
            this:send(id)
        end
        return this
    end

    -- SEND

    function this:send(id, button, list, input)
        id = id or this:getOpenedId()
        if id ~= nil and this:isOpened() then
            _base:get('eventManager'):trigger('onSendDialogResponse', id, button, list, input)
            sampSendDialogResponse(
                id,
                button or 0,
                list or 0,
                input or ''
            )
        end
        return this
    end

    -- SHOW

    -- dialogType = 0 - simple
    -- dialogType = 1 - input
    -- dialogType = 2 - list
    -- dialogType = 3 - password
    -- dialogType = 5 - table
    -- dialogType = 5 - table
    function this:show(title, text, submitButtonText, closeButtonText, dialogType, successExecute, cancleExecute)
        text = private:formatText(text)
        private:addDialog(
            _base:getNew('dialog',
                private:getDialogId(),
                title,
                text,
                submitButtonText,
                closeButtonText,
                dialogType,
                successExecute,
                cancleExecute
            )
        )
        _base:get('eventManager'):trigger('onShowDialog', private:getDialogId(), dialogType, title, submitButtonText, closeButtonText, text)
        return this
    end

    -- INITS

    function private:init()
        private:initEvents():initThreads()
        return this
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onShowDialog',
            function (id, style, title, submitButtonText, closeButtonText, text)
                private:setOpened(true)
                private:setOpenedId(id)
                submitButtonText = _base:get('helper'):removeColors(submitButtonText or '')
                closeButtonText = _base:get('helper'):removeColors(closeButtonText or '')
                text = _base:get('helper'):removeColors(text or '')
                title = _base:get('helper'):removeColors(title or '')
                for _, event in ipairs(private:getDialogEvents()) do
                    if style == event.style
                    and ((event.regexp.title ~= '' and title:find(event.regexp.title)) or (event.regexp.text ~= '' and text:find(event.regexp.text)))
                    then
                        return _base:get('eventManager'):trigger(event.name, id, style, title, submitButtonText, closeButtonText, text)
                    end
                end
            end,
            1
        )
        :add(
            'onSendDialogResponse',
            function ()
                private:setOpened(false)
                private:setOpenedId(nil)
            end,
            1
        )
        :add(
            'onSendClickTextDraw',
            function ()
                if this:isOpened() and this:getOpenedId() == private:getDialogId() then
                    return false
                end
            end,
            1
        )
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    for index, dialog in ipairs(private:getDialogs()) do
                        local result, button, list, input = sampHasDialogRespond(dialog:getId())
                        if result then
                            list = list + 1
                            _base:get('eventManager'):trigger('onSendDialogResponse', button, list, input)
                            if button == 1 then
                                dialog:getSuccessExecute()(list, input)
                            else
                                dialog:getCancleExecute()(list, input)
                            end
                            private:deleteDialog(index)
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class