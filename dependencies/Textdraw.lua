local class = {}
function class:new(_id, _model, _text, _color, _selectable, _x, _y, _width, _height)
    local public = {}
    local private = {
        ['id'] = _id,
        ['model'] = _model,
        ['text'] = _text,
        ['color'] = _color,
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
        ['code'] = _sh.helper:md5(_model .. _text .. _color),
    }

    function public:getId()
        return private.id
    end

    function public:getModel()
        return private.model
    end

    function public:getText()
        return private.text
    end

    function public:getColor()
        return private.color
    end

    function public:isSelectable()
        return private.selectable
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

    function private:setX(x)
        private.position.x = x
        return public
    end

    function private:setY(y)
        private.position.y = y
        return public
    end

    function public:getSize()
        return private.size
    end

    function public:getWidth()
        return public:getSize().width
    end

    function public:getHeight()
        return public:getSize().height
    end

    function private:setWidth(width)
        public:getSize().width = width
        return public
    end

    function private:setHeight(height)
        public:getSize().height = height
        return public
    end

    function public:getTime()
        return private.time
    end

    function public:getChilds()
        return private.childs
    end

    function public:addChild(textdraw)
        textdraw:setParent(public)
        table.insert(private.childs, textdraw)
        return public
    end

    function public:getParent()
        return private.parent
    end

    function public:getCode()
        return private.code
    end

    function private:setCode(code)
        private.code = code
        return public
    end

    function public:setParent(textdraw)
        private.parent = textdraw
        private:setX(textdraw:getX() + 1)
        private:setY(textdraw:getY() + 1)
        private:setWidth(textdraw:getWidth() - 2)
        private:setHeight(textdraw:getHeight() - 2)
        return public
    end

    function private:init()
        private.position.x, private.position.y = convertGameScreenCoordsToWindowScreenCoords(public:getX(), public:getY())
        private.size.width, private.size.height = convertGameScreenCoordsToWindowScreenCoords(public:getWidth(), public:getHeight())
        if private.selectable == 1 then private.selectable = true else private.selectable = false end
    end

    private:init()
    return public
end
return class