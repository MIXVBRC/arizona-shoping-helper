local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function this:isActive()
        return private.config:get('active')
    end

    function this:toggleActive()
        private.config:set('active', not this:isActive())
        return this
    end

    -- PRICE

    function private:getPrice()
        return private.config:get('price') or private.minmax:getMin('price')
    end

    function private:setPrice(price)
        private.config:set('price', private.minmax:get(price, 'price'))
        return private
    end

    -- COUNT

    function private:getCount()
        return private.config:get('count') or private.minmax:getMin('count')
    end

    function private:setCount(count)
        private.config:set('count', private.minmax:get(count, 'count'))
        return private
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initEvents()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, this.toggleActive)
        :add({private:getName(), 'price'}, function (price)
            private:setPrice(_base:get('helper'):getNumber(price))
        end)
        :add({private:getName(), 'count'}, function (count)
            private:setCount(_base:get('helper'):getNumber(count))
        end)
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onClickProduct',
            function (clickedProduct)
                if this:isActive() and isKeyDown(VK_CONTROL) then
                    if clickedProduct:getPrice() <= private:getPrice() then
                        clickedProduct:buy(private:getCount())
                    else
                        _base:getNew('error', _base:get('message'):get('message_buyer_buy_error_price'))
                        return false
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class