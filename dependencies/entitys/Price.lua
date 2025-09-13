local class = {}
function class:new(_base, textdrawClass)
    local this = {}
    local private = {
        ['value'] = 0,
        ['textdraw'] = textdrawClass,
        ['vc'] = false,
    }

    -- GET

    function this:get()
        return private.value
    end

    -- SET

    function private:set(price)
        private.value = price
        return this
    end

    -- TEXTDRAW

    function private:getTextdraw()
        return private.textdraw
    end

    -- VC

    function this:isVC()
        return private.vc
    end

    function private:setVC(bool)
        private.vc = bool
        return private
    end

    -- CHANGE

    function this:change(price)
        if price > 0 then
            private:set(price)
            private:getTextdraw():changeText(_base:get('helper'):formatPrice(this:get()))
        else
            _base:getNew('error', _base:getNew('message'):get('exception_zero_price'))
        end
        return this
    end

    --INIT

    function private:init()
        local value = private:getTextdraw():getText()
        private:set(_base:get('helper'):extractPrice(value))
        private:setVC(_base:get('helper'):isVCPrice(value))
        -- this:change(this:get())
        return this
    end

    return private:init()
end
return class