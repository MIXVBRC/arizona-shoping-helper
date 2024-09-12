local class = {}
function class:new(_base, _x, _y, _z, _title, _admin)
    local this = {}
    local private = {
        ['id'] = nil,
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['empty'] = true,
        ['central'] = false,
        ['title'] = _title,
        ['admin'] = _admin,
    }

    function this:getId()
        return private.id
    end

    function private:setId(id)
        private.id = id
        return this
    end

    function this:getPosition()
        return private.position
    end

    function this:getX()
        return this:getPosition().x
    end

    function this:getY()
        return this:getPosition().y
    end

    function this:getZ()
        return this:getPosition().z
    end

    function private:setPosition(position)
        private.position = position
        return this
    end

    function this:getPlayer()
        if this:getTitle() ~= nil then
            return this:getTitle():getPlayer()
        end
        return 'none'
    end

    function this:getMod()
        if this:getTitle() ~= nil then
            return this:getTitle():getMod()
        end
        return _base:get('message'):get('system_shop_empty')
    end

    function this:isEmpty()
        return private.empty
    end

    function private:setEmpty(bool)
        private.empty = bool
        return this
    end

    function this:isCentral()
        return private.central
    end

    function private:setCentral(bool)
        private.central = bool
        return this
    end

    function this:getTitle()
        return private.title
    end

    function this:getAdmin()
        return private.admin
    end

    function private:init()
        private:setPosition(_base:get('helper'):normalizePosition(this:getX(), this:getY(), this:getZ()))
        private:setId(_base:get('helper'):md5(this:getPlayer()..this:getX()..this:getY()..this:getZ()))
        if this:getTitle() ~= nil then
            private:setEmpty(false)
        end
        local cacheKey = 'shop_' .. _base:get('helper'):md5(this:getX()..this:getY()..this:getZ())
        if _base:get('cache'):get(cacheKey) == nil then
            for _, object in ipairs(_base:get('helper'):getObjectsByIds(_base:get('shopManager'):getCentralModelIds())) do
                local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    this:getX(), this:getY(), this:getZ(),
                    objectX, objectY, objectZ
                )
                if distance < 3 then
                    private:setCentral(true)
                    _base:get('cache'):add(cacheKey, true)
                end
            end
        else
            private:setCentral(true)
        end
    end

    private:init()
    return this
end
return class