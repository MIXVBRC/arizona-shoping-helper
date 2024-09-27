local class = {}
function class:new(_base, _name, _default)
    local this = {}
    local private = {
        ['name'] = _name,
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- NAME

    function private:getName()
        return private.name
    end

    -- PROFILE NAME

    function private:getProfileName()
        return private.config:get('profile') or 'default'
    end

    function private:setProfileName(name)
        private.config:set('profile', name or 'default')
        return private
    end

    -- PROFILES

    function private:getProfiles()
        return private.config:get('profiles') or {}
    end

    function private:setProfiles(profiles)
        private.config:set('profiles', profiles or {})
        return private
    end

    function private:getProfile(name)
        for _, profile in ipairs(private:getProfiles()) do
            if name == profile.name then
                return profile
            end
        end
        return nil
    end

    function private:createProfile(name)
        local profiles = private:getProfiles()
        table.insert(profiles, {
            ['name'] = name,
            ['server'] = _base:get('serverManager'):getIp(),
            ['data'] = private:getConfigDefault(),
        })
        private:setProfiles(profiles)
        return private
    end

    function private:changeProfile(name, values)
        local profiles = private:getProfiles()
        for _, profile in ipairs(profiles) do
            if name == profile.name then
                for index, value in pairs(values) do
                    profile[index] = value
                end
                return profile
            end
        end
        private:setProfiles(profiles)
        return private
    end

    function private:removeProfile(name)
        local profiles = private:getProfiles()
        for index, profile in ipairs(profiles) do
            if name == profile.name then
                table.remove(profiles, index)
                break
            end
        end
        private:setProfiles(profiles)
        return private
    end

    function private:getConfigDefault()
        local default = {}
        for title, values in pairs(_base:get('config'):getDefault()) do
            if title ~= private:getName() then
                for name, value in pairs(values) do
                    default[title] = default[title] or {}
                    default[title][name] = value
                end
            end
        end
        return default
    end

    function private:getConfigData()
        local data = {}
        for title, values in pairs(_base:get('config'):getData()) do
            if title ~= private:getName() then
                for name, value in pairs(values) do
                    data[title] = data[title] or {}
                    data[title][name] = value
                end
            end
        end
        return data
    end

    function private:setConfigData(data)
        for title, values in ipairs(private:getConfigData()) do
            if title ~= private:getName() then
                for name, value in pairs(values) do
                    _base:get('config'):delete(title, name)
                end
            end
        end
        for title, values in pairs(data) do -- _base:get('config'):getDefault()
            if title ~= private:getName() then
                for name, value in pairs(values) do
                    _base:get('config'):set(title, name, value)
                end
            end
        end
        return private
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initProfile()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'load'}, function (name)
            for _, loadProfile in ipairs(private:getProfiles()) do
                if loadProfile.name == name then
                    for _, saveProfile in ipairs(private:getProfiles()) do
                        if saveProfile.name == private:getProfileName() then
                            private:changeProfile(saveProfile.name, {
                                ['data'] = private:getConfigData(),
                            })
                        end
                    end
                    private:setConfigData(loadProfile.data)
                    private:setProfileName(loadProfile.name)
                    return
                end
            end
            _base:get('chat'):push('Нет профиля')
        end)
        :add({private:getName(), 'list'}, function ()
            for _, loadProfile in ipairs(private:getProfiles()) do
                _base:get('chat'):push(loadProfile.name)
            end
        end)
        :add({private:getName(), 'add'}, function (name)
            for _, profile in ipairs(private:getProfiles()) do
                if profile.name == name then
                    return
                end
            end
            private:createProfile(name)
        end)
        return private
    end

    function private:initProfile()
        for _, profile in ipairs(private:getProfiles()) do
            if profile.name == private:getProfileName() then
                return private
            end
        end
        private:createProfile(private:getProfileName())
        return private
    end

    return private:init()
end
return class