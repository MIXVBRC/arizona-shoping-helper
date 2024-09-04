local class = {}
function class:new()
    local public = {}
    local private = {
        ['textdraws'] = {},
        ['textdrawQueue'] = {},
    }

    -- TEXTDRAW

    function public:getTextdraws()
        return private.textdraws
    end

    function private:addTextdraw(textdraw)
        table.insert(private.textdraws[textdraw:getId()], textdraw)
        return public
    end

    function private:getTextdraw(id)
        return private.textdraws[id]
    end

    function private:clearTextdraws()
        private.textdraws = {}
        return public
    end

    -- TEXTDRAW QUEUE

    function public:getTextdrawQueue()
        return private.textdrawQueue
    end

    function public:addToTextdrawQueue(textdraw)
        table.insert(private.textdrawQueue, textdraw)
        return public
    end

    -- INITS

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add('onShowTextDraw', function (textdrawId, textdraw)
            private:addToTextdrawQueue(_sh.dependencies.textdraw:new(
                textdrawId,
                textdraw.modelId,
                textdraw.text,
                textdraw.backgroundColor,
                textdraw.position
            ))
        end)
        _sh.eventManager:add('onTextDrawSetString', function (textdrawId, text)
            private:getTextdraw(textdrawId):setText(text)
        end)
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    for _, textdraw in ipairs(public:getTextdrawQueue()) do
                        
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class