local class = {}
function class:new(_base, _id, _model, _text, _color, _selectable, _x, _y, _width, _height)
    local this = {}
    local private = {
        ['id'] = _id,
        ['model'] = _model,
        ['text'] = _text,
        ['color'] = _color,
        ['code'] = _base:get('helper'):md5(_model .. _text .. _color),
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
        return private
    end

    function private:setY(y)
        private.position.y = y
        return private
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
        return private
    end

    function private:setHeight(height)
        this:getSize().height = height
        return private
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

    -- PARENT

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

    -- EXECUTE AFTER EXIST

    function private:executeAfterExist(_execute)
        if not sampTextdrawIsExists(this:getId()) then
            _base:get('queueManager')
            :add(
                function ()
                    while true do
                        if sampTextdrawIsExists(this:getId()) then
                            _execute()
                            break
                        end
                        wait(0) -- faster if after break while
                    end
                end,
                1
            )
            :push()
        else
            _execute()
        end
    end

    -- CHANGE TEXT

    function this:changeText(text)
        private:executeAfterExist(function ()
            sampTextdrawSetString(this:getId(), text)
        end)
    end

    -- LOGIC

    function this:setData(data)
        if data ~= nil then
            _base:get('eventManager'):trigger('onBeforeChangeTextdraw', this, data)
            for name, value in pairs(data) do
                private[name] = value
            end
            _base:get('eventManager'):trigger('onAfterChangeTextdraw', this, data)
        end
        return this
    end

    

    -- INITS

    function private:init()
        private.position.x, private.position.y = convertGameScreenCoordsToWindowScreenCoords(this:getX(), this:getY())
        private.size.width, private.size.height = convertGameScreenCoordsToWindowScreenCoords(this:getWidth(), this:getHeight())
        if private.selectable == 1 then private.selectable = true else private.selectable = false end
        return this
    end

    return private:init()
end
return class