local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['text3ds'] = {},
    }

    -- TEXTS

    function private:get()
        return private.text3ds
    end

    function private:set(text3ds)
        private.text3ds = text3ds
        return private
    end

    function private:getById(id)
        for index, text3d in ipairs(private:getText3ds()) do
            if id == text3d:getId() then
                return text3d, index
            end
        end
        return nil
    end

    -- CREATE

    function this:create(id, text, alpha, color, x, y, z, distance, xray, player, car)
        local text3d = _base:getNew('text3d', id, text, alpha, color, x, y, z, distance, xray, player, car)
        table.insert(private.text3ds, text3d)
        return text3d
    end

    -- DELETE

    function this:delete(id)
        local text3ds = private:getText3ds()
        for index, text3d in ipairs(text3ds) do
            if id == text3d:getId() then
                text3d:delete()
                table.remove(text3ds, index)
                return text3d
            end
        end
        return this
    end

    return this
end
return class