_sh = {
    ['dependencies'] = {},
    ['script'] = {
        ['name'] = 'ShopingHelper',
        ['author'] = 'MIXVBRC',
        ['version'] = '1.0.0',
        ['url'] = 'https://vk.com/mixvbrc',
        ['command'] = 'sh',
    },
}

local this = {
    ['dependencies'] = {
        {
            ['name'] = 'md5',
            ['entity'] = 'md5',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'encoding',
            ['entity'] = 'encoding',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'ini',
            ['entity'] = 'inicfg',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'json',
            ['entity'] = 'dkjson',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'cache',
            ['entity'] = 'ShopingHelper.Cache',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'events',
            ['entity'] = 'lib.samp.events',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'point',
            ['entity'] = 'ShopingHelper.Point',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circle',
            ['entity'] = 'ShopingHelper.Circle',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circleManager',
            ['entity'] = 'ShopingHelper.CircleManager',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shop',
            ['entity'] = 'ShopingHelper.Shop',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'configManager',
            ['entity'] = 'ShopingHelper.ConfigManager',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'commandManager',
            ['entity'] = 'ShopingHelper.CommandManager',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {
                'sh',
            },
        },
        {
            ['name'] = 'lowPoint',
            ['entity'] = 'ShopingHelper.LowPoint',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'customEvents',
            ['entity'] = 'ShopingHelper.CustomEvents',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'chat',
            ['entity'] = 'ShopingHelper.Chat',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'color',
            ['entity'] = 'ShopingHelper.Color',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'font',
            ['entity'] = 'ShopingHelper.Font',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'helper',
            ['entity'] = 'ShopingHelper.Helper',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'config',
            ['entity'] = 'ShopingHelper.Config',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {
                'ShopingHelper_base',
                {},
            },
        },
        {
            ['name'] = 'message',
            ['entity'] = 'ShopingHelper.Message',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'player',
            ['entity'] = 'ShopingHelper.Player',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopManager',
            ['entity'] = 'ShopingHelper.ShopManager',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'radius',
            ['entity'] = 'ShopingHelper.Radius',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {
                'radius',
                {
                    ['active'] = true,
                    ['polygons'] = 32,
                    ['distance'] = 20,
                    ['colors'] = {
                        ['circle'] = 'ffffff',
                    },
                },
            },
        },
        {
            ['name'] = 'visit',
            ['entity'] = 'ShopingHelper.Visit',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {
                'visit',
                {
                    ['active'] = true,
                    ['empty'] = true,
                    ['hiding'] = {
                        ['player'] = true,
                        ['visit'] = true,
                        ['buy'] = true,
                        ['sell'] = true,
                        ['edit'] = true,
                        ['empty'] = true,
                    },
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
                        ['stick'] = 'ffffff',
                        ['text'] = 'ffffff',
                    },
                },
            },
        },
    },
}

function this:init()
    for _, dependency in ipairs(this.dependencies) do
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
    _sh.chat:push(_sh.script.name)
end

function main()
    while not isSampAvailable() do wait(0) end;
    this:init()
end