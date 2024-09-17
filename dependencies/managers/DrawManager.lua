local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['draws'] = {},
    }

    -- DRAWS

    function private:getDraws()
        return private.draws
    end

    function private:setDraws(draws)
        private.draws = draws
        return private
    end

    function private:getDraw(code)
        return private.draws[code]
    end

    function private:addDraw(draw)
        if private.draws[draw.code] == nil or private.draws[draw.code].sort > draw.sort then
            private.draws[draw.code] = draw
        end
        return private
    end

    -- ADD BOX

    function this:addBox(x, y, width, height, background, borderWidth, borderColor, sort)
        private:addDraw({
            ['type'] = 'box',
            ['code'] = _base:get('helper'):md5('box'..x..y..width..height),
            ['x'] = x,
            ['y'] = y,
            ['width'] = width,
            ['height'] = height,
            ['background'] = background,
            ['borderWidth'] = borderWidth,
            ['borderColor'] = borderColor,
            ['sort'] = sort,
        })
        return this
    end

    -- ADD TEXT

    function this:addText(font, text, x, y, color, sort)
        private:addDraw({
            ['type'] = 'text',
            ['code'] = _base:get('helper'):md5('text'..x..y),
            ['font'] = font,
            ['text'] = text,
            ['x'] = x,
            ['y'] = y,
            ['color'] = color,
            ['sort'] = sort,
        })
        return this
    end

    -- DRAW

    function private:draw()
        for _, draw in pairs(private:getDraws()) do
            if draw.type == 'box' then
                _base:get('renderManager'):pushBox(
                    draw.x,
                    draw.y,
                    draw.width,
                    draw.height,
                    draw.background,
                    draw.borderWidth,
                    draw.borderColor
                )
            elseif draw.type == 'text' then
                _base:get('renderManager'):pushText(
                    draw.font,
                    draw.text,
                    draw.x,
                    draw.y,
                    draw.color
                )
            end
        end
        private:setDraws({})
        return private
    end

    -- INITS

    function private:init()
        private:initThreads()
        return this
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    private:draw()
                end
            end
        )
        return private
    end

    return private:init()
end
return class