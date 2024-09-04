local class = {}
function class:new()
    local public = {}
    local private = {
        ['prefix'] = '',
        ['postfix'] = '',
        ['color'] = 'ffffff',
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
            message = '{' .. private.color .. '}' .. private.prefix .. message .. private.postfix
            sampAddChatMessage(message, -1)
        end
    end

    return public
end
return class