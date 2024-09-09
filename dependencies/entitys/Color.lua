local class = {}
function class:new(_colors)
    local this = {}
    local private = {
        ['colors'] = _colors
    }

    function this:get(name)
        return private.colors[name] or private.colors['white']
    end

    function this:getAll()
        return private.colors
    end

    function this:getByNum(num)
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

    function this:getRGB(r, g, b)
        return this:getByNum(r) .. this:getByNum(g) .. this:getByNum(b)
    end

    function this:getAlpha(num)
        if num > 100 then
            num = 100
        elseif num < 0 then
            num = 0
        end
        return '0x' .. this:getByNum(255 / 100 * num)
    end

    return this
end
return class