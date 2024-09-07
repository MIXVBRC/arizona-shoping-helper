local class = {}
function class:new(_name, _code, _price, _mod, _textdraw)
    local public = {}
    local private = {
        ['name'] = _name,
        ['code'] = _code,
        ['price'] = _price,
        ['color'] = 'ffffff',
        ['mod'] = _mod,
        ['textdraw'] = _textdraw,
        ['scaning'] = false,
        ['dialogIds'] = {
            3082,
            26541,
        },
        ['prefixes'] = {
            'Скин: ',
        },
    }

    function public:getName()
        return private.name
    end

    function private:setName(name)
        private.name = name
        return public
    end

    function public:getCode()
        return private.code
    end

    function public:getPrice()
        return private.price
    end

    function public:getTextdraw()
        return private.textdraw
    end

    function public:isScaning()
        return private.scaning
    end

    function public:setScaning(bool)
        private.scaning = bool
    end

    function private:getDialogIds()
        return private.dialogIds
    end

    function private:getPrefixes()
        return private.prefixes
    end

    function public:scan()
        if (public:getName() == nil or public:getName() == '') and sampTextdrawIsExists(public:getTextdraw():getId()) then
            _sh.chat:push(1)
            public:setScaning(true)
            sampSendClickTextdraw(public:getTextdraw():getId())
            _sh.chat:push(2)
        end
        return public
    end

    function private:init()
        private:initEvents()
        private:initThreads()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, _text)
                _sh.chat:push(3)
                if public:isScaning() then
                    _sh.chat:push(4)
                    for _, _dialogId in ipairs(private:getDialogIds()) do
                        if dialogId == _dialogId then
                            local prefix = ''
                            local result = nil
                            local exploded = _sh.helper:explode('\n', _text:gsub('{......}', ''))[1]
                            for _, _prefix in ipairs(private:getPrefixes()) do
                                if exploded:find(_prefix) then
                                    prefix = _prefix
                                    break
                                end
                            end
                            local array = _sh.helper:explode(':', exploded)
                            result = table.concat(array, ':', 2, #array)
                            if result == nil or result == '' then
                                array = _sh.helper:explode(' ', exploded)
                                result = table.concat(array, ' ', 4, #array)
                            end
                            if result ~= nil then
                                private:setName(prefix .. _sh.helper:trim(result))
                                private.color = '00ff00'
                            else
                                private.color = 'ff0000'
                            end
                            _sh.chat:push(5)
                            public:setScaning(false)
                            break
                        end
                    end
                end
                _sh.chat:push(6)
                sampSendDialogResponse(dialogId, 0)
                return false
            end
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while sampTextdrawIsExists(public:getTextdraw():getId()) do wait(0)
                    renderDrawBoxWithBorder(
                        public:getTextdraw():getX(),
                        public:getTextdraw():getY(),
                        public:getTextdraw():getWidth(),
                        public:getTextdraw():getHeight(),
                        '0x00ffffff',
                        1,
                        '0xff'..private.color
                    )
                end
            end
        )
    end

    private:init()
    return public
end
return class