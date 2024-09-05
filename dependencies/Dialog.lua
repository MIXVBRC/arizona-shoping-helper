local class = {}
function class:new(_id, _title, _text, _submitButtonText, _closeButtonText, _dialogType, _execute)
    local public = {}
    local private = {
        ['id'] = _id,
        ['title'] = _title,
        ['text'] = _text,
        ['submitButtonText'] = _submitButtonText,
        ['closeButtonText'] = _closeButtonText,
        ['dialogType'] = _dialogType,
        ['execute'] = _execute,
    }

    function public:getId()
        return private.id
    end

    function public:getTitle()
        return private.title
    end

    function public:getText()
        return private.text
    end

    function public:getSubmitButtonText()
        return private.submitButtonText
    end

    function public:getCloseButtonText()
        return private.closeButtonText
    end

    function public:getDialogType()
        return private.dialogType
    end

    function public:getExecute()
        return private.execute
    end

    function private:init()
        private:initDialog()
        private:initThreads()
    end

    function private:initDialog()
        local text = ''
        if public:getDialogType() == 0 or public:getDialogType() == 1 or public:getDialogType() == 3 then
            text = public:getText()
        elseif public:getDialogType() == 2 then
            text = table.concat(public:getText(), '\n')
        else
            text = ''
            for _, value in ipairs(public:getText()) do
                if text == '' then
                    text = table.concat(value, '\t')
                else
                    text = text .. '\n' .. table.concat(value, '\t')
                end
            end
        end
        if type(text) ~= 'string' then
            text = ''
        end
        sampShowDialog(
            public:getId(),
            public:getTitle(),
            text,
            public:getSubmitButtonText(),
            public:getCloseButtonText(),
            public:getDialogType()
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local result, button, list, input = sampHasDialogRespond(public:getId())
                    if result then
                        public:getExecute()(button, list, input)
                        return
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class