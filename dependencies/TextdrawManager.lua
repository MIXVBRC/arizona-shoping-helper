local class = {}
function class:new()
    local public = {}
    local private = {}

    function private:init()
    end

    _sh.eventManager:add('onTextDrawSetString', function (textdrawId, text)
        _sh.chat:push('1str' .. textdrawId .. ': ' .. text)
    end)

    -- function _sh.events.onShowTextDraw(textdrawId, textdraw)
    --     _sh.chat:push('one' .. textdrawId .. ': ' .. textdraw.text)
    -- end

    -- function _sh.events.onTextDrawSetString(textdrawId, text)
    --     _sh.chat:push('1str' .. textdrawId .. ': ' .. text)
    -- end

    private:init()
    return public
end
return class