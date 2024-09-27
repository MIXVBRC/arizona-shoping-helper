local class = {}
function class:new(_base)
    local this = {}
    local private = {
        ['ip'] = nil,
        ['port'] = nil,
    }

    -- IP

    function this:getIp()
        return private.ip
    end

    function private:setIp(ip)
        private.ip = ip
        return this
    end

    -- PORT

    function this:getPort()
        return private.port
    end

    function private:setPort(port)
        private.port = port
        return this
    end

    -- FULL

    function this:getFull()
        return this:getIp() .. ':' .. this:getPort()
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
                while true do
                    local ip, port = sampGetCurrentServerAddress()
                    if ip ~= this:getIp() or port ~= this:getPort() then
                        _base:get('eventManager'):trigger('onChangeIpOrPort', ip, port)
                    end
                    private:setIp(ip)
                    private:setPort(port)
                    wait(5000)
                end
            end
        )
        return private
    end

    return private:init()
end
return class