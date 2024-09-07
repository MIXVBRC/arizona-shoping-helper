local class = {}
function class:new(_customDialogId)
    local public = {}
    local private = {
        ['customDialogId'] = _customDialogId,
        ['opened'] = false,
    }

    function private:getCustomDialogId()
        return private.customDialogId
    end

    function public:isOpened()
        return private.opened
    end

    function private:setShowDialog(bool)
        private.opened = bool
        return public
    end

    function public:sendDialogResponse(id, button, list, input)
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
            function ()
                _sh.chat:push('open')
                private:setShowDialog(true)
            end
        )
        _sh.eventManager:add(
            'onSendDialogResponse',
            function ()
                _sh.chat:push('close')
                private:setShowDialog(false)
            end
        )
    end

    private:init()
    return public
end
return class