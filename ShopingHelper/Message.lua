local class = {}
function class:new(_sh)
    local public = {}
    local private = {
        ['sh'] = _sh,
        ['lang'] = 'ru',
        ['config'] = _sh.dependencies.config:new(_sh, 'ShopingHelper_langs'), -- _name = ShopingHelper
    }

    function public:getLang()
        return private.lang
    end

    function public:setLang(lang)
        private.lang = lang
        return public
    end

    function public:replaceString(text, gsub)
        if gsub ~= nil then
            for from, to in ipairs(gsub) do
                text = text:gsub('#'..from..'#', to)
            end
        end
        return text
    end

    -- TODO: replase Color:getAll() to Color:get(color_name)
    function public:replaceColor(text)
        for name, color in pairs(private.sh.color:getAll()) do
            text = text:gsub('{'..name..'}', '{'..color..'}')
        end
        return text
    end

    function public:get(name, gsub)
        local result = private.config:get(private:getLang(), name)
        if result ~= nil then
            result = private.sh.helper:utf8(result)
            result = private:replaceString(result, gsub)
            result = private:replaceColor(result)
        end
        return result or ''
    end

    return public
end
return class
