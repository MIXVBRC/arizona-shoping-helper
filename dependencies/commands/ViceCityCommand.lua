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

    -- BUY

    function private:getBuy()
        return private.config:get('buy') or private.minmax:getMin('buy')
    end

    function private:setBuy(value)
        private.config:set('buy', private.minmax:get(value, 'buy'))
        return private
    end

    -- SELL

    function private:getSell()
        return private.config:get('sell') or private.minmax:getMin('sell')
    end

    function private:setSell(value)
        private.config:set('sell', private.minmax:get(value, 'sell'))
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
        :add({private:getName(), 'buy'}, function (value)
            private:setPrice(_base:get('helper'):getNumber(value))
        end)
        :add({private:getName(), 'sell'}, function (value)
            private:setCount(_base:get('helper'):getNumber(value))
        end)
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onCreateProduct',
            function (product)
                if this:isActive() and _base:get('playerManager'):isShoping() and product:isVC() then
                    product:changePrice(product:getPrice() * private:getBuy())
                end
            end,
            1000
        )
        return private
    end

    return private:init()
end
return class