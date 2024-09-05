local class = {}
function class:new()
    local public = {}
    local private = {
        ['textdraws'] = {},
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

    -- INITS

    function private:init()
        private:initEvents()
        private:initThreads()
    end

    function private:initEvents()
        _sh.eventManager:add(
            'onShowTextDraw',
            function (textdrawId, textdraw)
                local newTextdraw = _sh.dependencies.textdraw:new(
                    textdrawId,
                    textdraw.modelId,
                    textdraw.text,
                    textdraw.backgroundColor,
                    textdraw.selectable,
                    textdraw.position.x,
                    textdraw.position.y,
                    textdraw.lineWidth,
                    textdraw.lineHeight
                )
                local oldTextdraws = public:getTextdraws()
                if newTextdraw:isSelectable() then
                    local newTextdraws = {}
                    for _, oldTextdraw in ipairs(oldTextdraws) do
                        if oldTextdraw:getX() ~= newTextdraw:getX() or oldTextdraw:getY() ~= newTextdraw:getY() then
                            table.insert(newTextdraws, oldTextdraw)
                        end
                    end
                    table.insert(newTextdraws, newTextdraw)
                    private:setTextdraws(newTextdraws)
                else
                    for _, oldTextdraw in ipairs(oldTextdraws) do
                        if oldTextdraw:getX() < newTextdraw:getX()
                        and oldTextdraw:getY() < newTextdraw:getY()
                        and oldTextdraw:getX() + oldTextdraw:getWidth() > newTextdraw:getX()
                        and oldTextdraw:getY() + oldTextdraw:getHeight() > newTextdraw:getY()
                        then
                            oldTextdraw:addChild(newTextdraw)
                        end
                    end
                end
                _sh.eventManager:trigger('onCreateTextdraw', newTextdraw)
            end
        )
        _sh.eventManager:add(
            'onTextDrawSetString',
            function (textdrawId, text)
                local textdraws = public:getTextdraws()
                if #textdraws > 0 then
                    for _, textdraw in ipairs(textdraws) do
                        if textdrawId ~= textdraw:getId() then
                            for _, childTextdraw in ipairs(textdraw:getChilds()) do
                                if textdrawId == childTextdraw:getId() then
                                    childTextdraw:setData({
                                        ['text'] = text,
                                    })
                                    goto breakAll
                                end
                            end
                        else
                            textdraw:setData({
                                ['text'] = text,
                            })
                            goto breakAll
                        end
                    end
                    ::breakAll::
                end
            end
        )
    end

    function private:initThreads()
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do wait(0)
        --             local textdraws = public:getTextdraws()
        --             if #textdraws > 0 then
        --                 for _, textdraw in ipairs(textdraws) do
        --                     renderDrawBoxWithBorder(
        --                         textdraw:getX(),
        --                         textdraw:getY(),
        --                         textdraw:getWidth(),
        --                         textdraw:getHeight(),
        --                         '0x00ffffff',
        --                         1,
        --                         '0xffffffff'
        --                     );
        --                     for _, childTextdraw in ipairs(textdraw:getChilds()) do
        --                         renderDrawBoxWithBorder(
        --                             childTextdraw:getX(),
        --                             childTextdraw:getY(),
        --                             childTextdraw:getWidth(),
        --                             childTextdraw:getHeight(),
        --                             '0x00ffffff',
        --                             1,
        --                             '0xff0000ff'
        --                         );
        --                     end
        --                 end
        --             end
        --         end
        --     end
        -- )
    end

    private:init()
    return public
end
return class