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
            ['name'] = 'helper',
            ['entity'] = 'dependencies.entitys.Helper',
            ['init'] = true,
            ['args'] = {
                {
                    ['decode'] = {
                        ['_'] = ' ',
                        ['a'] = 'а',
                        ['A'] = 'А',
                        ['—'] = 'б',
                        ['Ђ'] = 'Б',
                        ['ў'] = 'в',
                        ['‹'] = 'В',
                        ['™'] = 'г',
                        ['‚'] = 'Г',
                        ['љ'] = 'д',
                        ['ѓ'] = 'Д',
                        ['e'] = 'е',
                        ['E'] = 'Е',
                        ['›'] = 'ж',
                        ['„'] = 'Ж',
                        ['џ'] = 'з',
                        ['€'] = 'З',
                        ['њ'] = 'и',
                        ['…'] = 'И',
                        ['ќ'] = 'й',
                        ['k'] = 'к',
                        ['K'] = 'К',
                        ['ћ'] = 'л',
                        ['‡'] = 'Л',
                        ['Ї'] = 'м',
                        ['M'] = 'М',
                        ['®'] = 'н',
                        ['H'] = 'Н',
                        ['o'] = 'о',
                        ['O'] = 'О',
                        ['Ј'] = 'п',
                        ['Њ'] = 'П',
                        ['p'] = 'р',
                        ['P'] = 'Р',
                        ['c'] = 'с',
                        ['C'] = 'С',
                        ['¦'] = 'т',
                        ['Џ'] = 'Т',
                        ['y'] = 'у',
                        ['Y'] = 'У',
                        ['?'] = 'ф',
                        ['Ѓ'] = 'Ф',
                        ['x'] = 'х',
                        ['X'] = 'Х',
                        ['$'] = 'ц',
                        ['‰'] = 'Ц',
                        ['¤'] = 'ч',
                        ['Ќ'] = 'Ч',
                        ['Ґ'] = 'ш',
                        ['Ћ'] = 'Ш',
                        ['Ў'] = 'щ',
                        ['Љ'] = 'Щ',
                        ['©'] = 'ь',
                        ['’'] = 'Ь',
                        ['ђ'] = 'ъ',
                        ['§'] = 'Ъ',
                        ['Ё'] = 'ы',
                        ['‘'] = 'Ы',
                        ['Є'] = 'э',
                        ['“'] = 'Э',
                        ['«'] = 'ю',
                        ['”'] = 'Ю',
                        ['¬'] = 'я',
                        ['•'] = 'Я',
                    },
                    ['encode'] = {
                        [' '] = '_',
                        ['а'] = 'a',
                        ['А'] = 'A',
                        ['б'] = '—',
                        ['Б'] = 'Ђ',
                        ['в'] = 'ў',
                        ['В'] = '‹',
                        ['г'] = '™',
                        ['Г'] = '‚',
                        ['д'] = 'љ',
                        ['Д'] = 'ѓ',
                        ['е'] = 'e',
                        ['Е'] = 'E',
                        ['ё'] = 'e',
                        ['Ё'] = 'E',
                        ['ж'] = '›',
                        ['Ж'] = '„',
                        ['з'] = 'џ',
                        ['З'] = '€',
                        ['и'] = 'њ',
                        ['И'] = '…',
                        ['й'] = 'ќ',
                        ['Й'] = '…',
                        ['к'] = 'k',
                        ['К'] = 'K',
                        ['л'] = 'ћ',
                        ['Л'] = '‡',
                        ['м'] = 'Ї',
                        ['М'] = 'M',
                        ['н'] = '®',
                        ['Н'] = 'H',
                        ['о'] = 'o',
                        ['О'] = 'O',
                        ['п'] = 'Ј',
                        ['П'] = 'Њ',
                        ['р'] = 'p',
                        ['Р'] = 'P',
                        ['с'] = 'c',
                        ['С'] = 'C',
                        ['т'] = '¦',
                        ['Т'] = 'Џ',
                        ['у'] = 'y',
                        ['У'] = 'Y',
                        ['ф'] = '?',
                        ['Ф'] = 'Ѓ',
                        ['х'] = 'x',
                        ['Х'] = 'X',
                        ['ц'] = '$',
                        ['Ц'] = '‰',
                        ['ч'] = '¤',
                        ['Ч'] = 'Ќ',
                        ['ш'] = 'Ґ',
                        ['Ш'] = 'Ћ',
                        ['щ'] = 'Ў',
                        ['Щ'] = 'Љ',
                        ['ь'] = '©',
                        ['Ь'] = '’',
                        ['ъ'] = 'ђ',
                        ['Ъ'] = '§',
                        ['ы'] = 'Ё',
                        ['Ы'] = '‘',
                        ['э'] = 'Є',
                        ['Э'] = '“',
                        ['ю'] = '«',
                        ['Ю'] = '”',
                        ['я'] = '¬',
                        ['Я'] = '•',
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
                        ['system_textdraw_shop_mod_buy'] = 'ПРОДАЖА',
                        ['system_textdraw_shop_mod_sale'] = 'СКУПКА',
                        ['system_textdraw_shop_shoping'] = 'МАГАЗИН',
                        ['system_textdraw_shop_admining'] = 'НА ПРОДАЖЕ',

                        ['system_shop_edit'] = 'редактирует',
                        ['system_shop'] = 'Лавка',
                        ['system_shop_sell'] = 'продаёт',
                        ['system_shop_buy'] = 'покупает',
                        ['system_shop_sell_buy'] = 'продаёт и покупает',
                        ['system_shop_empty'] = 'пустая',
                        ['system_shop_product_management'] = 'Управления товарами.',

                        ['system_regex_find_dialog_title_shop_id'] = '^Лавка №%d+$',
                        ['system_regex_find_dialog_title_buy_product'] = '^Покупка предмета$',
                        ['system_regex_find_dialog_title_remove_sale'] = '^Снятие с продажи$',
                        ['system_regex_find_dialog_title_ad_submitting'] = '^Подача объявления$',
                        ['system_regex_find_dialog_title_select_radio_station'] = '^Выберите радиостанцию$',
                        ['system_regex_find_dialog_title_ad_submitting_confirmation'] = '^Подача объявления | Подтверждение$',
                        ['system_regex_find_dialog_text_sale_product'] = '^Введите цену за товар.+$',
                        ['system_regex_find_dialog_text_sale_product_count'] = '^Введите количество и цену за один товар.+$',
                        ['system_regex_gsub_dialog_text_item_match_item'] = 'Предмет: ',
                        ['system_regex_gsub_dialog_text_item_match_bottle'] = 'Эликсир: ',
                        ['system_regex_gsub_dialog_text_item_match_accessory'] = 'Аксессуар: ',
                        ['system_regex_match_dialog_title_shop_id'] = '^Лавка №(%d+)$',

                        ['message_ad_push'] = '/findilavka #1# #2#',
                        ['message_ad_push_central_market'] = '/findilavka #1# (ЦР) #2#',
                        ['message_ad_next_push_time'] = '{white}Следующая реклама будет показана через {orange}#1# {white}мин.',
                        ['message_ad_push_error_active'] = '{red}Реклама не будет показана! {white}(функционал не активен)',
                        ['message_ad_push_error_number'] = '{red}Реклама не будет показана! {white}(неизвестен номер лавки)',
                        ['message_ad_push_error_message'] = '{red}Реклама не будет показана! {white}(нет задан текст)',

                        ['message_trade_add_product_count'] = '{green}#1# {blue}#2# {white}выставлен за {green}#3#',
                        ['message_trade_add_product'] = '{green}#1# {white}выставлен за {green}#2#',

                        ['message_dialog_title_enter_price'] = '{orange}Введите цену',
                        ['message_dialog_title_enter_price_zero'] = '{orange}Введите цену ( 0 - удалить )',

                        ['message_dialog_button_ready'] = '{green}Готово',
                        ['message_dialog_button_add'] = '{green}Добавить',
                        ['message_dialog_button_cancel'] = '{red}Отмена',

                        ['message_activated'] = '#1# {red}активирован',
                        ['message_deactivated'] = '#1# {red}деактивирован',

                        ['message_command_name_ad'] = 'Свайпер',
                        ['message_command_name_radius'] = 'Радиус лавок',
                        ['message_command_name_pricer'] = 'Указание цен',
                        ['message_command_name_hiding'] = 'Затемнение товаров',
                        ['message_command_name_scan'] = 'Сканирование товаров',
                        ['message_command_name_select'] = 'Выделение товаров',
                        ['message_command_name_swiper'] = 'Реклама лавки',
                        ['message_command_name_trade'] = 'Выставление по клику',
                        ['message_command_name_visit'] = 'Послещенные лавки',
                    }
                }
            },
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
            ['entity'] = 'dependencies.commands.SwipeCommand',
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
            ['entity'] = 'dependencies.commands.HidingCommand',
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
            ['entity'] = 'dependencies.commands.ScanCommand',
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
            ['entity'] = 'dependencies.commands.RadiusCommand',
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
            ['entity'] = 'dependencies.commands.VisitCommand',
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
            ['entity'] = 'dependencies.commands.SelectCommand',
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
            ['entity'] = 'dependencies.commands.TradeCommand',
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
            ['entity'] = 'dependencies.commands.PricerCommand',
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
            ['entity'] = 'dependencies.commands.AdCommand',
            ['init'] = true,
            ['args'] = {
                'ad',
                {
                    ['active'] = false,
                    ['message'] = '',
                    ['time'] = 10,
                    ['pushAt'] = 0,
                    ['chats'] = {
                        {
                            ['name'] = 'vr',
                            ['active'] = false,
                        },
                        {
                            ['name'] = 'ad',
                            ['active'] = false,
                        },
                        {
                            ['name'] = 'fam',
                            ['active'] = false,
                        },
                        {
                            ['name'] = 'al',
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
    for _, command in ipairs(_sh.commands) do
        _sh.chat:push(command.command)
    end
end