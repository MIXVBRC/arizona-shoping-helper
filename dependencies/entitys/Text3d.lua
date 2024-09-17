local class = {}
function class:new(_base, _id, _text, _alpha, _color, _x, _y, _z, _distance, _xray, _player, _car)
    local this = {}
    local private = {
        ['id'] = _id,
        ['text'] = _text or '',
        ['alpha'] = _alpha or '0xff',
        ['color'] = _color or 'ffffff',
        ['position'] = {
            ['x'] = _x or 0,
            ['y'] = _y or 0,
            ['z'] = _z or 0,
        },
        ['distance'] = _distance or 100,
        ['xray'] = _xray or false,
        ['player'] = _player or -1,
        ['car'] = _car or -1,
        ['delete'] = false,
    }

    -- ID

    function this:getId()
        return private.id
    end

    function private:setId(id)
        private.id = id
        return private
    end

    -- TEXT

    function this:getText()
        return private.text
    end

    function this:setText(text)
        private.text = text
        return this
    end

    -- ALPHA

    function this:getAlpha()
        return private.alpha
    end

    function this:setAlpha(alpha)
        private.alpha = alpha
        return this
    end

    -- COLOR

    function this:getColor()
        return private.color
    end

    function this:setColor(color)
        private.color = color
        return this
    end

    -- FULL COLOR

    function this:getColotFull()
        return private.alpha .. private.color
    end

    -- POSITION

    function this:getPosition()
        return private.position
    end

    function this:getX()
        return this:getPosition().x
    end

    function this:setX(x)
        this:getPosition().x = x
        return this
    end

    function this:getY()
        return this:getPosition().y
    end

    function this:setY(y)
        this:getPosition().y = y
        return this
    end

    function this:getZ()
        return this:getPosition().z
    end

    function this:setZ(z)
        this:getPosition().z = z
        return this
    end

    -- DISTANCE

    function this:getDistance()
        return private.distance
    end

    function this:setDistance(distance)
        private.distance = distance
        return this
    end

    -- XRAY

    function this:getXray()
        return private.xray
    end

    function this:setXray(bool)
        private.xray = bool
        return this
    end

    -- PLAYER

    function this:getPlayer()
        return private.player
    end

    function this:setPlayer(id)
        private.player = id
        return this
    end

    -- CAR

    function this:getCar()
        return private.car
    end

    function this:setCar(car)
        private.car = car
        return this
    end

    -- DELETE

    function this:isDelete()
        return private.delete
    end

    function this:delete()
        sampDestroy3dText(this:getId())
        return nil
    end

    -- DESTRUCTOR

    function this:__destructor()
        _base:get('chat'):push('distruct: ' .. this:getText())
        this:delete()
    end

    -- UPDATE

    function this:update()
        if not this:isDelete() then
            sampCreate3dTextEx(
                this:getId(),
                this:getText(),
                this:getColotFull(),
                this:getX(),
                this:getY(),
                this:getZ(),
                this:getDistance(),
                this:getXray(),
                this:getPlayer(),
                this:getCar()
            )
        end
        return this
    end

    -- INITS

    function private:init()
        private:initTraits():initObject()
        return this
    end

    function private:initTraits()
        _base:getNew('destructorTrait', this)
        return private
    end

    function private:initObject()
        if this:getId() ~= nil then
            local text, alpha_color, x, y, z, distance, xray, player, car = sampGet3dTextInfoById(this:getId())
            this
            :setText(text)
            :setAlpha(alpha_color:match('^(0x%w%w)%w%w%w%w%w%w$'))
            :setColor(alpha_color:match('^0x%w%w(%w%w%w%w%w%w$)'))
            :setX(x)
            :setY(y)
            :setZ(z)
            :setDistance(distance)
            :setXray(xray)
            :setPlayer(player)
            :setCar(car)
        else
            private:setId(
                sampCreate3dText(
                    this:getText(),
                    this:getColotFull(),
                    this:getX(),
                    this:getY(),
                    this:getZ(),
                    this:getDistance(),
                    this:getXray(),
                    this:getPlayer(),
                    this:getCar()
                )
            )
        end
        return private
    end

    return private:init()
end
return class