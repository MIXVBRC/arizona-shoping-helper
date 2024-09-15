local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['queue'] = {},
        ['processed'] = nil,
    }

    -- QUEUE

    function private:getQueue()
        return private.queue
    end

    function private:setQueue(queue)
        private.queue = queue
        return this
    end

    function private:getQueueItem(index)
        return private.queue[index]
    end

    function private:addQueueItem(queueItem)
        table.insert(private.queue, queueItem)
        table.sort(private.queue, function (a, b) return a.sort > b.sort end)
        return this
    end

    function private:deleteQueueItem(index)
        table.remove(private.queue, index)
        return this
    end

    -- PROCESSED

    function private:isProcessed()
        return private.processed ~= nil
    end

    function private:getProcess()
        return private.processed
    end

    function private:setProcess(processed)
        private.processed = processed
        return this
    end

    function private:clearProcess()
        private:setProcess(nil)
        return this
    end

    -- ADD

    function this:add(execute, sort)
        local queueProcess = _base:getNew('queueProcess', execute)
        private:addQueueItem({
            ['sort'] = sort or 100,
            ['queueProcess'] = queueProcess,
        })
        return queueProcess
    end

    -- INITS

    function private:init()
        private:initEvents():initThreads()
        return this
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onEvent',
            function (name, ...)
                if private:isProcessed() then
                    local queueProcess = private:getProcess()
                    if queueProcess ~= nil then
                        local event = queueProcess:getEvent(name)
                        if event ~= nil then
                            return event(...)
                        end
                    end
                end
            end
        )
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(0)
                    for index, queueItem in ipairs(private:getQueue()) do
                        if queueItem.queueProcess:isActive() then
                            private:setProcess(queueItem.queueProcess)
                            private:deleteQueueItem(index)
                            queueItem.queueProcess:getExecute()(queueItem.queueProcess)
                            private:clearProcess()
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class