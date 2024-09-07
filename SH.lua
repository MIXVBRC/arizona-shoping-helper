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
            ['name'] = 'moownloader',
            ['entity'] = 'moonloader',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
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
            ['name'] = 'events',
            ['entity'] = 'lib.samp.events',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'cache',
            ['entity'] = 'dependencies.Cache',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'point',
            ['entity'] = 'dependencies.Point',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circle',
            ['entity'] = 'dependencies.Circle',
            ['dependencies'] = {
                'point',
                'helper',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circleManager',
            ['entity'] = 'dependencies.CircleManager',
            ['dependencies'] = {
                'circle',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shop',
            ['entity'] = 'dependencies.Shop',
            ['dependencies'] = {
                'helper',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'minMax',
            ['entity'] = 'dependencies.MinMax',
            ['dependencies'] = {},
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'configManager',
            ['entity'] = 'dependencies.ConfigManager',
            ['dependencies'] = {
                'config'
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'commandManager',
            ['entity'] = 'dependencies.CommandManager',
            ['dependencies'] = {
                'message',
            },
            ['init'] = true,
            ['args'] = {
                'active',
            },
        },
        {
            ['name'] = 'chat',
            ['entity'] = 'dependencies.Chat',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'lowPoint',
            ['entity'] = 'dependencies.LowPoint',
            ['dependencies'] = {
                'player',
                'render',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'eventManager',
            ['entity'] = 'dependencies.EventManager',
            ['dependencies'] = {
                'events',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'dialogManager',
            ['entity'] = 'dependencies.DialogManager',
            ['dependencies'] = {
                'eventManager',
                'dialog',
            },
            ['init'] = true,
            ['args'] = {
                777,
            },
        },
        {
            ['name'] = 'dialog',
            ['entity'] = 'dependencies.Dialog',
            ['dependencies'] = {
                'threadManager',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'threadManager',
            ['entity'] = 'dependencies.ThreadManager',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'textdraw',
            ['entity'] = 'dependencies.Textdraw',
            ['dependencies'] = {
                'helper',
                'eventManager',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'product',
            ['entity'] = 'dependencies.Product',
            ['dependencies'] = {
                'eventManager',
                'helper',
                'threadManager',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'productManager',
            ['entity'] = 'dependencies.ProductManager',
            ['dependencies'] = {
                'helper',
                'product',
                'eventManager',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'textdrawManager',
            ['entity'] = 'dependencies.TextdrawManager',
            ['dependencies'] = {
                'textdraw',
                'eventManager',
                'threadManager',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'exception',
            ['entity'] = 'dependencies.Exception',
            ['dependencies'] = {
                'error',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'error',
            ['entity'] = 'dependencies.Error',
            ['dependencies'] = {
                'chat',
            },
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'render',
            ['entity'] = 'dependencies.Render',
            ['dependencies'] = {
                'threadManager',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'font',
            ['entity'] = 'dependencies.Font',
            ['dependencies'] = {
                'cache',
                'helper',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'color',
            ['entity'] = 'dependencies.Color',
            ['dependencies'] = {},
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'helper',
            ['entity'] = 'dependencies.Helper',
            ['dependencies'] = {
                'player',
                'md5',
                'encoding',
                'json',
                'ini',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'config',
            ['entity'] = 'dependencies.Config',
            ['dependencies'] = {
                'helper',
            },
            ['init'] = true,
            ['args'] = {
                'ShopingHelper_base',
                {},
            },
        },
        {
            ['name'] = 'message',
            ['entity'] = 'dependencies.Message',
            ['dependencies'] = {
                'color',
                'helper',
                'config',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'player',
            ['entity'] = 'dependencies.Player',
            ['dependencies'] = {
                'cache',
                'eventManager',
                'threadManager',
                'message',
                'helper',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'boxManager',
            ['entity'] = 'dependencies.BoxManager',
            ['dependencies'] = {
                'helper',
                'threadManager',
                'render',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopManager',
            ['entity'] = 'dependencies.ShopManager',
            ['dependencies'] = {
                'message',
                'cache',
                'helper',
                'threadManager',
                'shop',
                'eventManager',
            },
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'scan',
            ['entity'] = 'dependencies.Scan',
            ['dependencies'] = {
                'minMax',
                'configManager',
                'commandManager',
                'select',
                'helper',
                'threadManager',
                'productManager',
                'boxManager',
                'color',
                'eventManager',
                'player',
                'dialogManager',
            },
            ['init'] = true,
            ['args'] = {
                'scan',
                {
                    ['active'] = true,
                    ['add'] = false,
                    ['time'] = 500,
                },
            },
        },
        {
            ['name'] = 'radius',
            ['entity'] = 'dependencies.Radius',
            ['dependencies'] = {
                'minMax',
                'point',
                'color',
                'cache',
                'helper',
                'lowPoint',
                'configManager',
                'commandManager',
                'shopManager',
                'render',
                'circleManager',
                'threadManager',
                'player',
            },
            ['init'] = true,
            ['args'] = {
                'radius',
                {
                    ['active'] = true,
                    ['polygons'] = 24,
                    ['distance'] = 30,
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
            ['dependencies'] = {
                'minMax',
                'configManager',
                'commandManager',
                'cache',
                'shopManager',
                'player',
                'message',
                'helper',
                'color',
                'render',
                'font',
                'threadManager',
                'eventManager',
            },
            ['init'] = true,
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
        {
            ['name'] = 'select',
            ['entity'] = 'dependencies.Select',
            ['dependencies'] = {
                'minMax',
                'configManager',
                'commandManager',
                'scan',
                'player',
                'productManager',
                'boxManager',
                'color',
                'helper',
                'threadManager',
                'dialogManager',
            },
            ['init'] = true,
            ['args'] = {
                'select',
                {
                    ['active'] = false,
                    ['add'] = true,
                    ['border'] = 2,
                    ['color'] = '0000ff',
                    ['alpha'] = 100,
                },
            },
        },
        {
            ['name'] = 'swipe',
            ['entity'] = 'dependencies.Swipe',
            ['dependencies'] = {
                'configManager',
                'commandManager',
                'eventManager',
            },
            ['init'] = true,
            ['args'] = {
                'swipe',
                {
                    ['active'] = false,
                    ['mod'] = 'buy',
                },
            },
        },
        {
            ['name'] = 'trade',
            ['entity'] = 'dependencies.Trade',
            ['dependencies'] = {
                'configManager',
                'commandManager',
                'eventManager',
                'textdrawManager',
                'player',
                'helper',
                'chat',
                'dialogManager',
            },
            ['init'] = true,
            ['args'] = {
                'trade',
                {
                    ['active'] = false,
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
    while not isSampAvailable() do wait(0) end
    this:init()
end