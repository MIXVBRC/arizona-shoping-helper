_sh = {
    ['dependencies'] = {},
    ['script'] = {
        ['name'] = 'Shoping Helper',
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
            ['entity'] = 'dependencies.entitys.Cache',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'point',
            ['entity'] = 'dependencies.entitys.Point',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circle',
            ['entity'] = 'dependencies.entitys.Circle',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'circleManager',
            ['entity'] = 'dependencies.managers.CircleManager',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'shop',
            ['entity'] = 'dependencies.entitys.Shop',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'minMax',
            ['entity'] = 'dependencies.entitys.MinMax',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'configManager',
            ['entity'] = 'dependencies.managers.ConfigManager',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'commandManager',
            ['entity'] = 'dependencies.managers.CommandManager',
            ['init'] = true,
            ['args'] = {
                'active',
            },
        },
        {
            ['name'] = 'color',
            ['entity'] = 'dependencies.entitys.Color',
            ['init'] = true,
            ['args'] = {
                {
                    ['red'] = '992e2e',
                    ['green'] = '3cc23c',
                    ['blue'] = '42bdb5',
                    ['orange'] = 'ffd700',
                    ['white'] = 'ffffff',
                    ['black'] = '000000',
                }
            },
        },
        {
            ['name'] = 'chat',
            ['entity'] = 'dependencies.entitys.Chat',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'lowPoint',
            ['entity'] = 'dependencies.entitys.LowPoint',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'eventManager',
            ['entity'] = 'dependencies.managers.EventManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'dialogManager',
            ['entity'] = 'dependencies.managers.DialogManager',
            ['init'] = true,
            ['args'] = {
                777,
            },
        },
        {
            ['name'] = 'dialog',
            ['entity'] = 'dependencies.entitys.Dialog',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'threadManager',
            ['entity'] = 'dependencies.managers.ThreadManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'textdraw',
            ['entity'] = 'dependencies.entitys.Textdraw',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'product',
            ['entity'] = 'dependencies.entitys.Product',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'productManager',
            ['entity'] = 'dependencies.managers.ProductManager',
            ['init'] = true,
            ['args'] = {
                'productManager',
            },
        },
        {
            ['name'] = 'textdrawManager',
            ['entity'] = 'dependencies.managers.TextdrawManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'exception',
            ['entity'] = 'dependencies.entitys.Exception',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'error',
            ['entity'] = 'dependencies.entitys.Error',
            ['init'] = false,
            ['args'] = {},
        },
        {
            ['name'] = 'render',
            ['entity'] = 'dependencies.entitys.Render',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'font',
            ['entity'] = 'dependencies.entitys.Font',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'helper',
            ['entity'] = 'dependencies.entitys.Helper',
            ['init'] = true,
            ['args'] = {
                {
                    ['decode'] = {
                        ['_'] = ' ',
                        ['a'] = 'а',
                        ['A'] = 'ј',
                        ['Ч'] = 'б',
                        ['А'] = 'Ѕ',
                        ['Ґ'] = 'в',
                        ['Л'] = '¬',
                        ['Щ'] = 'г',
                        ['В'] = '√',
                        ['Ъ'] = 'д',
                        ['Г'] = 'ƒ',
                        ['e'] = 'е',
                        ['E'] = '≈',
                        ['Ы'] = 'ж',
                        ['Д'] = '∆',
                        ['Я'] = 'з',
                        ['И'] = '«',
                        ['Ь'] = 'и',
                        ['Е'] = '»',
                        ['Э'] = 'й',
                        ['k'] = 'к',
                        ['K'] = ' ',
                        ['Ю'] = 'л',
                        ['З'] = 'Ћ',
                        ['ѓ'] = 'м',
                        ['M'] = 'ћ',
                        ['Ѓ'] = 'н',
                        ['H'] = 'Ќ',
                        ['o'] = 'о',
                        ['O'] = 'ќ',
                        ['£'] = 'п',
                        ['М'] = 'ѕ',
                        ['p'] = 'р',
                        ['P'] = '–',
                        ['c'] = 'с',
                        ['C'] = '—',
                        ['¶'] = 'т',
                        ['П'] = '“',
                        ['y'] = 'у',
                        ['Y'] = '”',
                        ['?'] = 'ф',
                        ['Б'] = '‘',
                        ['x'] = 'х',
                        ['X'] = '’',
                        ['$'] = 'ц',
                        ['Й'] = '÷',
                        ['§'] = 'ч',
                        ['Н'] = '„',
                        ['•'] = 'ш',
                        ['О'] = 'Ў',
                        ['°'] = 'щ',
                        ['К'] = 'ў',
                        ['©'] = 'ь',
                        ['Т'] = '№',
                        ['Р'] = 'ъ',
                        ['І'] = 'Џ',
                        ['®'] = 'ы',
                        ['С'] = 'џ',
                        ['™'] = 'э',
                        ['У'] = 'Ё',
                        ['Ђ'] = 'ю',
                        ['Ф'] = 'ё',
                        ['ђ'] = '€',
                        ['Х'] = 'я',
                    },
                    ['encode'] = {
                        [' '] = '_',
                        ['а'] = 'a',
                        ['ј'] = 'A',
                        ['б'] = 'Ч',
                        ['Ѕ'] = 'А',
                        ['в'] = 'Ґ',
                        ['¬'] = 'Л',
                        ['г'] = 'Щ',
                        ['√'] = 'В',
                        ['д'] = 'Ъ',
                        ['ƒ'] = 'Г',
                        ['е'] = 'e',
                        ['≈'] = 'E',
                        ['Є'] = 'e',
                        ['®'] = 'E',
                        ['ж'] = 'Ы',
                        ['∆'] = 'Д',
                        ['з'] = 'Я',
                        ['«'] = 'И',
                        ['и'] = 'Ь',
                        ['»'] = 'Е',
                        ['й'] = 'Э',
                        ['…'] = 'Е',
                        ['к'] = 'k',
                        [' '] = 'K',
                        ['л'] = 'Ю',
                        ['Ћ'] = 'З',
                        ['м'] = 'ѓ',
                        ['ћ'] = 'M',
                        ['н'] = 'Ѓ',
                        ['Ќ'] = 'H',
                        ['о'] = 'o',
                        ['ќ'] = 'O',
                        ['п'] = '£',
                        ['ѕ'] = 'М',
                        ['р'] = 'p',
                        ['–'] = 'P',
                        ['с'] = 'c',
                        ['—'] = 'C',
                        ['т'] = '¶',
                        ['“'] = 'П',
                        ['у'] = 'y',
                        ['”'] = 'Y',
                        ['ф'] = '?',
                        ['‘'] = 'Б',
                        ['х'] = 'x',
                        ['’'] = 'X',
                        ['ц'] = '$',
                        ['÷'] = 'Й',
                        ['ч'] = '§',
                        ['„'] = 'Н',
                        ['ш'] = '•',
                        ['Ў'] = 'О',
                        ['щ'] = '°',
                        ['ў'] = 'К',
                        ['ь'] = '©',
                        ['№'] = 'Т',
                        ['ъ'] = 'Р',
                        ['Џ'] = 'І',
                        ['ы'] = '®',
                        ['џ'] = 'С',
                        ['э'] = '™',
                        ['Ё'] = 'У',
                        ['ю'] = 'Ђ',
                        ['ё'] = 'Ф',
                        ['€'] = 'ђ',
                        ['я'] = 'Х',
                    },
                }
            },
        },
        {
            ['name'] = 'config',
            ['entity'] = 'dependencies.entitys.Config',
            ['init'] = true,
            ['args'] = {
                'ShopingHelper_base',
                {},
            },
        },
        {
            ['name'] = 'message',
            ['entity'] = 'dependencies.entitys.Message',
            ['init'] = true,
            ['args'] = {
                'rus',
                'ShopingHelper_langs',
                {
                    ['rus'] = {
                        ['system_shop_mod_buy'] = 'ѕ–ќƒј∆ј',
                        ['system_shop_mod_sale'] = '— ”ѕ ј',
                        ['system_shop_shoping_textdraw'] = 'ћј√ј«»Ќ',
                        ['system_shop_admining_textdraw'] = 'Ќј ѕ–ќƒј∆≈',

                        ['system_shop_edit'] = 'редактирует',
                        ['system_shop'] = 'Ћавка',
                        ['system_shop_sell'] = 'продаЄт',
                        ['system_shop_buy'] = 'покупает',
                        ['system_shop_sell_buy'] = 'продаЄт и покупает',
                        ['system_shop_empty'] = 'пуста€',
                        ['system_shop_product_management'] = '”правлени€ товарами.',

                        ['system_regex_find_dialog_title_shop_id'] = '^Ћавка є%d+$',
                        ['system_regex_match_dialog_title_shop_id'] = '^Ћавка є(%d+)$',
                        ['system_regex_find_dialog_title_buy_product'] = '^ѕокупка предмета$',
                        ['system_regex_find_dialog_title_remove_sale'] = '^—н€тие с продажи$',
                        ['system_regex_gsub_dialog_text_item_match_item'] = 'ѕредмет: ',
                        ['system_regex_gsub_dialog_text_item_match_bottle'] = 'Ёликсир: ',
                        ['system_regex_gsub_dialog_text_item_match_accessory'] = 'јксессуар: ',

                        ['message_ad_push'] = '/findilavka #1# #2#',
                        ['message_ad_push_central_market'] = '/findilavka #1# (÷–) #2#',
                        ['message_ad_next_push_time'] = '{white}—ледующа€ реклама будет показана через {orange}#1# {white}мин.',
                        ['message_ad_push_error_active'] = '{red}–еклама не будет показана! {white}(функционал не активен)',
                        ['message_ad_push_error_number'] = '{red}–еклама не будет показана! {white}(неизвестен номер лавки)',
                        ['message_ad_push_error_message'] = '{red}–еклама не будет показана! {white}(нет задан текст)',

                        ['message_trade_add_product_count'] = '{green}#1# {blue}#2# {white}выставлен за {green}#3#',
                        ['message_trade_add_product'] = '{green}#1# {white}выставлен за {green}#2#',

                        ['message_trade_dialog_title'] = '{orange}¬ведите цену за предмет',
                        ['message_trade_dialog_button_yes'] = '{green}ƒобавить',
                        ['message_trade_dialog_button_no'] = '{red}ќтмена',

                        ['message_pricer_dialog_title'] = '{orange}¬ведите цену ( 0 - удалить )',
                        ['message_pricer_dialog_button_yes'] = '{green}√отово',
                        ['message_pricer_dialog_button_no'] = '{red}ќтмена',
                    }
                }
            },
        },
        {
            ['name'] = 'player',
            ['entity'] = 'dependencies.entitys.Player',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'boxManager',
            ['entity'] = 'dependencies.managers.BoxManager',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopTitle',
            ['entity'] = 'dependencies.entitys.ShopTitle',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopAdmin',
            ['entity'] = 'dependencies.entitys.ShopAdmin',
            ['init'] = true,
            ['args'] = {},
        },
        {
            ['name'] = 'shopManager',
            ['entity'] = 'dependencies.managers.ShopManager',
            ['init'] = true,
            ['args'] = {
                {
                    3861,
                    14211,
                    14210,
                }
            },
        },
        {
            ['name'] = 'swipe',
            ['entity'] = 'dependencies.commands.Swipe',
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
            ['name'] = 'hiding',
            ['entity'] = 'dependencies.commands.Hiding',
            ['init'] = true,
            ['args'] = {
                'hiding',
                {
                    ['active'] = true,
                    ['alpha'] = 80,
                },
                {
                    ['alpha'] = {
                        ['min'] = 0,
                        ['max'] = 100,
                    },
                },
            },
        },
        {
            ['name'] = 'scan',
            ['entity'] = 'dependencies.commands.Scan',
            ['init'] = true,
            ['args'] = {
                'scan',
                {
                    ['active'] = true,
                    ['add'] = false,
                    ['time'] = 500,
                },
                {
                    ['time'] = {
                        ['min'] = 200,
                        ['max'] = 1000,
                    },
                },
            },
        },
        {
            ['name'] = 'radius',
            ['entity'] = 'dependencies.commands.Radius',
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
                {
                    ['polygons'] = {
                        ['min'] = 24,
                        ['max'] = 48,
                    },
                    ['distance'] = {
                        ['min'] = 30,
                        ['max'] = 60,
                    },
                }
            },
        },
        {
            ['name'] = 'visit',
            ['entity'] = 'dependencies.commands.Visit',
            ['init'] = true,
            ['args'] = {
                'visit',
                {
                    ['active'] = true,
                    ['hiding'] = {
                        {
                            ['name'] = 'player',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'visit',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'buy',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'sell',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'edit',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'empty',
                            ['active'] = true,
                        },
                        {
                            ['name'] = 'time',
                            ['active'] = true,
                        },
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
                {
                    ['distance'] = {
                        ['min'] = 30,
                        ['max'] = 200,
                    },
                    ['time'] = {
                        ['min'] = 1,
                        ['max'] = 1440,
                    },
                },
            },
        },
        {
            ['name'] = 'select',
            ['entity'] = 'dependencies.commands.Select',
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
                {
                    ['border'] = {
                        ['min'] = 1,
                        ['max'] = 5,
                    },
                    ['alpha'] = {
                        ['min'] = 1,
                        ['max'] = 100,
                    },
                },
            },
        },
        {
            ['name'] = 'trade',
            ['entity'] = 'dependencies.commands.Trade',
            ['init'] = true,
            ['args'] = {
                'trade',
                {
                    ['active'] = false,
                },
            },
        },
        {
            ['name'] = 'pricer',
            ['entity'] = 'dependencies.commands.Pricer',
            ['init'] = true,
            ['args'] = {
                'pricer',
                {
                    ['active'] = false,
                    ['add'] = false,
                    ['border'] = 2,
                    ['commission'] = 3,
                },
                {
                    ['border'] = {
                        ['min'] = 1,
                        ['max'] = 5,
                    },
                    ['commission'] = {
                        ['min'] = 0,
                        ['max'] = 100,
                    },
                },
            },
        },
        {
            ['name'] = 'ad',
            ['entity'] = 'dependencies.commands.Ad',
            ['init'] = true,
            ['args'] = {
                'ad',
                {
                    ['active'] = false,
                    ['message'] = '',
                    ['time'] = 15,
                    ['pushAt'] = 0,
                    ['chats'] = {
                        {
                            ['name'] = 'vr',
                            ['active'] = false,
                        },
                        {
                            ['name'] = 's',
                            ['active'] = false,
                        },
                    }
                },
                {
                    ['time'] = {
                        ['min'] = 3,
                    },
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
    _sh.chat:addPrefix('[' .. _sh.script.name .. ']: ')
    _sh.chat:push('{' .. _sh.color:get('white') .. '}' .. _sh.script.name)
end

function main()
    while not isSampAvailable() do wait(0) end
    this:init()
    -- for _, command in ipairs(_sh.commands) do
    --     _sh.chat:push(command.command)
    -- end
end