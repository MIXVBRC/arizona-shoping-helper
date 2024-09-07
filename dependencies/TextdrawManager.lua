local class = {}
function class:new()
    local public = {}
    local private = {
        ['textdraws'] = {},
        ['idLinks'] = {},
        ['all'] = {},
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- TEXTDRAWS

    function public:getTextdraws()
        return private.textdraws or {}
    end

    function private:setTextdraws(textdraws)
        private.textdraws = textdraws or {}
        return public
    end

    function public:getTextdrawById(id)
        for _, textdraw in ipairs(public:getTextdraws()) do
            if id == textdraw:getId() then
                return textdraw
            end
        end
        return nil
    end

    -- LOGICK

    function private:pushDeleteTextdrawsEvent(textdraws)
        if #textdraws > 0 then
            for _, textdraw in ipairs(textdraws) do
                _sh.eventManager:trigger('onDeleteÑlickableTextdraw', textdraw)
            end
        end
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
            function (id, data)
                local newTextdraw = _sh.dependencies.textdraw:new(
                    id,
                    data.modelId,
                    data.text,
                    data.backgroundColor,
                    data.selectable,
                    data.position.x,
                    data.position.y,
                    data.lineWidth,
                    data.lineHeight
                )
                local textdraws = {}
                local deleteTextdraws = {}
                if #public:getTextdraws() > 0 then
                    for _, textdraw in ipairs(public:getTextdraws()) do
                        if newTextdraw:getId() == textdraw:getId()
                        or (newTextdraw:getX() == textdraw:getX() and newTextdraw:getY() == textdraw:getY())
                        then
                            table.insert(deleteTextdraws, textdraw)
                        else
                            table.insert(textdraws, textdraw)
                            if textdraw:getX() < newTextdraw:getX()
                            and textdraw:getY() < newTextdraw:getY()
                            and textdraw:getX() + textdraw:getWidth() > newTextdraw:getX()
                            and textdraw:getY() + textdraw:getHeight() > newTextdraw:getY()
                            then
                                textdraw:addChild(newTextdraw)
                                _sh.eventManager:trigger('onTextdrawAddChild', textdraw)
                            end
                        end
                    end
                end
                if newTextdraw:isSelectable() then
                    table.insert(textdraws, newTextdraw)
                end
                private:pushDeleteTextdrawsEvent(deleteTextdraws)
                private:setTextdraws(textdraws)
                _sh.eventManager:trigger('onCreateTextdraw', newTextdraw)
            end
        )
        _sh.eventManager:add(
            'onTextDrawSetString',
            function (textdrawId, text)
                for _, textdraw in ipairs(public:getTextdraws()) do
                    if textdrawId ~= textdraw:getId() then
                        for _, childTextdraw in ipairs(textdraw:getChilds()) do
                            if textdrawId == childTextdraw:getId() then
                                childTextdraw:setData({
                                    ['text'] = text,
                                })
                                return
                            end
                        end
                    else
                        textdraw:setData({
                            ['text'] = text,
                        })
                        return
                    end
                end
            end
        )
    end

    function private:initThreads()
        _sh.threadManager:add(
            nil,
            function ()
                while true do wait(0)
                    local textdraws = {}
                    local deleteTextdraws = {}
                    for _, textdraw in ipairs(public:getTextdraws()) do
                        if sampTextdrawIsExists(textdraw:getId()) then
                            table.insert(textdraws, textdraw)
                        else
                            table.insert(deleteTextdraws, textdraw)
                        end
                    end
                    if #deleteTextdraws > 0 then
                        private:setTextdraws(textdraws)
                        private:pushDeleteTextdrawsEvent(deleteTextdraws)
                    end
                end
            end
        )
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
        --                     )
        --                     for _, childTextdraw in ipairs(textdraw:getChilds()) do
        --                         renderDrawBoxWithBorder(
        --                             childTextdraw:getX(),
        --                             childTextdraw:getY(),
        --                             childTextdraw:getWidth(),
        --                             childTextdraw:getHeight(),
        --                             '0x00ffffff',
        --                             1,
        --                             '0xff0000ff'
        --                         )
        --                     end
        --                 end
        --             end
        --         end
        --     end
        -- )
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do wait(0)
        --             for _, textdraw in ipairs(public:getTextdraws()) do
        --                 renderDrawBoxWithBorder(
        --                     textdraw:getX(),
        --                     textdraw:getY(),
        --                     textdraw:getWidth(),
        --                     textdraw:getHeight(),
        --                     '0x00ffffff',
        --                     1,
        --                     _sh.color:getAlpha(50)..'ffffff'
        --                 )
        --             end
        --         end
        --     end
        -- )
        -- _sh.threadManager:add(
        --     nil,
        --     function ()
        --         while true do wait(1000)
        --             _sh.chat:push(#public:getTextdraws())
        --         end
        --     end
        -- )
    end

    private:init()
    return public
end
return class