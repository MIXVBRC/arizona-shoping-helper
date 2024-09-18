local class = {}
function class:new(_base, _id, _windowId, _titleId, _adminId)
    local this = {}
    local private = {
        ['id'] = _id,
        ['position'] = {
            ['x'] = 0,
            ['y'] = 0,
            ['z'] = 0,
        },
        ['empty'] = true,
        ['central'] = false,
        ['window'] = _base:getNew('shopWindow', _windowId),
        ['title'] = _base:getNew('shopTitle', _titleId),
        ['admin'] = _base:getNew('shopAdmin', _adminId),
    }

    -- PARAMS

    function this:getId()
        return private.id
    end

    function this:getPosition()
        return this:getWindow():getPosition()
    end

    function this:getX()
        return this:getWindow():getX()
    end

    function this:getY()
        return this:getWindow():getY()
    end

    function this:getZ()
        return this:getWindow():getZ()
    end

    function this:getPlayerName()
        if this:getTitle() ~= nil then
            return this:getTitle():getPlayerName()
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

    function this:isCentral()
        return private.central
    end

    function this:getWindow()
        return private.window
    end

    function this:getTitle()
        return private.title
    end

    function this:getAdmin()
        return private.admin
    end

    -- INITS

    function private:init()
        if this:getWindow() ~= nil then
            private:initEmpty():initCentral()
            _base:getNew('destructorTrait', this)
            return this
        end
        return nil
    end

    function private:initEmpty()
        if private.title ~= nil then
            private.empty = false
        end
        return private
    end

    function private:initCentral()
        local cacheKey = 'shop_' .. _base:get('helper'):md5(this:getX()..this:getY()..this:getZ())
        if _base:get('cache'):get(cacheKey) == nil then
            for _, object in ipairs(_base:get('helper'):getObjects(_base:get('shopManager'):getCentralModelIds())) do
                local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    this:getX(), this:getY(), this:getZ(),
                    objectX, objectY, objectZ
                )
                if distance < 3 then
                    private.central = true
                    _base:get('cache'):add(cacheKey, true)
                end
            end
        else
            private.central = true
        end
        return private
    end

    return private:init()
end
return class