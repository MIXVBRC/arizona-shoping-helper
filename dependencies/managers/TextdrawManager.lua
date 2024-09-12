local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['textdraws'] = {},
        ['idLinks'] = {},
        ['all'] = {},
    }

    -- TEXTDRAWS

    function this:getTextdraws()
        return private.textdraws or {}
    end

    function private:setTextdraws(textdraws)
        private.textdraws = textdraws or {}
        return this
    end

    function this:getTextdrawById(id)
        for _, textdraw in ipairs(this:getTextdraws()) do
            if id == textdraw:getId() then
                return textdraw
            end
        end
        return nil
    end

    -- LOGIC

    function private:pushDeleteTextdrawsEvent(textdraws)
        if #textdraws > 0 then
            for _, textdraw in ipairs(textdraws) do
                _base:get('eventManager'):trigger('onDeleteÑlickableTextdraw', textdraw)
            end
        end
        return this
    end

    -- INITS

    function private:init()
        private:initEvents()
        private:initThreads()
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onShowTextDraw',
            function (id, data)
                local newTextdraw = _base:getNew('textdraw',
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
                if #this:getTextdraws() > 0 then
                    for _, textdraw in ipairs(this:getTextdraws()) do
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
                                _base:get('eventManager'):trigger('onTextdrawAddChild', textdraw, newTextdraw)
                            end
                        end
                    end
                end
                if newTextdraw:isSelectable() then
                    table.insert(textdraws, newTextdraw)
                end
                private:pushDeleteTextdrawsEvent(deleteTextdraws)
                private:setTextdraws(textdraws)
                _base:get('eventManager'):trigger('onCreateTextdraw', newTextdraw)
            end
        )
        :add(
            'onTextDrawSetString',
            function (textdrawId, text)
                for _, textdraw in ipairs(this:getTextdraws()) do
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
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    local textdraws = {}
                    local deleteTextdraws = {}
                    for _, textdraw in ipairs(this:getTextdraws()) do
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
    end

    private:init()
    return this
end
return class