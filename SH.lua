_sh = {
    ['dependencies'] = {},
    ['script'] = {
        ['name'] = 'ShopingHelper',
        ['author'] = 'MIXVBRC',
        ['version'] = '1.0.0',
        ['url'] = 'https://vk.com/mixvbrc',
        ['command'] = 'sh',
    },
    ['commands'] = {}
}

local this = {
    ['dependencies'] = {
        {
            ['name'] = 'md5',
            ['entity'] = 'md5',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'encoding',
            ['entity'] = 'encoding',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'ini',
            ['entity'] = 'inicfg',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'json',
            ['entity'] = 'dkjson',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'events',
            ['entity'] = 'lib.samp.events',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'cache',
            ['entity'] = 'dependencies.Cache',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'point',
            ['entity'] = 'dependencies.Point',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circle',
            ['entity'] = 'dependencies.Circle',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circleManager',
            ['entity'] = 'dependencies.CircleManager',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shop',
            ['entity'] = 'dependencies.Shop',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'configManager',
            ['entity'] = 'dependencies.ConfigManager',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'commandManager',
            ['entity'] = 'dependencies.CommandManager',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {
                'active',
            },
        },
        {
            ['name'] = 'lowPoint',
            ['entity'] = 'dependencies.LowPoint',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'customEvents',
            ['entity'] = 'dependencies.CustomEvents',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'chat',
            ['entity'] = 'dependencies.Chat',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'exception',
            ['entity'] = 'dependencies.Exception',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'error',
            ['entity'] = 'dependencies.Error',
            ['dependencies'] = {},
            ['init'] = false,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'color',
            ['entity'] = 'dependencies.Color',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'font',
            ['entity'] = 'dependencies.Font',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'helper',
            ['entity'] = 'dependencies.Helper',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'config',
            ['entity'] = 'dependencies.Config',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {
                'ShopingHelper_base',
                {},
            },
        },
        {
            ['name'] = 'message',
            ['entity'] = 'dependencies.Message',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'player',
            ['entity'] = 'dependencies.Player',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shopManager',
            ['entity'] = 'dependencies.ShopManager',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'radius',
            ['entity'] = 'dependencies.Radius',
            ['dependencies'] = {
                'point',
                'color',
                'cache',
                'helper',
                'lowPoint',
                'configManager',
                'commandManager',
            },
            ['init'] = true,
            ['base'] = false,
            ['args'] = {
                'radius',
                {
                    ['active'] = true,
                    ['polygons'] = 32,
                    ['distance'] = 20,
                    ['colors'] = {
                        ['circle'] = 'ffffff',
                        ['green'] = '00ff00',
                        ['red'] = 'ff0000',
                    },
                },
            },
        },
        {
            ['name'] = 'visit',
            ['entity'] = 'dependencies.Visit',
            ['dependencies'] = {},
            ['init'] = true,
            ['base'] = false,
            ['args'] = {
                'visit',
                {
                    ['active'] = true,
                    ['hiding'] = {
                        ['player'] = true,
                        ['visit'] = true,
                        ['buy'] = true,
                        ['sell'] = true,
                        ['edit'] = true,
                        ['empty'] = true,
                        ['time'] = true,
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
                        ['select'] = 'ffffff',
                        ['empty'] = 'cc36e0',
                        ['stick'] = 'ffffff',
                        ['text'] = 'ffffff',
                    },
                },
            },
        },
    },
}

function this:initDependencies()
    for _, dependency in ipairs(this.dependencies) do
        if dependency.entity ~= nil then
            _sh.dependencies[dependency.name] = require(dependency.entity)
            if _sh.dependencies[dependency.name] ~= nil then
                if dependency.init then
                    _sh[dependency.name] = _sh.dependencies[dependency.name]:new(table.unpack(dependency.args))
                elseif dependency.base then
                    _sh[dependency.name] = _sh.dependencies[dependency.name]
                end
            end
        end
    end
end

function this:init()
    this:initDependencies()
    _sh.chat:push(_sh.script.name)
end

function main()
    while not isSampAvailable() do wait(0) end;
    this:init()
end