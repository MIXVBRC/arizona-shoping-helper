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
            ['init'] = false,
            ['args'] = {},
        },
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
            ['name'] = 'events',
            ['entity'] = 'lib.samp.events',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'cache',
            ['entity'] = 'dependencies.Cache',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'point',
            ['entity'] = 'dependencies.Point',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circle',
            ['entity'] = 'dependencies.Circle',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circleManager',
            ['entity'] = 'dependencies.CircleManager',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shop',
            ['entity'] = 'dependencies.Shop',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'minMax',
            ['entity'] = 'dependencies.MinMax',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'configManager',
            ['entity'] = 'dependencies.ConfigManager',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'commandManager',
            ['entity'] = 'dependencies.CommandManager',
            ['init'] = true,
            ['args'] = {
                'active',
            },
        },
        {
            ['name'] = 'color',
            ['entity'] = 'dependencies.Color',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'chat',
            ['entity'] = 'dependencies.Chat',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'lowPoint',
            ['entity'] = 'dependencies.LowPoint',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'eventManager',
            ['entity'] = 'dependencies.EventManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'dialogManager',
            ['entity'] = 'dependencies.DialogManager',
            ['init'] = true,
            ['args'] = {
                777,
            },
        },
        {
            ['name'] = 'dialog',
            ['entity'] = 'dependencies.Dialog',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'threadManager',
            ['entity'] = 'dependencies.ThreadManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'textdraw',
            ['entity'] = 'dependencies.Textdraw',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'product',
            ['entity'] = 'dependencies.Product',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'productManager',
            ['entity'] = 'dependencies.ProductManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'textdrawManager',
            ['entity'] = 'dependencies.TextdrawManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'exception',
            ['entity'] = 'dependencies.Exception',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'error',
            ['entity'] = 'dependencies.Error',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'render',
            ['entity'] = 'dependencies.Render',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'font',
            ['entity'] = 'dependencies.Font',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'helper',
            ['entity'] = 'dependencies.Helper',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'config',
            ['entity'] = 'dependencies.Config',
            ['init'] = true,
            ['args'] = {
                'ShopingHelper_base',
                {},
            },
        },
        {
            ['name'] = 'message',
            ['entity'] = 'dependencies.Message',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'player',
            ['entity'] = 'dependencies.Player',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'boxManager',
            ['entity'] = 'dependencies.BoxManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopTitle',
            ['entity'] = 'dependencies.ShopTitle',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopAdmin',
            ['entity'] = 'dependencies.ShopAdmin',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopManager',
            ['entity'] = 'dependencies.ShopManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'scan',
            ['entity'] = 'dependencies.Scan',
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
    for _, dependency in pairs(this.dependencies) do
        _sh.dependencies[dependency.name] = require(dependency.entity)
        if dependency.init and _sh.dependencies[dependency.name] ~= nil then
            _sh[dependency.name] = _sh.dependencies[dependency.name]:new(table.unpack(dependency.args))
        end
    end
end

function this:init()
    this:initDependencies()
    _sh.chat:setColor(_sh.color:get('orange'))
    _sh.chat:addPrefix('[Shoping Helper]: ')
    _sh.chat:push('{' .. _sh.color:get('white') .. '}' .. _sh.script.name)
end

function main()
    while not isSampAvailable() do wait(0) end
    this:init()
end