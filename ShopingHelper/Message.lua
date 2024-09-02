local class = {}
function class:new()
    local public = {}
    local private = {
        ['lang'] = 'rus',
        ['config'] = _sh.dependencies.config:new('ShopingHelper_langs'), -- _name = ShopingHelper
    }

    function private:getLang()
        return private.lang
    end

    function public:setLang(lang)
        private.lang = lang
        return public
    end

    function private:replaceString(text, gsub)
        if gsub ~= nil then
            for from, to in ipairs(gsub) do
                text = text:gsub('#'..from..'#', to)
            end
        end
        return text
    end

    -- TODO: replase Color:getAll() to Color:get(color_name)
    function private:replaceColor(text)
        for name, color in pairs(_sh.color:getAll()) do
            text = text:gsub('{'..name..'}', '{'..color..'}')
        end
        return text
    end

    function public:get(name, gsub)
        local result = private.config:get(private:getLang(), name)
        if result ~= nil then
            result = _sh.helper:utf8(result)
            result = private:replaceString(result, gsub)
            result = private:replaceColor(result)
        end
        return result or ''
    end

    return public
end
return class
