local class = {}
function class:new()
    local public = {}
    local private = {
        ['boxes'] = {},
    }

    -- BOXES

    function private:getBoxes()
        return private.boxes
    end

    function private:setBoxes(boxes)
        private.boxes = boxes
        return public
    end

    function private:getBox(code)
        return private.boxes[code]
    end

    function private:addBox(box)
        private.boxes[box.code] = box
        return public
    end

    -- LOGIC

    function public:push(x, y, width, height, background, borderWidth, borderColor, sort)
        local box = {
            ['code'] = _sh.helper:md5(x..y..width..height),
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
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    for _, box in pairs(private:getBoxes()) do
                        _sh.render:pushBox(
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
    return public
end
return class