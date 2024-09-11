local class = {}
function class:new(_base, _id, _model, _text, _color, _selectable, _x, _y, _width, _height)
    local this = {}
    local private = {
        ['id'] = _id,
        ['model'] = _model,
        ['text'] = _text,
        ['color'] = _color,
        ['code'] = _base:getClass('helper'):md5(_model .. _text .. _color),
        ['selectable'] = _selectable,
        ['position'] = {
            ['x'] = _x,
            ['y'] = _y,
        },
        ['size'] = {
            ['width'] = _width,
            ['height'] = _height,
        },
        ['childs'] = {},
        ['parent'] = nil,
        ['time'] = os.clock(),
    }

    -- ID

    function this:getId()
        return private.id
    end

    -- MODEL

    function this:getModel()
        return private.model
    end

    -- TEXT

    function this:getText()
        return private.text
    end

    -- COLOR

    function this:getColor()
        return private.color
    end

    -- CODE

    function this:getCode()
        return private.code
    end

    -- SELECTABLE

    function this:isSelectable()
        return private.selectable
    end

    -- POSITION

    function this:getPosition()
        return private.position
    end

    function this:getX()
        return this:getPosition().x
    end

    function this:getY()
        return this:getPosition().y
    end

    function private:setX(x)
        private.position.x = x
        return this
    end

    function private:setY(y)
        private.position.y = y
        return this
    end

    -- SIZE

    function this:getSize()
        return private.size
    end

    function this:getWidth()
        return this:getSize().width
    end

    function this:getHeight()
        return this:getSize().height
    end

    function private:setWidth(width)
        this:getSize().width = width
        return this
    end

    function private:setHeight(height)
        this:getSize().height = height
        return this
    end

    -- TIME

    function this:getTime()
        return private.time
    end

    -- CLILDS

    function this:getChilds()
        return private.childs
    end

    function this:addChild(textdraw)
        textdraw:setParent(this)
        table.insert(private.childs, textdraw)
        return this
    end

    -- PAREND

    function this:getParent()
        return private.parent
    end

    function this:setParent(textdraw)
        private.parent = textdraw
        private:setX(textdraw:getX() + 1)
        private:setY(textdraw:getY() + 1)
        private:setWidth(textdraw:getWidth() - 2)
        private:setHeight(textdraw:getHeight() - 2)
        return this
    end

    -- LOGIC

    function this:setData(data)
        if data ~= nil then
            _base:getClass('eventManager'):trigger('onBeforeChangeTextdraw', this, data)
            for name, value in pairs(data) do
                private[name] = value
            end
            _base:getClass('eventManager'):trigger('onAfterChangeTextdraw', this, data)
        end
        return this
    end

    -- INITS

    function private:init()
        private.position.x, private.position.y = convertGameScreenCoordsToWindowScreenCoords(this:getX(), this:getY())
        private.size.width, private.size.height = convertGameScreenCoordsToWindowScreenCoords(this:getWidth(), this:getHeight())
        if private.selectable == 1 then private.selectable = true else private.selectable = false end
    end

    private:init()
    return this
end
return class