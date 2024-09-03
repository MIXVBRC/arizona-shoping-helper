_sh = {
    ['dependencies'] = {},
}
function message(mess)
    sampAddChatMessage(mess, -1)
end
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
        ['name'] = 'font',
        ['entity'] = 'ShopingHelper.Font',
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
            'ShopingHelper_base',
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
    {
        ['name'] = 'visit',
        ['entity'] = 'ShopingHelper.Visit',
        ['init'] = true,
        ['args'] = {
            {
                ['active'] = true,
                ['empty'] = true,
                ['hiding'] = false,
                ['distance'] = 50,
                ['time'] = 200,
                ['colors'] = {
                    ['player'] = 'e06936',
                    ['sell'] = '36e03c',
                    ['buy'] = '3647e0',
                    ['sell_buy'] = '36e0e0',
                    ['edit'] = 'd2e036',
                    ['visit'] = 'e03636',
                    ['empty'] = 'cc36e0',
                },
            }
        },
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