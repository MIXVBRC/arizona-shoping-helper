local class = {}
function class:new()
    local public = {}
    local private = {
        ['threads'] = {},
    }

    function public:add(name, _function)
        if name ~= nil then
            table.insert(private.threads, {
                ['name'] = name,
                ['thread'] = lua_thread.create_suspended(_function)
            })
        else
            lua_thread.create(_function)
        end
        return public
    end

    function public:run(name)
        for _, thread in ipairs(private.threads) do
            if name == thread.name then
                thread.thread:run()
            end
        end
        return public
    end

    function public:terminate(name)
        for _, thread in ipairs(private.threads) do
            if name == thread.name then
                thread.thread:terminate()
            end
        end
        return public
    end

    return public
end
return class