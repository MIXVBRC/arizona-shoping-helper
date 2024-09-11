local data = {
    {
        ['name'] = 'Shoping Helper',
        ['author'] = 'MIXVBRC',
        ['version'] = '1.0.0',
        ['url'] = 'https://vk.com/mixvbrc',
        ['command'] = 'sh',
        ['entities'] = {

            -- LIBRARIES
        
            {
                ['name'] = 'moonloader',
                ['path'] = 'moonloader',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'md5',
                ['path'] = 'md5',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'ini',
                ['path'] = 'inicfg',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'json',
                ['path'] = 'dkjson',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'events',
                ['path'] = 'lib.samp.events',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
        
            -- ENTITYS
            {
                ['name'] = 'helper',
                ['path'] = 'dependencies.entitys.Helper',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {
                    {
                        ['decode'] = {
                            ['_'] = ' ',
                            ['a'] = '�',
                            ['A'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['e'] = '�',
                            ['E'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['k'] = '�',
                            ['K'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['M'] = '�',
                            ['�'] = '�',
                            ['H'] = '�',
                            ['o'] = '�',
                            ['O'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['p'] = '�',
                            ['P'] = '�',
                            ['c'] = '�',
                            ['C'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['y'] = '�',
                            ['Y'] = '�',
                            ['?'] = '�',
                            ['�'] = '�',
                            ['x'] = '�',
                            ['X'] = '�',
                            ['$'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                        },
                        ['encode'] = {
                            [' '] = '_',
                            ['�'] = 'a',
                            ['�'] = 'A',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = 'e',
                            ['�'] = 'E',
                            ['�'] = 'e',
                            ['�'] = 'E',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = 'k',
                            ['�'] = 'K',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = 'M',
                            ['�'] = '�',
                            ['�'] = 'H',
                            ['�'] = 'o',
                            ['�'] = 'O',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = 'p',
                            ['�'] = 'P',
                            ['�'] = 'c',
                            ['�'] = 'C',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = 'y',
                            ['�'] = 'Y',
                            ['�'] = '?',
                            ['�'] = '�',
                            ['�'] = 'x',
                            ['�'] = 'X',
                            ['�'] = '$',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                            ['�'] = '�',
                        },
                    }
                },
            },
            {
                ['name'] = 'cache',
                ['path'] = 'dependencies.entitys.Cache',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'point',
                ['path'] = 'dependencies.entitys.Point',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'circle',
                ['path'] = 'dependencies.entitys.Circle',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'config',
                ['path'] = 'dependencies.entitys.Config',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {
                    'ShopingHelper_base',
                    {},
                },
            },
            {
                ['name'] = 'message',
                ['path'] = 'dependencies.entitys.Message',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {
                    'rus',
                    'ShopingHelper_langs',
                    {
                        ['rus'] = {
                            ['system_textdraw_shop_mod_buy'] = '�������',
                            ['system_textdraw_shop_mod_sale'] = '������',
                            ['system_textdraw_shop_shoping'] = '�������',
                            ['system_textdraw_shop_admining'] = '�� �������',
        
                            ['system_shop_edit'] = '�����������',
                            ['system_shop'] = '�����',
                            ['system_shop_sell'] = '������',
                            ['system_shop_buy'] = '��������',
                            ['system_shop_sell_buy'] = '������ � ��������',
                            ['system_shop_empty'] = '������',
                            ['system_shop_product_management'] = '���������� ��������.',
        
                            ['system_regex_find_dialog_title_shop_id'] = '^����� �%d+$',
                            ['system_regex_find_dialog_title_buy_product'] = '^������� ��������$',
                            ['system_regex_find_dialog_title_remove_sale'] = '^������ � �������$',
                            ['system_regex_find_dialog_title_ad_submitting'] = '^������ ����������$',
                            ['system_regex_find_dialog_title_select_radio_station'] = '^�������� ������������$',
                            ['system_regex_find_dialog_title_ad_submitting_confirmation'] = '^������ ���������� | �������������$',
                            ['system_regex_find_dialog_text_sale_product'] = '^������� ���� �� �����.+$',
                            ['system_regex_find_dialog_text_sale_product_count'] = '^������� ���������� � ���� �� ���� �����.+$',
                            ['system_regex_gsub_dialog_text_item_match_item'] = '�������: ',
                            ['system_regex_gsub_dialog_text_item_match_bottle'] = '�������: ',
                            ['system_regex_gsub_dialog_text_item_match_accessory'] = '���������: ',
                            ['system_regex_match_dialog_title_shop_id'] = '^����� �(%d+)$',
        
                            ['message_ad_push'] = '/findilavka #1# #2#',
                            ['message_ad_push_central_market'] = '/findilavka #1# (��) #2#',
                            ['message_ad_next_push_time'] = '{white}��������� ������� ����� �������� ����� {orange}#1# {white}���.',
                            ['message_ad_push_error_active'] = '{red}������� �� ����� ��������! {white}(���������� �� �������)',
                            ['message_ad_push_error_number'] = '{red}������� �� ����� ��������! {white}(���������� ����� �����)',
                            ['message_ad_push_error_message'] = '{red}������� �� ����� ��������! {white}(��� ����� �����)',
        
                            ['message_trade_add_product_count'] = '{green}#1# {blue}#2# {white}��������� �� {green}#3#',
                            ['message_trade_add_product'] = '{green}#1# {white}��������� �� {green}#2#',
        
                            ['message_dialog_title_enter_price'] = '{orange}������� ����',
                            ['message_dialog_title_enter_price_zero'] = '{orange}������� ���� ( 0 - ������� )',
        
                            ['message_dialog_button_ready'] = '{green}������',
                            ['message_dialog_button_add'] = '{green}��������',
                            ['message_dialog_button_cancel'] = '{red}������',
        
                            ['message_activated'] = '#1# {red}�����������',
                            ['message_deactivated'] = '#1# {red}�������������',
        
                            ['message_command_name_ad'] = '�������',
                            ['message_command_name_radius'] = '������ �����',
                            ['message_command_name_pricer'] = '�������� ���',
                            ['message_command_name_hiding'] = '���������� �������',
                            ['message_command_name_scan'] = '������������ �������',
                            ['message_command_name_select'] = '��������� �������',
                            ['message_command_name_swiper'] = '������� �����',
                            ['message_command_name_trade'] = '����������� �� �����',
                            ['message_command_name_visit'] = '����������� �����',
                        }
                    }
                },
            },
            {
                ['name'] = 'shop',
                ['path'] = 'dependencies.entitys.Shop',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'minMax',
                ['path'] = 'dependencies.entitys.MinMax',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'color',
                ['path'] = 'dependencies.entitys.Color',
                ['sort'] = 2000,
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
                ['path'] = 'dependencies.entitys.Chat',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'lowPoint',
                ['path'] = 'dependencies.entitys.LowPoint',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'dialog',
                ['path'] = 'dependencies.entitys.Dialog',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'textdraw',
                ['path'] = 'dependencies.entitys.Textdraw',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'product',
                ['path'] = 'dependencies.entitys.Product',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'exception',
                ['path'] = 'dependencies.entitys.Exception',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'error',
                ['path'] = 'dependencies.entitys.Error',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'font',
                ['path'] = 'dependencies.entitys.Font',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopTitle',
                ['path'] = 'dependencies.entitys.ShopTitle',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopAdmin',
                ['path'] = 'dependencies.entitys.ShopAdmin',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
        
            -- MANAGERS
        
            {
                ['name'] = 'circleManager',
                ['path'] = 'dependencies.managers.CircleManager',
                ['sort'] = 3000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'configManager',
                ['path'] = 'dependencies.managers.ConfigManager',
                ['sort'] = 3000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'commandManager',
                ['path'] = 'dependencies.managers.CommandManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {
                    'active',
                },
            },
            {
                ['name'] = 'eventManager',
                ['path'] = 'dependencies.managers.EventManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'playerManager',
                ['path'] = 'dependencies.managers.PlayerManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'dialogManager',
                ['path'] = 'dependencies.managers.DialogManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {
                    777,
                },
            },
            {
                ['name'] = 'threadManager',
                ['path'] = 'dependencies.managers.ThreadManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'render',
                ['path'] = 'dependencies.entitys.Render',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'productManager',
                ['path'] = 'dependencies.managers.ProductManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {
                    'productManager',
                },
            },
            {
                ['name'] = 'textdrawManager',
                ['path'] = 'dependencies.managers.TextdrawManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'boxManager',
                ['path'] = 'dependencies.managers.BoxManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopManager',
                ['path'] = 'dependencies.managers.ShopManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {
                    {
                        3861,
                        14211,
                        14210,
                    }
                },
            },

            -- COMMANDS

            {
                ['name'] = 'swipe',
                ['path'] = 'dependencies.commands.SwipeCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.HidingCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.ScanCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.RadiusCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.VisitCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.SelectCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.TradeCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.PricerCommand',
                ['sort'] = 4000,
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
                ['path'] = 'dependencies.commands.AdCommand',
                ['sort'] = 4000,
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
}

local class = {}
function class:new(_name, _author, _version, _url, _command, _entities)
    local this = {}
    local private = {
        ['name'] = _name,
        ['author'] = _author or 'anonim',
        ['version'] = _version or '1.0.0',
        ['url'] = _url or '',
        ['command'] = _command,
        ['entities'] = _entities,
        ['objects'] = {},
        ['classes'] = {},
    }

    -- COMMAND

    function this:getCommand()
        return private.command
    end

    -- ENTITIES

    function private:getEntities()
        return private.entities
    end

    -- OBJECTS

    function this:getObject(name)
        return private.objects[name]
    end

    function this:addObject(name, object)
        private.objects[name] = object
        return this
    end

    -- CLASSES

    function this:getClass(name)
        return private.classes[name]
    end

    function private:addClass(name, _class)
        private.classes[name] = _class
        return this
    end

    function this:getNewClass(name, ...)
        return this:getObject(name):new(this, ...)
    end

    -- INITS

    function private:init()
        private:initObjects():initCommands()
        return this
    end

    function private:initObjects()
        for _, entity in ipairs(private:getEntities()) do
            this:addObject(entity.name, require(entity.path))
        end
        return private
    end

    function private:initCommands()
        for _, entity in ipairs(private:getEntities()) do
            if entity.init then
                private:addClass(entity.name, this:getNewClass(entity.name, table.unpack(entity.args)))
            end
        end
        return private
    end

    return private:init()
end

function main()
    while not isSampAvailable() do wait(0) end
    for _, value in ipairs(data) do
        local script = class:new(
            value.name,
            value.author,
            value.version,
            value.url,
            value.command,
            value.entities
        )
        script:getClass('chat'):setColor(script:getClass('color'):get('orange'))
        script:getClass('chat'):addPrefix('[' .. value.name .. ']: ')
        script:getClass('chat'):push('{' .. script:getClass('color'):get('white') .. '}' .. value.name)
    end
end