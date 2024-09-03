local class = {}
function class:new()
    local public = {}
    local private = {}

    function public:push(message, color)
        color = color or -1
        sampAddChatMessage(message, color)
    end

    return public
end
return class