local class = {}
function class:new(_base, _name, _code, _price, _textdraw)
    local this = {}
    local private = {
        ['name'] = _name,
        ['code'] = _code,
        ['price'] = _price,
        ['textdraw'] = _textdraw,
        ['delete'] = false,
    }

    -- PARAMS

    function this:getName()
        return private.name
    end

    function private:setName(name)
        private.name = name
        return this
    end

    function this:getCode()
        return private.code
    end

    function this:isScanned()
        return this:getName() ~= nil
    end

    function this:getSign()
        if this:isScanned() then
            return this:getName()
        end
        return this:getCode()
    end

    function this:getPrice()
        return private.price
    end

    function this:getTextdraw()
        return private.textdraw
    end

    function this:isDelete()
        return private.delete
    end

    function this:delete()
        private.delete = true
        return this
    end

    -- SCAN

    function this:scan(time, execute)
        _base:get('queueManager')
        :add(
            function ()
                if not this:isDelete() and not this:isScanned() and sampTextdrawIsExists(this:getTextdraw():getId()) then
                    sampSendClickTextdraw(this:getTextdraw():getId())
                    while not this:isScanned() do wait(0) end
                    wait(time or 500)
                end
            end,
            (this:getTextdraw():getX() + this:getTextdraw():getY())
        )
        :addEvent(
            'onShowDialogBuyProduct',
            function (id, _, _, _, _, text)
                _base:get('dialogManager'):close(id)
                local name = _base:get('helper'):extractNameFromDialog(text)
                if name ~= nil or name ~= '' then
                    private:setName(name)
                    _base:get('eventManager'):trigger('onScanProduct', this)
                end
                return false
            end
        )
        :addEvent(
            'onShowDialogBuyProductCount',
            function (id, _, _, _, _, text)
                _base:get('dialogManager'):close(id)
                local name = _base:get('helper'):extractNameFromDialog(text)
                if name ~= nil or name ~= '' then
                    private:setName(name)
                    _base:get('eventManager'):trigger('onScanProduct', this)
                end
                return false
            end
        )
        :addEvent(
            'onShowDialogSaleProduct',
            function (id, _, _, _, _, text)
                _base:get('dialogManager'):close(id)
                local name = _base:get('helper'):extractNameFromDialog(text)
                if name ~= nil or name ~= '' then
                    private:setName(name)
                    _base:get('eventManager'):trigger('onScanProduct', this)
                end
                return false
            end
        )
        :addEvent(
            'onShowDialogSaleProductCount',
            function (id, _, _, _, _, text)
                _base:get('dialogManager'):close(id)
                local name = _base:get('helper'):extractNameFromDialog(text)
                if name ~= nil or name ~= '' then
                    private:setName(name)
                    _base:get('eventManager'):trigger('onScanProduct', this)
                end
                return false
            end
        )
        :addEvent(
            'onShowDialogBuyProductList',
            function (id)
                _base:get('dialogManager'):send(id, 1, 0)
                return false
            end
        )
        :addEvent(
            'onScanProduct',
            function (scannedProduct)
                if execute ~= nil then
                    execute(scannedProduct)
                end
            end
        )
        :active()
    end

    -- BUY

    function this:buy(time, execute)
        _base:get('queueManager')
        :add(
            function ()
                if not this:isDelete() and sampTextdrawIsExists(this:getTextdraw():getId()) then
                    sampSendClickTextdraw(this:getTextdraw():getId())
                    wait(time or 500)
                end
            end,
            (this:getTextdraw():getX() + this:getTextdraw():getY())
        )
        :addEvent(
            'onShowDialogBuyProduct',
            function (id)
                _base:get('dialogManager'):send(id, 1)
                _base:get('eventManager'):trigger('onBuyProduct', this, 1)
                return false
            end
        )
        :addEvent(
            'onShowDialogBuyProductCount',
            function (id, _, _, _, _, text)
                local enoughCount = _base:get('helper'):extractEnoughCountFromDialog(text)
                if enoughCount > 0 then
                    local count = _base:get('helper'):extractCountFromDialog(text)
                    if enoughCount < count then
                        count = enoughCount
                    end
                    _base:get('dialogManager'):send(id, 1, nil, count)
                    _base:get('eventManager'):trigger('onBuyProduct', this, count)
                else
                    _base:get('dialogManager'):close(id)
                end
                return false
            end
        )
        :addEvent(
            'onShowDialogBuyProductList',
            function (id)
                _base:get('dialogManager'):send(id, 1, 0)
                return false
            end
        )
        :addEvent(
            'onScanProduct',
            function (buyingProduct, count)
                if execute ~= nil then
                    execute(buyingProduct, count)
                end
            end
        )
        :active()
    end

    -- INITS

    function private:init()
        private:initThreads()
        return this
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while sampTextdrawIsExists(this:getTextdraw():getId()) do wait(0) end
                this:delete()
            end
        )
        return private
    end

    return private:init()
end
return class