local class = {}
function class:new(_base, _lang, _name, _default)
    local this = {}
    local private = {
        ['lang'] = _lang,
        ['config'] = _base:getInit('config', _name, _default),
    }

    function private:getLang()
        return private.lang
    end

    function this:setLang(lang)
        private.lang = lang
        return this
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
        for name, color in pairs(_base:get('color'):getAll()) do
            text = text:gsub('{'..name..'}', '{'..color..'}')
        end
        return text
    end

    function this:get(name, replacements)
        local result = private.config:get(private:getLang(), name)
        if result ~= nil then
            result = private:replaceString(result, replacements)
            result = private:replaceColor(result)
        end
        return result or ''
    end

    return this
end
return class
