local class = {}
function class:new(_id, _title, _text, _submitButtonText, _closeButtonText, _dialogType, _execute)
    local this = {}
    local private = {
        ['id'] = _id,
        ['title'] = _title,
        ['text'] = _text,
        ['submitButtonText'] = _submitButtonText,
        ['closeButtonText'] = _closeButtonText,
        ['dialogType'] = _dialogType,
        ['execute'] = _execute,
    }

    function this:getId()
        return private.id
    end

    function this:getTitle()
        return private.title
    end

    function this:getText()
        return private.text
    end

    function this:getSubmitButtonText()
        return private.submitButtonText
    end

    function this:getCloseButtonText()
        return private.closeButtonText
    end

    function this:getDialogType()
        return private.dialogType
    end

    function this:getExecute()
        return private.execute
    end

    function private:init()
        private:initDialog()
        private:initThreads()
    end

    function private:initDialog()
        local text = ''
        if this:getDialogType() == 0 or this:getDialogType() == 1 or this:getDialogType() == 3 then
            text = this:getText()
        elseif this:getDialogType() == 2 then
            text = _sh.helper:implode('\n', this:getText())
        else
            text = ''
            for _, value in ipairs(this:getText()) do
                if text == '' then
                    text = _sh.helper:implode('\t', value)
                else
                    text = text .. '\n' .. _sh.helper:implode('\t', value)
                end
            end
        end
        if type(text) ~= 'string' then
            text = ''
        end
        sampShowDialog(
            this:getId(),
            this:getTitle(),
            text,
            this:getSubmitButtonText(),
            this:getCloseButtonText(),
            this:getDialogType()
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local result, button, list, input = sampHasDialogRespond(this:getId())
                    if result then
                        this:getExecute()(button, list, input)
                        return
                    end
                end
            end
        )
    end

    private:init()
    return this
end
return class