local class = {}
function class:new()
    local public = {}
    local private = {
        ['textdraws'] = {},
        ['queueTextdraws'] = {},
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- TEXTDRAW

    function public:getTextdraws()
        return private.textdraws
    end

    function private:setTextdraws(textdraws)
        private.textdraws = textdraws
        return public
    end

    function private:addTextdraw(textdraw)
        table.insert(private.textdraws, textdraw)
        return public
    end

    function private:clearTextdraws()
        private.textdraws = {}
        return public
    end

    -- TEXTDRAW QUEUE

    function private:getQueueTextdraws()
        return private.queueTextdraws
    end

    function private:setQueueTextdraws(textdraws)
        private.queueTextdraws = textdraws
        return public
    end

    function private:addQueueTextdraws(textdraw)
        table.insert(private.queueTextdraws, textdraw)
        return public
    end

    -- INITS

    function private:init()
        private:initEvents()
        private:initThreads()
    end

    function private:initEvents()
        _sh.eventManager:add('onShowTextDraw', function (textdrawId, textdraw)
            private:addQueueTextdraws(_sh.dependencies.textdraw:new(
                textdrawId,
                textdraw.modelId,
                textdraw.text,
                textdraw.backgroundColor,
                textdraw.selectable,
                textdraw.position,
                {
                    ['width'] = textdraw.lineWidth,
                    ['height'] = textdraw.lineHeight,
                }
            ))
        end)
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local queueTextdraws = private:getQueueTextdraws()
                    if #queueTextdraws > 0 then
                        local textdraws = {}
                        local newTextdraws = {}
                        local clildTextdraws = {}
                        for _, textdraw in ipairs(queueTextdraws) do
                            if textdraw:isSelectable() then
                                table.insert(newTextdraws, textdraw)
                            else
                                table.insert(clildTextdraws, textdraw)
                            end
                        end
                        for _, newTextdraw in ipairs(newTextdraws) do
                            for _, clildTextdraw in ipairs(clildTextdraws) do
                                if newTextdraw:getX() < clildTextdraw:getX()
                                and newTextdraw:getY() < clildTextdraw:getY()
                                and newTextdraw:getX() + newTextdraw:getWidth() > clildTextdraw:getX()
                                and newTextdraw:getY() + newTextdraw:getHeight() > clildTextdraw:getY()
                                then
                                    newTextdraw:addChild(clildTextdraw)
                                end
                            end
                            table.insert(textdraws, newTextdraw)
                        end
                        for _, oldTextdraw in ipairs(public:getTextdraws()) do
                            for _, newTextdraw in ipairs(newTextdraws) do
                                if oldTextdraw:getX() == newTextdraw:getX() and oldTextdraw:getY() == newTextdraw:getY() then
                                    goto continue
                                end
                            end
                            table.insert(textdraws, oldTextdraw)
                            ::continue::
                        end
                        private:setTextdraws(textdraws)
                        private:setQueueTextdraws({})
                    end
                end
            end
        )
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local textdraws = public:getTextdraws()
                    if #textdraws > 0 then
                        -- for _, textdraw in ipairs(textdraws) do
                            -- local color = '0xffffffff'
                            -- if textdraw:getType() == 'product' then
                            --     color = '0xffff0000'
                            -- end
                            -- renderDrawBoxWithBorder(
                            --     textdraw:getX(),
                            --     textdraw:getY(),
                            --     textdraw:getWidth(),
                            --     textdraw:getHeight(),
                            --     '0x00ffffff',
                            --     1,
                            --     color
                            -- );
                            -- for _, childTextdraw in ipairs(textdraw:getChilds()) do
                            --     renderDrawBoxWithBorder(
                            --         childTextdraw:getX(),
                            --         childTextdraw:getY(),
                            --         childTextdraw:getWidth(),
                            --         childTextdraw:getHeight(),
                            --         '0x00ffffff',
                            --         1,
                            --         '0xff0000ff'
                            --     );
                            -- end
                        -- end
                    end
                end
            end
        )
    end

    private:init()
    return public
end
return class