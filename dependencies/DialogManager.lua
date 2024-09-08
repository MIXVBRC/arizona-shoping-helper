local class = {}
function class:new(_customDialogId)
    local public = {}
    local private = {
        ['customDialogId'] = _customDialogId,
        ['opened'] = false,
        ['openedId'] = nil,
    }

    function private:getCustomDialogId()
        return private.customDialogId
    end

    function public:isOpened()
        return private.opened
    end

    function private:setOpened(bool)
        private.opened = bool
        return public
    end

    function public:getOpenedId()
        return private.openedId
    end

    function private:setOpenedId(id)
        private.openedId = id
        return public
    end

    -- LOGIC

    function public:close()
        if public:isOpened() and public:getOpenedId() ~= nil then
            public:send(public:getOpenedId())
        end
        return public
    end

    function public:send(id, button, list, input)
        if id ~= nil then
            _sh.eventManager:trigger('onSendDialogResponse', id, button, list, input)
            sampSendDialogResponse(
                id,
                button or 0,
                list or 0,
                input or ''
            )
        end
        return public
    end

    function public:show(title, text, submitButtonText, closeButtonText, dialogType, execute)
        _sh.dependencies.dialog:new(
            private:getCustomDialogId(),
            title,
            text,
            submitButtonText,
            closeButtonText,
            dialogType,
            execute
        )
    end

    -- INITS

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onShowDialog',
            function (id)
                private:setOpened(true)
                private:setOpenedId(id)
            end
        )
        _sh.eventManager:add(
            'onSendDialogResponse',
            function ()
                private:setOpened(false)
                private:setOpenedId(nil)
            end
        )
    end

    private:init()
    return public
end
return class