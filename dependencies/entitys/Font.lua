local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['cache'] = _base:getNewClass('cache'),
    }

    function this:get(name, height, flags)
        local cacheKey = _base:getClass('helper'):md5(name .. '-' .. height .. '-' .. flags)
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