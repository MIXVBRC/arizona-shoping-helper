local class = {}
function class:new(_lang, _name, _default)
    local public = {}
    local private = {
        ['lang'] = _lang,
        ['config'] = _sh.dependencies.config:new(_name, _default),
    }

    function private:getLang()
        return private.lang
    end

    function public:setLang(lang)
        private.lang = lang
        return public
    end

    function private:replaceString(text, replacements)
        if replacements ~= nil then
            for from, to in ipairs(replacements) do
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

    function public:get(name, replacements)
        local result = private.config:get(private:getLang(), name)
        if result ~= nil then
            result = private:replaceString(result, replacements)
            result = private:replaceColor(result)
        end
        return result or ''
    end

    return public
end
return class
