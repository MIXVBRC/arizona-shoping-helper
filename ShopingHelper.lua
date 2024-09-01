_ShopingHelper = {
    ['dependencies'] = {},
}
local this = {}
local dependencies = {
    -- defaults
    {
        ['type'] = 'default',
        ['name'] = 'md5',
        ['entity'] = 'md5',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'encoding',
        ['entity'] = 'encoding',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'ini',
        ['entity'] = 'inicfg',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'json',
        ['entity'] = 'dkjson',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'events',
        ['entity'] = 'lib.samp.events',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'circle',
        ['entity'] = 'ShopingHelper.Circle',
        ['args'] = {},
    },
    {
        ['type'] = 'default',
        ['name'] = 'shop',
        ['entity'] = 'ShopingHelper.Shop',
        ['args'] = {},
    },
    -- classes
    {
        ['type'] = 'class',
        ['name'] = 'customEvents',
        ['entity'] = 'ShopingHelper.CustomEvents',
        ['args'] = {},
    },
    {
        ['type'] = 'class',
        ['name'] = 'color',
        ['entity'] = 'ShopingHelper.Color',
        ['args'] = {},
    },
    {
        ['type'] = 'class',
        ['name'] = 'config',
        ['entity'] = 'ShopingHelper.Config',
        ['args'] = {
            {
                ['type'] = 'global',
                ['value'] = '_ShopingHelper',
            },
            {
                ['type'] = 'string',
                ['value'] = 'ShopingHelper',
            },
            {
                ['type'] = 'table',
                ['value'] = {},
            },
        },
    },
    {
        ['type'] = 'class',
        ['name'] = 'message',
        ['entity'] = 'ShopingHelper.Message',
        ['args'] = {
            {
                ['type'] = 'global',
                ['value'] = '_ShopingHelper',
            },
        },
    },
    {
        ['type'] = 'class',
        ['name'] = 'player',
        ['entity'] = 'ShopingHelper.Player',
        ['args'] = {
            {
                ['type'] = 'global',
                ['value'] = '_ShopingHelper',
            },
        },
    },
    {
        ['type'] = 'class',
        ['name'] = 'shop',
        ['entity'] = 'ShopingHelper.ShopManager',
        ['args'] = {
            {
                ['type'] = 'global',
                ['value'] = '_ShopingHelper',
            },
        },
    },
    {
        ['type'] = 'class',
        ['name'] = 'helper',
        ['entity'] = 'ShopingHelper.Helper',
        ['args'] = {
            {
                ['type'] = 'global',
                ['value'] = '_ShopingHelper',
            },
        },
    },
}

function this:init()
    for _, dependency in ipairs(dependencies) do
        if dependency.entity ~= nil then
            _ShopingHelper.dependencies[dependency.name] = require(_ShopingHelper.entity)
            _ShopingHelper[dependency.name] = _ShopingHelper.dependencies[dependency.name]
            if dependency.type == 'class' then
                local args = {}
                if dependency.args ~= nil and #dependency.args > 0 then
                    for index, arg in ipairs(dependency.args) do
                        args[index] = arg.value
                        if arg.type == 'global' then
                            args[index] = _G[arg.value]
                        end
                    end
                end
                _ShopingHelper[dependency.name] = _ShopingHelper[dependency.name](table.unpack(args))
            end
        end
    end
end

function main()
    while not isSampAvailable() do wait(0) end;
    this:init()
end