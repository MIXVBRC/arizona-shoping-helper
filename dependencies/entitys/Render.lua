local class = {}
function class:new()
    local public = {}
    local private = {
        ['renders'] = {},
    }

    -- RENDERS

    function private:getRenders()
        return private.renders
    end

    function private:setRenders(renders)
        private.renders = renders
        return public
    end

    -- LOGICK

    function private:push(name, ...)
        table.insert(private.renders, {
            ['name'] = name,
            ['params'] = {...},
        })
        return public
    end

    function public:pushPoint(...)
        private:push('point', ...)
    end

    function public:pushLine(...)
        private:push('line', ...)
    end

    function public:pushBox(...)
        private:push('box', ...)
    end

    function public:pushText(...)
        private:push('text', ...)
    end

    -- WORK

    function private:work()
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

    -- INITS

    function private:init()
        private:initThreads()
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    private:work()
                end
            end
        )
    end

    private:init()
    return public
end
return class