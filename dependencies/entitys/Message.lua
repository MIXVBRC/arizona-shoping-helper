local class = {}
function class:new(_base, _lang, _messages)
    local this = {}
    local private = {
        ['lang'] = _lang,
        ['messages'] = _messages,
    }

    -- LANG

    function private:getLang()
        return private.lang
    end

    function this:setLang(lang)
        private.lang = lang
        return this
    end

    -- LANGS

    function private:getMessage(name)
        return (private.messages[private:getLang()] or {})[name]
    end

    -- REPLACE STRING

    function private:replaceString(text, replacements)
        if replacements ~= nil then
            for from, to in ipairs(replacements) do
                text = text:gsub('#'..from..'#', to)
            end
        end
        return text
    end

    -- REPLACE COLOR

    function private:replaceColor(text)
        for name, color in pairs(_base:get('color'):getAll()) do
            text = text:gsub('{'..name..'}', '{'..color..'}')
        end
        return text
    end

    -- GET

    function this:get(name, replacements)
        local result = private:getMessage(name)
        if result ~= nil then
            result = private:replaceString(result, replacements)
            result = private:replaceColor(result)
        end
        return result or ''
    end

    return this
end
return class
