local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['queue'] = {},
    }

    -- QUEUE

    function private:getQueue()
        return private.queue
    end

    function private:setQueue(queue)
        private.queue = queue
        return this
    end

    function private:addQueueItem(item)
        table.insert(private.queue, item)
        return this
    end

    function private:deleteQueueItem(index)
        table.remove(private.queue, index)
        return this
    end

    -- INITS

    function private:init()
        private:initThreads()
        return this
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    for _, item in ipairs(private:getQueue()) do
                        
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class