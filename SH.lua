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
                ['name'] = 'moownloader',
                ['path'] = 'moonloader',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'md5',
                ['path'] = 'md5',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'ini',
                ['path'] = 'inicfg',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'json',
                ['path'] = 'dkjson',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'events',
                ['path'] = 'lib.samp.events',
                ['init'] = false,
                ['args'] = {},
            },
        
            -- ENTITYS
        
            {
                ['name'] = 'cache',
                ['path'] = 'dependencies.entitys.Cache',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'point',
                ['path'] = 'dependencies.entitys.Point',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'circle',
                ['path'] = 'dependencies.entitys.Circle',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'helper',
                ['path'] = 'dependencies.entitys.Helper',
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
                ['name'] = 'config',
                ['path'] = 'dependencies.entitys.Config',
                ['init'] = true,
                ['args'] = {
                    'ShopingHelper_base',
                    {},
                },
            },
            {
                ['name'] = 'message',
                ['path'] = 'dependencies.entitys.Message',
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
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'minMax',
                ['path'] = 'dependencies.entitys.MinMax',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'color',
                ['path'] = 'dependencies.entitys.Color',
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
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'lowPoint',
                ['path'] = 'dependencies.entitys.LowPoint',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'dialog',
                ['path'] = 'dependencies.entitys.Dialog',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'textdraw',
                ['path'] = 'dependencies.entitys.Textdraw',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'product',
                ['path'] = 'dependencies.entitys.Product',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'exception',
                ['path'] = 'dependencies.entitys.Exception',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'error',
                ['path'] = 'dependencies.entitys.Error',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'font',
                ['path'] = 'dependencies.entitys.Font',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopTitle',
                ['path'] = 'dependencies.entitys.ShopTitle',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopAdmin',
                ['path'] = 'dependencies.entitys.ShopAdmin',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'render',
                ['path'] = 'dependencies.entitys.Render',
                ['dependencies'] = {
                    'threadManager',
                },
                ['init'] = true,
                ['args'] = {},
            },
        
            -- MANAGERS
        
            {
                ['name'] = 'playerManager',
                ['path'] = 'dependencies.managers.PlayerManager',
                ['dependencies'] = {
                    'threadManager',
                    'eventManager',
                    'dialogManager',
                    'shopManager',
                    'helper',
                    'message',
                },
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'circleManager',
                ['path'] = 'dependencies.managers.CircleManager',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'configManager',
                ['path'] = 'dependencies.managers.ConfigManager',
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'commandManager',
                ['path'] = 'dependencies.managers.CommandManager',
                ['init'] = true,
                ['args'] = {
                    'active',
                },
            },
            {
                ['name'] = 'eventManager',
                ['path'] = 'dependencies.managers.EventManager',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'dialogManager',
                ['path'] = 'dependencies.managers.DialogManager',
                ['init'] = true,
                ['args'] = {
                    777,
                },
            },
            {
                ['name'] = 'threadManager',
                ['path'] = 'dependencies.managers.ThreadManager',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'productManager',
                ['path'] = 'dependencies.managers.ProductManager',
                ['init'] = true,
                ['args'] = {
                    'productManager',
                },
            },
            {
                ['name'] = 'textdrawManager',
                ['path'] = 'dependencies.managers.TextdrawManager',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'boxManager',
                ['path'] = 'dependencies.managers.BoxManager',
                ['init'] = true,
                ['args'] = {},
            },
            {
                ['name'] = 'shopManager',
                ['path'] = 'dependencies.managers.ShopManager',
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
                ['dependencies'] = {
                    'configManager',
                    'threadManager',
                    'eventManager',
                    'playerManager',
                    'commandManager',
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
                ['name'] = 'hiding',
                ['path'] = 'dependencies.commands.HidingCommand',
                ['dependencies'] = {
                    'minMax',
                    'configManager',
                    'threadManager',
                    'commandManager',
                    'helper',
                    'dialogManager',
                    'swipe',
                    'boxManager',
                    'productManager',
                    'color',
                },
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
                ['dependencies'] = {
                    'minMax',
                    'configManager',
                    'threadManager',
                    'eventManager',
                    'helper',
                    'player',
                },
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
                ['dependencies'] = {
                    'minMax',
                    'configManager',
                    'lowPoint',
                    'cache',
                    'commandManager',
                    'helper',
                    'threadManager',
                    'playerManager',
                    'circleManager',
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
                ['dependencies'] = {
                    'minMax',
                    'configManager',
                    'cache',
                    'commandManager',
                    'helper',
                    'threadManager',
                    'playerManager',
                    'eventManager',
                    'shopManager',
                    'message',
                    'color',
                    'render',
                    'font',
                },
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
                ['dependencies'] = {
                    'minMax',
                    'configManager',
                    'commandManager',
                    'helper',
                    'threadManager',
                    'eventManager',
                    'scan',
                    'playerManager',
                    'dialogManager',
                    'swipe',
                    'productManager',
                    'boxManager',
                    'color',
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
                ['dependencies'] = {
                    'configManager',
                    'commandManager',
                    'eventManager',
                    'playerManager',
                    'textdrawManager',
                    'helper',
                    'message',
                    'chat',
                    'dialogManager',
                    'message',
                },
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
local count = 1
local this = {}
function this:new(_name, _author, _version, _url, _command, _entities)
    local class = {}
    local private = {
        ['name'] = _name,
        ['author'] = _author or 'anonim',
        ['version'] = _version or '1.0.0',
        ['url'] = _url or '',
        ['command'] = _command,
        ['entities'] = _entities,
        ['objects'] = {},
        ['classes'] = {},
        ['commands'] = {},
    }

    function class:getCommand()
        return private.command
    end

    function class:getCommands()
        return private.commands
    end

    function class:addCommand(command)
        table.insert(private.commands, command)
        return class
    end

    function private:getEntities()
        return private.entities
    end

    function private:getEntity(name)
        for _, entity in ipairs(private:getEntities()) do
            if name == entity.name then
                return entity
            end
        end
        return nil
    end

    function class:getObject(name)
        return private.objects[name]
    end

    function class:addObject(name, object)
        private.objects[name] = object
        return class
    end

    function class:getClass(name)
        count = count + 1
        print(count)
        if private.classes[name] == nil then
            local entity = private:getEntity(name)
            if entity ~= nil then
                private:addClass(entity.name, private:getNewClass(entity.name, entity.args))
            end
        end
        return private.classes[name]
    end

    function private:getNewClass(name, args)
        return class:getObject(name):new(class, table.unpack(args))
    end

    function private:addClass(name, _class)
        private.classes[name] = _class
        return class
    end

    function class:getNewClass(name, args)
        return this:getObject(name):new(class, table.unpack(args))
    end

    function private:init()
        private:initObjects():initClasses()
        return class
    end

    function private:initObjects()
        for _, entity in ipairs(private:getEntities()) do
            class:addObject(entity.name, require(entity.path))
        end
        return private
    end

    function private:initClasses()
        for _, entity in ipairs(private:getEntities()) do
            if entity.init then
                private:addClass(entity.name, private:getNewClass(entity.name, entity.args))
            end
        end
        return private
    end

    return private:init()
end

-- function this:getDependencyByName(name)
--     for _, object in ipairs(this.objects) do
--         if name == object.name then
--             return object
--         end
--     end
--     return nil
-- end

-- local count = 0
-- function this:initDependency(object)
--     count = count + 1
--     if object.init then
--         if object.dependencies ~= nil then
--             for _, dependency in ipairs(object.dependencies) do
--                 this:initDependency(dependency)
--             end
--         end
--         if _G[this.name][object.name] == nil and _G[this.name].objects[object.name] ~= nil then
--             _G[this.name][object.name] = _G[this.name].objects[object.name]:new(table.unpack(object.args))
--         end
--     end
-- end

-- function this:initDependencies()
--     -- for _, object in pairs(this.objects) do
--     --     _sh.dependencies[object.name] = require(object.entity)
--     --     if object.init and _sh.dependencies[object.name] ~= nil then
--     --         _sh[object.name] = _sh.dependencies[object.name]:new(table.unpack(object.args))
--     --     end
--     -- end

--     for _, object in ipairs(this.objects) do
--         _G[this.name].objects[object.name] = require(object.entity)
--         if object.dependencies ~= nil then
--             for index, name in ipairs(object.dependencies) do
--                 object.dependencies[index] = this:getDependencyByName(name)
--             end
--         end
--     end

--     for _, object in pairs(this.objects) do
--         this:initDependency(object)
--     end
--     print(count)
-- end

-- function this:init()
--     _G[this.name] = this
--     this:initDependencies()
--     _G[this.name].chat:setColor(_G[this.name].color:get('orange'))
--     _G[this.name].chat:addPrefix('[' .. _G[this.name].script.name .. ']: ')
--     _G[this.name].chat:push('{' .. _G[this.name].color:get('white') .. '}' .. _G[this.name].script.name)
-- end

function main()
    while not isSampAvailable() do wait(0) end
    for _, value in ipairs(data) do
        local script = this:new(
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