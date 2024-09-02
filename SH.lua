_sh = {
    ['dependencies'] = {},
}
local this = {}
local dependencies = {
    {
        ['name'] = 'md5',
        ['entity'] = 'md5',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'encoding',
        ['entity'] = 'encoding',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'ini',
        ['entity'] = 'inicfg',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'json',
        ['entity'] = 'dkjson',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'cache',
        ['entity'] = 'ShopingHelper.Cache',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'events',
        ['entity'] = 'lib.samp.events',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'point',
        ['entity'] = 'ShopingHelper.Point',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'circle',
        ['entity'] = 'ShopingHelper.Circle',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'circleManager',
        ['entity'] = 'ShopingHelper.CircleManager',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'shop',
        ['entity'] = 'ShopingHelper.Shop',
        ['init'] = false,
        ['args'] = {},
    },
    {
        ['name'] = 'customEvents',
        ['entity'] = 'ShopingHelper.CustomEvents',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'color',
        ['entity'] = 'ShopingHelper.Color',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'helper',
        ['entity'] = 'ShopingHelper.Helper',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'config',
        ['entity'] = 'ShopingHelper.Config',
        ['init'] = true,
        ['args'] = {
            'ShopingHelper',
            {},
        },
    },
    {
        ['name'] = 'message',
        ['entity'] = 'ShopingHelper.Message',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'player',
        ['entity'] = 'ShopingHelper.Player',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'shopManager',
        ['entity'] = 'ShopingHelper.ShopManager',
        ['init'] = true,
        ['args'] = {},
    },
    {
        ['name'] = 'radius',
        ['entity'] = 'ShopingHelper.Radius',
        ['init'] = true,
        ['args'] = {},
    },
}

function this:init()
    for _, dependency in ipairs(dependencies) do
        if dependency.entity ~= nil then
            _sh.dependencies[dependency.name] = require(dependency.entity)
            if _sh.dependencies[dependency.name] ~= nil then
                if dependency.init then
                    _sh[dependency.name] = _sh.dependencies[dependency.name]:new(table.unpack(dependency.args))
                else
                    _sh[dependency.name] = _sh.dependencies[dependency.name]
                end
            end
        end
    end
end

function main()
    while not isSampAvailable() do wait(0) end;
    this:init()
end