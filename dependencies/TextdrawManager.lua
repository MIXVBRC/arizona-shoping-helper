local class = {}
function class:new()
    local public = {}
    local private = {
        ['textdraws'] = {},
        ['idLinks'] = {},
        ['cache'] = _sh.dependencies.cache:new(),
    }

    -- TEXTDRAWS

    function public:getTextdraws()
        return private.textdraws or {}
    end

    function public:getTextdrawById(id)
        return private.idLinks[id]
    end

    function private:setTextdraws(textdraws)
        textdraws = textdraws or {}
        private.idLinks = {}
        for _, textdraw in ipairs(textdraws) do
            private.idLinks[textdraw:getId()] = textdraw
        end
        private.textdraws = textdraws
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
                for _, textdraw in ipairs(public:getTextdraws()) do
                    if sampTextdrawIsExists(textdraw:getId()) and id ~= textdraw:getId() then
                        table.insert(textdraws, textdraw)
                    end
                end
                if newTextdraw:isSelectable() then
                    local newTextdraws = {}
                    for _, textdraw in ipairs(textdraws) do
                        if textdraw:getX() ~= newTextdraw:getX() or textdraw:getY() ~= newTextdraw:getY() then
                            table.insert(newTextdraws, textdraw)
                        end
                    end
                    table.insert(newTextdraws, newTextdraw)
                    textdraws = newTextdraws
                else
                    for _, textdraw in ipairs(textdraws) do
                        if textdraw:getX() < newTextdraw:getX()
                        and textdraw:getY() < newTextdraw:getY()
                        and textdraw:getX() + textdraw:getWidth() > newTextdraw:getX()
                        and textdraw:getY() + textdraw:getHeight() > newTextdraw:getY()
                        then
                            textdraw:addChild(newTextdraw)
                        end
                    end
                end
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
                    for _, textdraw in ipairs(public:getTextdraws()) do
                        if sampTextdrawIsExists(textdraw:getId()) then
                            table.insert(textdraws, textdraw)
                        end
                    end
                    private:setTextdraws(textdraws)
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
    end

    private:init()
    return public
end
return class