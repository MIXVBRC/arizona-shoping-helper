local class = {}
function class:new(_base, _id)
    local this = {}
    local private = {
        ['text3d'] = _base:getNew('text3d', _id),
    }

    -- PARAMS

    function private:getText3d()
        return private.text3d
    end

    function this:getPlayerName()
        return private:getText3d():getText():match('^(.+)%s{%w%w%w%w%w%w}.+{%w%w%w%w%w%w}.+$')
    end

    function this:getMod()
        return private:getText3d():getText():match('^.+{%w%w%w%w%w%w}(.+){%w%w%w%w%w%w}.+$')
    end

    function this:getPosition()
        return private:getText3d():getPosition()
    end

    function this:getX()
        return private:getText3d():getX()
    end

    function this:getY()
        return private:getText3d():getY()
    end

    function this:getZ()
        return private:getText3d():getZ()
    end

    -- DESTRUCTOR

    function this:__destructor()
        private:getText3d():delete()
    end

    -- INITS

    function private:init()
        if private:getText3d() ~= nil then
            _base:getNew('destructorTrait', this)
            return this
        end
        return nil
    end

    return private:init()
end
return class