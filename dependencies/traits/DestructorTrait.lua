local class = {}
function class:new(_, _table)
    if _table ~= nil then
        if _VERSION == 'Lua 5.1' then
            local proxy = newproxy(true)
            getmetatable(proxy).__gc = _table.__destructor
            _table[proxy] = true
        else
            setmetatable(_table, {
                __gc = _table.__destructor
            })
        end
    end
    return nil
end
return class