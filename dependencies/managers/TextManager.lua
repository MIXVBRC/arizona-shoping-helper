local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['texts'] = {},
    }

    -- BOXES

    function private:getTexts()
        return private.texts
    end

    function private:setTexts(texts)
        private.texts = texts
        return this
    end

    function private:getText(code)
        return private.texts[code]
    end

    function private:addText(texts)
        private.texts[texts.code] = texts
        return this
    end

    -- LOGIC

    function this:push(font, text, x, y, color, sort)
        local _text = {
            ['code'] = _base:get('helper'):md5(x..y),
            ['font'] = font,
            ['text'] = text,
            ['x'] = x,
            ['y'] = y,
            ['color'] = color,
            ['sort'] = sort,
        }
        if private:getText(_text.code) == nil or private:getText(_text.code).sort > _text.sort then
            private:addText(_text)
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
                    for _, text in pairs(private:getTexts()) do
                        _base:get('renderManager'):pushText(
                            text.font,
                            text.text,
                            text.x,
                            text.y,
                            text.color
                        )
                    end
                    private:setTexts({})
                end
            end
        )
    end

    private:init()
    return this
end
return class