local class = {}
function class:new()
    local public = {}
    local private = {}

    function private:init()
        private:initEvents()
    end

    function private:initEvents()
        _sh.eventManager:add('onShowTextDraw', function (textdrawId, text)
            _sh.chat:push('1str' .. textdrawId .. ': ' .. text)
        end)
        _sh.eventManager:add('onTextDrawSetString', function (textdrawId, text)
            _sh.chat:push('1str' .. textdrawId .. ': ' .. text)
        end)
    end

    private:init()
    return public
end
return class