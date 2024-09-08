local class = {}
function class:new(_x, _y, _z, _title, _admin)
    local public = {}
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
        ['centralModelIds'] = {
            3861,
            14211,
            14210,
        },
    }

    function public:getId()
        return private.id
    end

    function private:setId(id)
        private.id = id
        return public
    end

    function public:getPosition()
        return private.position
    end

    function public:getX()
        return public:getPosition().x
    end

    function public:getY()
        return public:getPosition().y
    end

    function public:getZ()
        return public:getPosition().z
    end

    function private:setPosition(position)
        private.position = position
        return public
    end

    function public:getPlayer()
        if public:getTitle() ~= nil then
            return public:getTitle():getPlayer()
        end
        return 'none'
    end

    function public:getMod()
        if public:getTitle() ~= nil then
            return public:getTitle():getMod()
        end
        return _sh.message:get('message_shop_empty')
    end

    function public:isEmpty()
        return private.empty
    end

    function private:setEmpty(bool)
        private.empty = bool
        return public
    end

    function public:isCentral()
        return private.central
    end

    function private:setCentral(bool)
        private.central = bool
        return public
    end

    function public:getTitle()
        return private.title
    end

    function public:getAdmin()
        return private.admin
    end

    function private:init()
        private:setPosition(_sh.helper:normalizePosition(public:getX(), public:getY(), public:getZ()))
        private:setId(_sh.helper:md5(public:getPlayer()..public:getX()..public:getY()..public:getZ()))
        if public:getTitle() ~= nil then
            private:setEmpty(false)
        end
        local cacheKey = 'shop_' .. _sh.helper:md5(public:getX()..public:getY()..public:getZ())
        if _sh.cache:get(cacheKey) == nil then
            for _, object in ipairs(_sh.helper:getObjectsByIds(private.centralModelIds)) do
                local _, objectX, objectY, objectZ = getObjectCoordinates(object)
                local distance = getDistanceBetweenCoords3d(
                    public:getX(), public:getY(), public:getZ(),
                    objectX, objectY, objectZ
                )
                if distance < 3 then
                    private:setCentral(true)
                    _sh.cache:add(cacheKey, true)
                end
            end
        else
            private:setCentral(true)
        end
    end

    private:init()
    return public
end
return class