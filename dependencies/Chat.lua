local class = {}
function class:new()
    local public = {}
    local private = {
        ['prefix'] = '',
        ['postfix'] = '',
        ['color'] = _sh.color:get('white'),
    }

    function public:addPrefix(prefix)
        private.prefix = prefix
        return public
    end

    function public:addPostfix(postfix)
        private.postfix = postfix
        return public
    end

    function public:setColor(color)
        private.color = color
        return public
    end

    function public:push(message)
        if message ~= nil then
            message = private.prefix .. message .. private.postfix
            sampAddChatMessage(message, '0xff' .. private.color)
        end
    end

    return public
end
return class