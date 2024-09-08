local class = {}
function class:new()
    local public = {}
    local private = {
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function public:get(name, height, flags)
        local cacheKey = _sh.helper:md5(name .. '-' .. height .. '-' .. flags)
        local font = private.cache:get(cacheKey)
        if font == nil then
            font = renderCreateFont(name, height, flags)
            private.cache:add(cacheKey, font)
        end
        return font
    end

    return public
end
return class