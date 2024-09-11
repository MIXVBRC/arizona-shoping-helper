local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['prefix'] = '',
        ['postfix'] = '',
        ['color'] = _base:getClass('color'):get('white'),
    }

    function this:addPrefix(prefix)
        private.prefix = prefix
        return this
    end

    function this:addPostfix(postfix)
        private.postfix = postfix
        return this
    end

    function this:setColor(color)
        private.color = color
        return this
    end

    function this:push(message)
        if message ~= nil then
            message = private.prefix .. message .. private.postfix
            sampAddChatMessage(message, '0xff' .. private.color)
        end
    end

    return this
end
return class