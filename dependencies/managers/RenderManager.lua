local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['renders'] = {},
    }

    -- RENDERS

    function private:getRenders()
        return private.renders
    end

    function private:setRenders(renders)
        private.renders = renders
        return this
    end

    -- LOGICK

    function private:push(name, ...)
        table.insert(private.renders, {
            ['name'] = name,
            ['params'] = {...},
        })
        return this
    end

    function this:pushPoint(...)
        private:push('point', ...)
    end

    function this:pushLine(...)
        private:push('line', ...)
    end

    function this:pushBox(...)
        private:push('box', ...)
    end

    function this:pushText(...)
        private:push('text', ...)
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
                    if #private:getRenders() > 0 then
                        for _, render in ipairs(private:getRenders()) do
                            if render.name == 'point' then
                                renderDrawPolygon(table.unpack(render.params))
                            elseif render.name == 'line' then
                                renderDrawLine(table.unpack(render.params))
                            elseif render.name == 'box' then
                                renderDrawBoxWithBorder(table.unpack(render.params))
                            elseif render.name == 'text' then
                                renderFontDrawText(table.unpack(render.params))
                            end
                        end
                        private:setRenders({})
                    end
                end
            end
        )
    end

    private:init()
    return this
end
return class