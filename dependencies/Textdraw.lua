local class = {}
function class:new(_id, _model, _text, _color, _position)
    local public = {}
    local private = {
        ['id'] = _id,
        ['model'] = _model,
        ['text'] = _text,
        ['color'] = _color,
        ['position'] = _position,
        ['time'] = os.clock(),
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

    function public:getPosition()
        return private.position
    end

    function public:getX()
        return public:getPosition().x
    end

    function public:getY()
        return public:getPosition().y
    end

    function public:getTime()
        return private.time
    end

    function public:setText(text)
        private.text = text
        return public
    end

    return public
end
return class