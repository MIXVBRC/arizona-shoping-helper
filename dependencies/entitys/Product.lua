local class = {}
function class:new(base, _name, _code, _price, _textdraw)
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

    function this:getCode()
        return private.code
    end

    function this:isScanned()
        if this:getName() ~= nil then
            return true
        end
        return false
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

    function private:init()
        private:initThreads()
        return this
    end

    function private:initThreads()
        base:getClass('threadManager'):add(
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