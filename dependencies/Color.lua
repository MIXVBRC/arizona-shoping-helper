local class = {}
function class:new()
    local public = {}
    local private = {
        ['colors'] = {
            ['red'] = '992e2e',
            ['green'] = '3cc23c',
            ['blue'] = '42bdb5',
            ['orange'] = 'ffd700',
            ['white'] = 'ffffff',
        }
    }

    function public:get(name)
        return private.colors[name] or private.colors['white']
    end

    function public:getAll()
        return private.colors
    end

    function public:getByNum(num)
        if num > 255 then
            num = 255
        elseif num < 0 then
            num = 0
        end
        local result = string.format("%x", num)
        if result:len() < 2 then
            result = '0' .. result
        end
        return result
    end

    function public:getRGB(r, g, b)
        return public:getByNum(r) .. public:getByNum(g) .. public:getByNum(b)
    end

    function public:getAlpha(num)
        if num > 100 then
            num = 100
        elseif num < 0 then
            num = 0
        end
        return '0x' .. _sh.color:getByNum(255 / 100 * num)
    end

    return public
end
return class