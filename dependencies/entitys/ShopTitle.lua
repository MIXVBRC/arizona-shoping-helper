local class = {}
function class:new(_base, _id)
    local this = {}
    local private = {
        ['text3d'] = _base:getNew('text3d', _id),
    }

    -- PARAMS

    function this:getText3d()
        return private.text3d
    end

    function this:getPlayerName()
        return this:getText3d():getText():match('^(.+)%s{%w%w%w%w%w%w}.+{%w%w%w%w%w%w}.+$')
    end

    function this:getMod()
        return this:getText3d():getText():match('^.+{%w%w%w%w%w%w}(.+){%w%w%w%w%w%w}.+$')
    end

    function this:getPosition()
        return this:getText3d():getPosition()
    end

    function this:getX()
        return this:getText3d():getX()
    end

    function this:getY()
        return this:getText3d():getY()
    end

    function this:getZ()
        return this:getText3d():getZ()
    end

    -- DESTRUCTOR

    function this:__destructor()
        this:getText3d():delete()
    end

    -- INITS

    function private:init()
        if this:getText3d() ~= nil then
            _base:getNew('destructorTrait', this)
            return this
        end
        return nil
    end

    return private:init()
end
return class