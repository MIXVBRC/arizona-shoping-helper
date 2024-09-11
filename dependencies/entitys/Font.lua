local class = {}
function class:new(base)
    local this = {}
    local private = {
        ['cache'] = base:getObject('cache'):new(base),
    }

    function this:get(name, height, flags)
        local cacheKey = base:getClass('helper'):md5(name .. '-' .. height .. '-' .. flags)
        local font = private.cache:get(cacheKey)
        if font == nil then
            font = renderCreateFont(name, height, flags)
            private.cache:add(cacheKey, font)
        end
        return font
    end

    return this
end
return class