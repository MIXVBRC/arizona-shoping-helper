local class = {}
function class:new(_, _id, _title, _text, _submitButtonText, _closeButtonText, _dialogType, _successExecute, _cancleExecute)
    local this = {}
    local private = {
        ['id'] = _id,
        ['title'] = _title,
        ['text'] = _text,
        ['submitButtonText'] = _submitButtonText,
        ['closeButtonText'] = _closeButtonText,
        ['dialogType'] = _dialogType,
        ['successExecute'] = _successExecute or function () end,
        ['cancleExecute'] = _cancleExecute or function () end,
    }

    -- ID

    function this:getId()
        return private.id
    end

    -- TITLE

    function this:getTitle()
        return private.title
    end

    -- TEXT

    function this:getText()
        return private.text
    end

    -- SUBMIT BUTTON TEXT

    function this:getSubmitButtonText()
        return private.submitButtonText
    end

    -- CLOSE BUTTON TEXT

    function this:getCloseButtonText()
        return private.closeButtonText
    end

    -- DIALOG TYPE

    function this:getDialogType()
        return private.dialogType
    end

    -- SUCCESS EXECUTE

    function this:getSuccessExecute()
        return private.successExecute
    end

    -- CANCLE EXECUTE

    function this:getCancleExecute()
        return private.cancleExecute
    end

    -- INITS

    function private:init()
        private:initDialog()
        return this
    end

    function private:initDialog()
        sampShowDialog(
            this:getId(),
            this:getTitle(),
            this:getText(),
            this:getSubmitButtonText(),
            this:getCloseButtonText(),
            this:getDialogType()
        )
        return private
    end

    return private:init()
end
return class