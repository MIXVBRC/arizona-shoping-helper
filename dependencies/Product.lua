local class = {}
function class:new(_name, _code, _price, _mod, _textdraw)
    local public = {}
    local private = {
        ['name'] = _name,
        ['code'] = _code,
        ['price'] = _price,
        ['mod'] = _mod,
        ['textdraw'] = _textdraw,
        ['scanning'] = false,
        ['scanned'] = false,
        ['dialogIds'] = {
            3082,
            26541,
        },
        ['prefixes'] = {
            'Скин: ',
        },
    }

    -- PARAMS

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

    function private:isScanning()
        return private.scanning
    end

    function private:setScanning(bool)
        private.scanning = bool
        return public
    end

    function public:isScanned()
        return private.scanned
    end

    function private:setScanned(bool)
        private.scanned = bool
        return public
    end

    function private:getDialogIds()
        return private.dialogIds
    end

    function private:getPrefixes()
        return private.prefixes
    end

    -- LOGICK

    function public:scan()
        if not public:isScanned() and sampTextdrawIsExists(public:getTextdraw():getId()) then
            private:setScanning(true)
            sampSendClickTextdraw(public:getTextdraw():getId())
        end
        return public
    end

    function private:extractProductName(text)
        local prefix = ''
        local result = nil
        local exploded = _sh.helper:explode('\n', text:gsub('{......}', ''))[1]
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
        return prefix .. _sh.helper:trim(result)
    end

    -- INITS

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onShowDialog',
            function (dialogId, _, _, _, _, text)
                if private:isScanning() then
                    for _, _dialogId in ipairs(private:getDialogIds()) do
                        if dialogId == _dialogId then
                            local name = private:extractProductName(text)
                            if name ~= nil then
                                private:setName(name)
                                private:setScanned(true)
                            end
                            break
                        end
                    end
                    _sh.dialogManager:sendDialogResponse(dialogId)
                    private:setScanning(false)
                    return false
                end
            end,
            1000
        )
    end

    private:init()
    return public
end
return class