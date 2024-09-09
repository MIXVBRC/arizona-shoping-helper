local class = {}
function class:new(_name, _code, _price, _textdraw)
    local public = {}
    local private = {
        ['name'] = _name,
        ['code'] = _code,
        ['price'] = _price,
        ['textdraw'] = _textdraw,
        ['scanning'] = false,
        ['scanned'] = false,
        ['exist'] = true,
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

    function public:isScanning()
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

    function public:isExist()
        return private.exist
    end

    -- LOGIC

    function public:delete()
        private.exist = false
        _sh.eventManager:trigger('onDeleteProduct', public)
    end

    function public:scan()
        if not public:isScanned() and sampTextdrawIsExists(public:getTextdraw():getId()) then
            private:setScanning(true)
            sampSendClickTextdraw(public:getTextdraw():getId())
        end
        return public
    end

    function public:scanDialogName(dialogId, text)
        for _, _dialogId in ipairs(private:getDialogIds()) do
            if dialogId == _dialogId then
                local name = private:extractName(text)
                if name ~= nil then
                    private:setName(name)
                    private:setScanned(true)
                end
                break
            end
        end
        private:setScanning(false)
    end

    function private:extractName(text)
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
        result = _sh.helper:implode(':', array, 2, #array)
        if result == nil or result == '' then
            array = _sh.helper:explode(' ', exploded)
            result = _sh.helper:implode(' ', array, 4, #array)
        end
        return prefix .. _sh.helper:trim(result)
    end

    -- INITS

    function private:init()
        private:initThrades()
    end

    function private:initThrades()
        _sh.threadManager:add(
            nil,
            function ()
                while sampTextdrawIsExists(public:getTextdraw():getId()) do wait(0) end
                public:delete()
            end
        )
    end

    private:init()
    return public
end
return class