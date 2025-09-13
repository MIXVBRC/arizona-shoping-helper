-- this file need win-1251 not utf-8 !!!

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
                    {
                        ['rus'] = {
                            ['system_textdraw_inventory'] = 'ИНВЕНТАРЬ',
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

                            ['system_regex_find_text_shop_id'] = '^Лавка №%d+$',
                            ['system_regex_find_text_shop_admining'] = '^Управления товарами.$',
                            ['system_regex_find_text_shop_title'] = '^%a+_%a+%s{......}.+{......}.+$',
                            ['system_regex_find_dialog_title_shop_id'] = '^Лавка №%d+$',
                            ['system_regex_find_dialog_title_buy_product'] = '^Покупка предмета$',
                            ['system_regex_find_dialog_title_sale_product'] = '^Продажа предмета$',
                            ['system_regex_find_dialog_title_remove_sale'] = '^Снятие с продажи$',
                            ['system_regex_find_dialog_title_ad_submitting'] = '^Подача объявления$',
                            ['system_regex_find_dialog_title_select_radio_station'] = '^Выберите радиостанцию$',
                            ['system_regex_find_dialog_title_ad_submitting_confirmation'] = '^Подача объявления | Подтверждение$',
                            ['system_regex_find_dialog_title_ad_cancel'] = '^Отмена публикации объявления$',
                            ['system_regex_find_dialog_text_sale_product'] = '^Введите цену за товар.+$',
                            ['system_regex_find_dialog_text_sale_product_count'] = '^Введите количество и цену за один товар.+$',
                            ['system_regex_find_dialog_text_buy_product_count'] = '^В наличии:%s%d+%sшт%.$',
                            ['system_regex_find_dialog_text_buy_product_enough_count'] = '^Ваших денег хватит на %d+ ед%. товара%.$',
                            ['system_regex_find_dialog_text_vr'] = '^.*Ваше сообщение является рекламой%?.*$',
                            ['system_regex_find_chat_sale_product'] = '^%[Информация%] Товар .+ успешно выставлен на продажу!$',
                            ['system_regex_find_chat_remove_sale_product'] = '^%[Информация%] Товар .+ успешно удален из продажи!$',
                            ['system_regex_find_chat_shop_is_empty'] = '^%[Ошибка%] В этом магазине нет товаров!$',
                            ['system_regex_find_chat_shop_is_close'] = '^%[Информация%] Ваша лавка была закрыта, из-за того что вы её покинули!$',

                            ['system_regex_gsub_dialog_text_item_match_item'] = 'Предмет: ',
                            ['system_regex_gsub_dialog_text_item_match_bottle'] = 'Эликсир: ',
                            ['system_regex_gsub_dialog_text_item_match_accessory'] = 'Аксессуар: ',

                            ['system_regex_gsub_ad_command_shop_id'] = '/findilavka #1#',

                            ['system_regex_match_dialog_title_shop_id'] = '^Лавка №(%d+)$',
                            ['system_regex_match_dialog_text_buy_product_count'] = '^В наличии:%s(%d+)%sшт%.$',
                            ['system_regex_match_dialog_text_buy_product_enough_count'] = '^Ваших денег хватит на (%d+) ед%. товара%.$',
                            ['system_regex_match_dialog_text_sale_product'] = '^Введите цену за товар %( (.+) %)$',
                            ['system_regex_match_dialog_text_sale_product_count'] = '^Введите количество и цену за один товар %( (.+) %).+$',

                            ['message_ad_next_push_time'] = '{white}Показ рекламы через {orange}#1# {white}мин.',
                            ['message_ad_next_push_ad_message'] = '{white}Ваше объявление: {grey}#1#',
                            ['message_ad_push_error_shop_id'] = 'Неизвестен номер лавки (загляните в свою лавку)',
                            ['message_ad_push_error_defender'] = 'Защита от пуша рекламного сообщения',
                            ['message_ad_push_error_ad_len'] = 'Реклама должна содержать от 20 до 80 символов',
                            ['message_ad_push_error_ad_len_entered'] = 'Вы ввели #1# символов',
                            ['message_ad_push_error_chat_name'] = 'Чат #1#',
                            ['message_ad_push_error_message'] = '#1# - #2#',

                            ['message_ad_dialog_title_list'] = '{orange}Рекламные сообщения',
                            ['message_ad_dialog_title_select'] = '{orange}Рекламное сообщение',
                            ['message_ad_dialog_title_add'] = '{orange}Реклама в чат {green}/#1#',
                            ['message_ad_dialog_title_change_time'] = '{orange}Введите время в минутах ',
                            ['message_ad_dialog_title_chat_select'] = '{orange}Выберите чат',
                            ['message_ad_dialog_title_chat'] = '{orange}Чат {green}/#1#',
                            ['message_ad_dialog_message_add_1'] = '{white}Подстановка значений:',
                            ['message_ad_dialog_message_add_1_1'] = '{orange}#shopid# {white}- id лавки (если известен, загляните в свою лавку)',
                            ['message_ad_dialog_message_add_1_2'] = '{orange}#shop# {white}- команда и id лавки',
                            ['message_ad_dialog_message_add_2'] = '{white}Пример сообщения:',
                            ['message_ad_dialog_message_add_2_1'] = '{white}#shop# - Найдется все по низкой цене!',
                            ['message_ad_dialog_message_add_3'] = '{white}В результате выведется:',
                            ['message_ad_dialog_message_add_3_1'] = '{white}/findilavka 99 - Найдется все по низкой цене!',
                            ['message_ad_dialog_message_add_4'] = '{orange}Не забудьте про смайлики из чата!',
                            ['message_ad_dialog_message_add_5'] = '{grey}Рекламное сообщение должно содержать от 20 до 80 символов',
                            ['message_ad_dialog_table_chat'] = 'Чат',
                            ['message_ad_dialog_table_active'] = 'Активность',
                            ['message_ad_dialog_table_message'] = 'Сообщение',
                            ['message_ad_dialog_text_chat'] = '{white}Чат: {orange}#1#{white}',
                            ['message_ad_dialog_text_chat_time'] = '{white}Задержка: {orange}#1# мин{white}',
                            ['message_ad_dialog_text_chat_time_left'] = '{white}Оставшееся время: {orange}#1# мин{white}',
                            ['message_ad_dialog_text_chat_reset_time'] = '{white}Сбросить оставшееся время{white}',
                            ['message_ad_dialog_text_name'] = '{white}Название: {orange}#1#{white}',
                            ['message_ad_dialog_text_price'] = '{white}Цена: {green}#1#{white}',
                            ['message_ad_dialog_text_active'] = '{white}Активен: #1#{white}',
                            ['message_ad_dialog_text_yes'] = '{green}Да{white}',
                            ['message_ad_dialog_text_no'] = '{red}Нет{white}',
                            ['message_ad_dialog_text_len'] = '{white}Символов: {grey}#1#{white}',
                            ['message_ad_dialog_text_text'] = '{white}Текст: {grey}#1#{white}',
                            ['message_ad_dialog_text_result'] = '{white}Результат: {grey}#1#{white}',
                            ['message_ad_dialog_text_errors'] = '{red}Ошибки:{white}',
                            ['message_ad_dialog_text_error'] = '{red}#1#{white}',
                            ['message_ad_dialog_text_delete'] = '{red}Удалить{white}',
                            ['message_ad_dialog_text_message_count'] = '{white}Рекламных сообщений: {orange}#1#{white}',

                            ['message_ad_init_shop_id'] = '{white}ID вашей лавки {orange}#1#',

                            ['message_buyer_buy_error_price'] = 'Цена предмета выше установленной цены',

                            ['message_trade_add_product_count'] = '{green}#1# {blue}#2# {white}выставлен за {green}#3#',
                            ['message_trade_add_product'] = '{green}#1# {white}выставлен за {green}#2#',

                            ['message_dialog_title_enter_price'] = '{orange}Введите цену',
                            ['message_dialog_title_enter_price_zero'] = '{orange}Введите цену ( 0 - удалить )',
                            ['message_dialog_title_remove_product'] = '{orange}Удаление товаров',
                            ['message_dialog_title_change_product'] = '{orange}Изменение товаров',

                            ['message_dialog_button_ready'] = '{white}Готово',
                            ['message_dialog_button_add'] = '{white}Добавить',
                            ['message_dialog_button_select'] = '{white}Выбрать',
                            ['message_dialog_button_change'] = '{white}Изменить',
                            ['message_dialog_button_delete'] = '{white}Удалить',
                            ['message_dialog_button_back'] = '{white}Назад',
                            ['message_dialog_button_cancel'] = '{white}Отмена',

                            ['message_dialog_table_title_name'] = 'Название',
                            ['message_dialog_table_title_price'] = 'Цена',
                            ['message_dialog_table_title_mod'] = 'Тип',

                            ['message_mod_buy'] = '{green}Продажа',
                            ['message_mod_sale'] = '{blue}Скупка',

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

                            ['error_zero_price'] = 'Цена не должна быть меньше или равна нулю!',

                            -- COMMAND HELP

                            ['message_command_help_sh_swipe']           = '{white}Автоматически переключает показ режима лавки у игроков на скупку или продажу',
                            ['message_command_help_sh_swipe_active']    = '{white}Активация/деактивация',
                            ['message_command_help_sh_swipe_mod']       = '{white}Меняет мод свайпера (скупка или продажа)',

                            ['message_command_help_sh_hiding']          = '{white}Затеняет предметы в лавке у игроков',
                            ['message_command_help_sh_hiding_active']   = '{white}Активация/деактивация',
                            ['message_command_help_sh_hiding_alpha']    = '{white}Меняет степень затенения от 0 до 100 [стандарт: 80]',

                            ['message_command_help_sh_scan']            = '{white}Сканирует некоторые разные предметы с одинаковыми изображениями (для прайсера и селекта)',
                            ['message_command_help_sh_scan_active']     = '{white}Активация/деактивация',
                            ['message_command_help_sh_scan_add']        = '{white}Добавить товар на сканирование',
                            ['message_command_help_sh_scan_clear']      = '{white}Очистить добавленные товары',
                            ['message_command_help_sh_scan_time']       = '{white}Время сканирования [стандарт: 500]',

                            ['message_command_help_sh_radius']          = '{white}Подсвечивает область установки лавки',
                            ['message_command_help_sh_radius_active']   = '{white}Активация/деактивация',
                            ['message_command_help_sh_radius_player']   = '{white}',
                            ['message_command_help_sh_radius_polygons'] = '{white}Количество отрисовымаемых полигонов [стандарт: 24]',
                            ['message_command_help_sh_radius_distance'] = '{white}Дистанция видимости области [стандарт: 30]',

                            ['message_command_help_sh_visit']               = '{white}Показывает посещенные лавки',
                            ['message_command_help_sh_visit_active']        = '{white}Активация/деактивация',
                            ['message_command_help_sh_visit_clear']         = '{white}Очистить все посещения',
                            ['message_command_help_sh_visit_xray']          = '{white}Подсвечивание сквозь объекты',
                            ['message_command_help_sh_visit_distance']      = '{white}Дистанция видимости посещенных лавок [стандарт: 50]',
                            ['message_command_help_sh_visit_time']          = '{white}Время в секундах, через которое спадает посещение лавки [стандарт: 200]',
                            ['message_command_help_sh_visit_select']        = '{white}Явно указать посещенную лавку (нужно стоять рядом с лавкой)',
                            ['message_command_help_sh_visit_active_player'] = '{white}Активация/деактивация подсветки лавки игрока',
                            ['message_command_help_sh_visit_active_visit']  = '{white}Активация/деактивация подсветки посещенных лавок',
                            ['message_command_help_sh_visit_active-buy']    = '{white}Активация/деактивация подсветки лавок на скупку',
                            ['message_command_help_sh_visit_active_sell']   = '{white}Активация/деактивация подсветки лавок на продажу',
                            ['message_command_help_sh_visit_active_edit']   = '{white}Активация/деактивация подсветки редактируемых лавок',

                            ['message_command_help_sh_select']          = '{white}Обводка предметов в лавках игроков',
                            ['message_command_help_sh_select_active']   = '{white}Активация/деактивация',
                            ['message_command_help_sh_select_add']      = '{white}Активация/деактивация режима добавления предметов',
                            ['message_command_help_sh_select_clear']    = '{white}Очистить список выбранных предметов',
                            ['message_command_help_sh_select_border']   = '{white}Толщина обводки',
                            ['message_command_help_sh_select_color']    = '{white}Цвет обводки (в формате HEX)',
                            ['message_command_help_sh_select_alpha']    = '{white}Прозрачность обводки',

                            ['message_command_help_sh_trade']           = '{white}Быстрое выставление предметов на продажу (при задатии SHIFT можно изменить цену)',
                            ['message_command_help_sh_trade_active']    = '{white}Активация/деактивация',
                            ['message_command_help_sh_trade_clear']     = '{white}Очистить весь список предметов',

                            ['message_command_help_sh_pricer']              = '{white}Режим подсвечивания нужных цен предметов в лавках игроков',
                            ['message_command_help_sh_pricer_active']       = '{white}Активация/деактивация',
                            ['message_command_help_sh_pricer_add']          = '{white}Активация/деактивация режима добавления цен на предметы',
                            ['message_command_help_sh_pricer_clear']        = '{white}Очистить весь список предметов',
                            ['message_command_help_sh_pricer_border']       = '{white}Толщина обводки',
                            ['message_command_help_sh_pricer_commission']   = '{white}Указания комиссии при продаже предметов у себя [стандарт: 3]',
                            ['message_command_help_sh_pricer_list']         = '{white}Показать список предметов (так же можно менять цены)',

                            ['message_command_help_sh_ad']          = '{white}Автореклама рекламных компаний',
                            ['message_command_help_sh_ad_active']   = '{white}Активация/деактивация',
                            ['message_command_help_sh_ad_add']      = '{white}Добавить реклаиную компанию',
                            ['message_command_help_sh_ad_chats']    = '{white}Список чатов',
                            ['message_command_help_sh_ad_list']     = '{white}Список рекламных компаний',

                            ['message_command_help_sh_buyer']           = '{white}Быстрая покупка товара при зажатой CTRL',
                            ['message_command_help_sh_buyer_active']    = '{white}Активация/деактивация',
                            ['message_command_help_sh_buyer_price']     = '{white}Максимальная стоимость покупаемого товара',
                            ['message_command_help_sh_buyer_count']     = '{white}Максимально покупаемое количество товара',

                            ['message_command_help_sh_profile']         = '{white}Профили скрипта, например можно создать отдельный профиль для Vice City',
                            ['message_command_help_sh_profile_load']    = '{white}Загрузить профиль по названию (можно не полное название)',
                            ['message_command_help_sh_profile_list']    = '{white}Список профилей',
                            ['message_command_help_sh_profile_add']     = '{white}Добавить новый профиль',
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
                ['name'] = 'price',
                ['path'] = 'dependencies.entitys.Price',
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
                ['name'] = 'shopWindow',
                ['path'] = 'dependencies.entitys.ShopWindow',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'shopTitle',
                ['path'] = 'dependencies.entitys.ShopTitle',
                ['sort'] = 2000,
                ['init'] = false,
                ['args'] = {},
            },
            {
                ['name'] = 'shopAdmin',
                ['path'] = 'dependencies.entitys.ShopAdmin',
                ['sort'] = 2000,
                ['init'] = false,
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
                        ['types'] = {
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
                        ['vc'] = {
                            ['active'] = false,
                            ['buy'] = 100,
                            ['sell'] = 100,
                        },
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
                        ['vc-buy'] = {
                            ['min'] = 50,
                            ['max'] = 200,
                        },
                        ['vc-sell'] = {
                            ['min'] = 50,
                            ['max'] = 200,
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
            {
                ['name'] = 'profile',
                ['path'] = 'dependencies.commands.ProfileCommand',
                ['sort'] = 4000,
                ['init'] = true,
                ['args'] = {
                    'profile',
                    {
                        ['profile'] = 'default',
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
        ['commands'] = {},
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

        -- local font = renderCreateFont("Arial", 8, 5) --creating font
        -- while true do wait(0)
        --     for a = 0, 2304	do
        --         if sampTextdrawIsExists(a) then
        --             local x, y = sampTextdrawGetPos(a)
        --             local x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
        --             renderFontDrawText(font, a, x1, y1, 0xFFBEBEBE)
        --         end
        --     end
        -- end

        -- sampTextdrawSetString(id, text)
    end
end