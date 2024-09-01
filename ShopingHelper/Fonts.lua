local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['cache'] = _sh.dependencies.cache:new(),
    }

    function public:get(name, height, flags)
        local cacheKey = private.sh.helper:md5(name .. '-' .. height .. '-' .. flags)
        local font = private.cache:get(cacheKey)
        if font == nil then
            font = renderCreateFont("Arial", 12, 4)
            private.cache:add(cacheKey, font)
        end
        return font
    end

    return public
end
return class