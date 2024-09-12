local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['boxes'] = {},
    }

    -- BOXES

    function private:getBoxes()
        return private.boxes
    end

    function private:setBoxes(boxes)
        private.boxes = boxes
        return this
    end

    function private:getBox(code)
        return private.boxes[code]
    end

    function private:addBox(box)
        private.boxes[box.code] = box
        return this
    end

    -- LOGIC

    function this:push(x, y, width, height, background, borderWidth, borderColor, sort)
        local box = {
            ['code'] = _base:get('helper'):md5(x..y..width..height),
            ['x'] = x,
            ['y'] = y,
            ['width'] = width,
            ['height'] = height,
            ['background'] = background,
            ['borderWidth'] = borderWidth,
            ['borderColor'] = borderColor,
            ['sort'] = sort,
        }
        if private:getBox(box.code) == nil or private:getBox(box.code).sort > box.sort then
            private:addBox(box)
        end
    end

    -- INITS

    function private:init()
        private:initThreads()
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    for _, box in pairs(private:getBoxes()) do
                        _base:get('renderManager'):pushBox(
                            box.x,
                            box.y,
                            box.width,
                            box.height,
                            box.background,
                            box.borderWidth,
                            box.borderColor
                        )
                    end
                    private:setBoxes({})
                end
            end
        )
    end

    private:init()
    return this
end
return class