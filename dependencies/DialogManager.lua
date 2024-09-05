local class = {}
function class:new(_dialogId)
    local public = {}
    local private = {
        ['dialogId'] = _dialogId,
    }

    function private:getDialogId()
        return private.dialogId
    end

    function public:show(title, text, submitButtonText, closeButtonText, dialogType, execute)
        _sh.dependencies.dialog:new(
            private:getDialogId(),
            title,
            text,
            submitButtonText,
            closeButtonText,
            dialogType,
            execute
        )
    end

    return public
end
return class