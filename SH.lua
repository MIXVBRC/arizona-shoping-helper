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
                ['name'] = 'inicfg',
                ['path'] = 'inicfg',
                ['sort'] = 1000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'dkjson',
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

            -- TRAITS

            
            {
                ['name'] = 'destructorTrait',
                ['path'] = 'dependencies.traits.DestructorTrait',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
        
            -- ENTITYS

            {
                ['name'] = 'cache',
                ['path'] = 'dependencies.entitys.Cache',
                ['sort'] = 2000,
                ['init'] = true,
                ['args'] = {},
            },
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
                    'ShopingHelper_base2',
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
                            ['system_textdraw_inventory'] = '���������',
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
                            ['system_regex_find_dialog_title_sale_product'] = '^������� ��������$',
                            ['system_regex_find_dialog_title_remove_sale'] = '^������ � �������$',
                            ['system_regex_find_dialog_title_ad_submitting'] = '^������ ����������$',
                            ['system_regex_find_dialog_title_select_radio_station'] = '^�������� ������������$',
                            ['system_regex_find_dialog_title_ad_submitting_confirmation'] = '^������ ���������� | �������������$',
                            ['system_regex_find_dialog_title_ad_cancel'] = '^������ ���������� ����������$',
                            ['system_regex_find_dialog_text_sale_product'] = '^������� ���� �� �����.+$',
                            ['system_regex_find_dialog_text_sale_product_count'] = '^������� ���������� � ���� �� ���� �����.+$',
                            ['system_regex_find_dialog_text_buy_product_count'] = '^� �������:%s%d+%s��%.$',
                            ['system_regex_find_dialog_text_buy_product_enough_count'] = '^����� ����� ������ �� %d+ ��%. ������%.$',
                            ['system_regex_find_dialog_text_vr'] = '^.*���� ��������� �������� ��������%?.*$',
                            ['system_regex_find_chat_sale_product'] = '^%[����������%] ����� .+ ������� ��������� �� �������!$',
                            ['system_regex_find_chat_remove_sale_product'] = '^%[����������%] ����� .+ ������� ������ �� �������!$',

                            ['system_regex_gsub_dialog_text_item_match_item'] = '�������: ',
                            ['system_regex_gsub_dialog_text_item_match_bottle'] = '�������: ',
                            ['system_regex_gsub_dialog_text_item_match_accessory'] = '���������: ',

                            ['system_regex_gsub_ad_command_shop_id'] = '/findilavka #1#',

                            ['system_regex_match_dialog_title_shop_id'] = '^����� �(%d+)$',
                            ['system_regex_match_dialog_text_buy_product_count'] = '^� �������:%s(%d+)%s��%.$',
                            ['system_regex_match_dialog_text_buy_product_enough_count'] = '^����� ����� ������ �� (%d+) ��%. ������%.$',
                            ['system_regex_match_dialog_text_sale_product'] = '^������� ���� �� ����� %( (.+) %)$',
                            ['system_regex_match_dialog_text_sale_product_count'] = '^������� ���������� � ���� �� ���� ����� %( (.+) %).+$',

                            ['message_ad_next_push_time'] = '{white}����� ������� ����� {orange}#1# {white}���.',
                            ['message_ad_next_push_ad_message'] = '{white}���� ����������: {grey}#1#',
                            ['message_ad_push_error_shop_id'] = '���������� ����� ����� (��������� � ���� �����)',
                            ['message_ad_push_error_defender'] = '������ �� ���� ���������� ���������',
                            ['message_ad_push_error_ad_len'] = '������� ������ ��������� �� 20 �� 80 ��������',
                            ['message_ad_push_error_ad_len_entered'] = '�� ����� #1# ��������',
                            ['message_ad_push_error_chat_name'] = '��� #1#',
                            ['message_ad_push_error_message'] = '#1# - #2#',

                            ['message_ad_dialog_title_list'] = '{orange}��������� ���������',
                            ['message_ad_dialog_title_select'] = '{orange}��������� ���������',
                            ['message_ad_dialog_title_add'] = '{orange}������� � ��� {green}/#1#',
                            ['message_ad_dialog_title_chat_select'] = '{orange}�������� ���',
                            ['message_ad_dialog_title_chat'] = '{orange}��� {green}/#1#',
                            ['message_ad_dialog_message_add_1'] = '{white}����������� ��������:',
                            ['message_ad_dialog_message_add_1_1'] = '{orange}#shopid# {white}- id ����� (���� ��������, ��������� � ���� �����)',
                            ['message_ad_dialog_message_add_1_2'] = '{orange}#shop# {white}- ������� � id �����',
                            ['message_ad_dialog_message_add_2'] = '{white}������ ���������:',
                            ['message_ad_dialog_message_add_2_1'] = '{white}#shop# - �������� ��� �� ������ ����!',
                            ['message_ad_dialog_message_add_3'] = '{white}� ���������� ���������:',
                            ['message_ad_dialog_message_add_3_1'] = '{white}/findilavka 99 - �������� ��� �� ������ ����!',
                            ['message_ad_dialog_message_add_4'] = '{orange}�� �������� ��� �������� �� ����!',
                            ['message_ad_dialog_message_add_5'] = '{grey}��������� ��������� ������ ��������� �� 20 �� 80 ��������',
                            ['message_ad_dialog_table_chat'] = '���',
                            ['message_ad_dialog_table_active'] = '����������',
                            ['message_ad_dialog_table_message'] = '���������',
                            ['message_ad_dialog_text_chat'] = '{white}���: {orange}#1#{white}',
                            ['message_ad_dialog_text_chat_time'] = '{white}��������: {orange}#1# ���{white}',
                            ['message_ad_dialog_text_chat_time_left'] = '{white}���������� �����: {orange}#1# ���{white}',
                            ['message_ad_dialog_text_chat_reset_time'] = '{white}�������� ���������� �����{white}',
                            ['message_ad_dialog_text_name'] = '{white}��������: {orange}#1#{white}',
                            ['message_ad_dialog_text_price'] = '{white}����: {green}#1#{white}',
                            ['message_ad_dialog_text_active'] = '{white}�������: #1#{white}',
                            ['message_ad_dialog_text_yes'] = '{green}��{white}',
                            ['message_ad_dialog_text_no'] = '{red}���{white}',
                            ['message_ad_dialog_text_len'] = '{white}��������: {grey}#1#{white}',
                            ['message_ad_dialog_text_text'] = '{white}�����: {grey}#1#{white}',
                            ['message_ad_dialog_text_result'] = '{white}���������: {grey}#1#{white}',
                            ['message_ad_dialog_text_errors'] = '{red}������:{white}',
                            ['message_ad_dialog_text_error'] = '{red}#1#{white}',
                            ['message_ad_dialog_text_delete'] = '{red}�������{white}',
                            ['message_ad_dialog_text_message_count'] = '{white}��������� ���������: {orange}#1#{white}',

                            ['message_ad_init_shop_id'] = '{white}ID ����� ����� {orange}#1#',

                            ['message_buyer_buy_error_price'] = '���� �������� ���� ������������� ����',

                            ['message_trade_add_product_count'] = '{green}#1# {blue}#2# {white}��������� �� {green}#3#',
                            ['message_trade_add_product'] = '{green}#1# {white}��������� �� {green}#2#',

                            ['message_dialog_title_enter_price'] = '{orange}������� ����',
                            ['message_dialog_title_enter_price_zero'] = '{orange}������� ���� ( 0 - ������� )',
                            ['message_dialog_title_remove_product'] = '{orange}�������� �������',
                            ['message_dialog_title_change_product'] = '{orange}��������� �������',

                            ['message_dialog_button_ready'] = '{white}������',
                            ['message_dialog_button_add'] = '{white}��������',
                            ['message_dialog_button_select'] = '{white}�������',
                            ['message_dialog_button_change'] = '{white}��������',
                            ['message_dialog_button_delete'] = '{white}�������',
                            ['message_dialog_button_back'] = '{white}�����',
                            ['message_dialog_button_cancel'] = '{white}������',

                            ['message_dialog_table_title_name'] = '��������',
                            ['message_dialog_table_title_price'] = '����',
                            ['message_dialog_table_title_mod'] = '���',

                            ['message_mod_buy'] = '{green}�������',
                            ['message_mod_sale'] = '{blue}������',

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
                        ['grey'] = '808080',
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
                ['name'] = 'error',
                ['path'] = 'dependencies.entitys.Error',
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
            {
                ['name'] = 'queueProcess',
                ['path'] = 'dependencies.entitys.QueueProcess',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'text3d',
                ['path'] = 'dependencies.entitys.Text3d',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
        
            -- MANAGERS
        
            {
                ['name'] = 'threadManager',
                ['path'] = 'dependencies.managers.ThreadManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'eventManager',
                ['path'] = 'dependencies.managers.EventManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
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
                ['name'] = 'renderManager',
                ['path'] = 'dependencies.managers.RenderManager',
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
                ['name'] = 'drawManager',
                ['path'] = 'dependencies.managers.DrawManager',
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
            {
                ['name'] = 'queueManager',
                ['path'] = 'dependencies.managers.QueueManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'serverManager',
                ['path'] = 'dependencies.managers.ServerManager',
                ['sort'] = 3000,
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'text3dManager',
                ['path'] = 'dependencies.managers.Text3dManager',
                ['sort'] = 3000,
                ['init'] = false,
                ['args'] = {},
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
                        ['active'] = false,
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
                        ['active'] = false,
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
                        ['active'] = false,
                        ['player'] = false,
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
                        ['active'] = false,
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
                        ['xray'] = true,
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
                        ['add'] = false,
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
                        ['chats'] = {
                            {
                                ['name'] = 'vr',
                                ['active'] = false,
                                ['time'] = 10,
                                ['left'] = 0,
                            },
                            {
                                ['name'] = 'ad',
                                ['active'] = false,
                                ['time'] = 10,
                                ['left'] = 0,
                            },
                            {
                                ['name'] = 'fam',
                                ['active'] = false,
                                ['time'] = 10,
                                ['left'] = 0,
                            },
                            {
                                ['name'] = 'al',
                                ['active'] = false,
                                ['time'] = 10,
                                ['left'] = 0,
                            },
                            {
                                ['name'] = 's',
                                ['active'] = false,
                                ['time'] = 10,
                                ['left'] = 0,
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
            {
                ['name'] = 'buyer',
                ['path'] = 'dependencies.commands.BuyerCommand',
                ['sort'] = 4000,
                ['init'] = true,
                ['args'] = {
                    'buyer',
                    {
                        ['active'] = false,
                        ['price'] = 100000,
                        ['count'] = 1,
                    },
                    {
                        ['price'] = {
                            ['min'] = 0,
                        },
                        ['count'] = {
                            ['min'] = 1,
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

    function this:get(name)
        return private.classes[name]
    end

    function private:add(name, _class)
        private.classes[name] = _class
        return this
    end

    function this:getNew(name, ...)
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
                private:add(entity.name, this:getNew(entity.name, table.unpack(entity.args)))
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
        script:get('chat'):setColor(script:get('color'):get('orange'))
        script:get('chat'):addPrefix('[' .. value.name .. ']: ')
        script:get('chat'):push('{' .. script:get('color'):get('white') .. '}' .. value.name)
    end
end