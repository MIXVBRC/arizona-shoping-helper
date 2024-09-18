local class = {}
function class:new(_base, _window, _title, _admin)
    local this = {}
    local private = {
        ['id'] = nil,
        ['position'] = {
            ['x'] = 0,
            ['y'] = 0,
            ['z'] = 0,
        },
        ['empty'] = true,
        ['central'] = false,
        ['window'] = _window,
        ['title'] = _title,
        ['admin'] = _admin,
    }

    -- PARAMS

    function this:getId()
        return private.id
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
        if private.window ~= nil then
            private:initWindow():initTitle():initAdmin():initPosition():initId():initCentral()
            _base:getNew('destructorTrait', this)
            return this
        end
        return nil
    end

    function private:initWindow()
        private.window = _base:getNew('shopWindow', private.window)
        if private.window ~= nil then
            private.position.x = private.position.x + private.window:getX()
            private.position.y = private.position.y + private.window:getY()
            private.position.z = private.position.z + private.window:getZ()
        end
        return private
    end

    function private:initTitle()
        if private.title ~= nil then
            private.title = _base:getNew('shopTitle', private.title)
            if private.title ~= nil then
                private.position.x = private.position.x + private.title:getX()
                private.position.y = private.position.y + private.title:getY()
                private.position.z = private.position.z + private.title:getZ()
                private.empty = false
            end
        end
        return private
    end

    function private:initAdmin()
        if private.admin ~= nil then
            private.admin = _base:getNew('shopAdmin', private.admin)
            if private.admin ~= nil then
                private.position.x = private.position.x + private.admin:getX()
                private.position.y = private.position.y + private.admin:getY()
                private.position.z = private.position.z + private.admin:getZ()
            end
        end
        return private
    end

    function private:initPosition()
        local num = 0
        for _, value in ipairs({private.window, private.title, private.admin}) do
            if value ~= nil then
                num = num + 1
            end
        end
        if num > 0 then
            private.position = _base:get('helper'):normalizePosition(
                private.position.x / num,
                private.position.y / num,
                private.position.z / num
            )
        end
        return private
    end

    function private:initId()
        private.id = _base:get('helper'):md5(this:getPlayerName()..this:getX()..this:getY()..this:getZ())
        return private
    end

    function private:initCentral()
        local cacheKey = 'shop_' .. _base:get('helper'):md5(this:getX()..this:getY()..this:getZ())
        if _base:get('cache'):get(cacheKey) == nil then
            for _, object in ipairs(_base:get('helper'):getObjectsByIds(_base:get('shopManager'):getCentralModelIds())) do
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