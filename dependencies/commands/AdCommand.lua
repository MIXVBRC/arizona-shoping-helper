local class = {}
function class:new(_base, _name, _default, _minmax)
    local this = {}
    local private = {
        ['name'] = _name,
        ['pushing'] = false,
        ['shopId'] = nil,
        ['pushingMessages'] = {},
        ['minmax'] = _base:getNew('minMax', _minmax),
        ['config'] = _base:getNew('configManager', _name, _default),
    }

    -- TODO: сделать возможность шаблонизирования сообщения
    -- TODO: в DialogManager добавить события для диалогов VR и AD и остальных, если есть
    -- TODO: для каждого чата сделать возможность персонального текста сообщения
    -- TODO: добавить рекламу в AD, Семью (fam), Альянс (al)

    -- NAME

    function private:getName()
        return private.name
    end

    -- ACTIVE

    function private:isActive()
        return private.config:get('active')
    end

    function private:setActive(bool)
        private.config:set('active', bool)
        return private
    end

    function private:toggleActive()
        private:setActive(not private:isActive())
        return private
    end

    -- INDEX

    function private:getIndex()
        return private.index
    end

    function private:setIndex(index)
        private.index = index
        return private
    end

    -- MESSAGES

    function private:getMessages()
        return private.config:get('messages') or {}
    end

    function private:setMessages(messages)
        private.config:set('messages', messages or {})
        return private
    end

    function private:getMessage(index)
        return private:getMessages()[index]
    end

    function private:addMessage(chat, text)
        local messages = private:getMessages()
        table.insert(messages, {
            ['chat'] = chat,
            ['active'] = false,
            ['text'] = text,
        })
        private:setMessages(messages)
        return #messages
    end

    function private:deleteMessage(index)
        local messages = private:getMessages()
        table.remove(messages, index)
        private:setMessages(messages)
        return private
    end

    function private:getNextMessage()
        private:setIndex(private:getIndex() + 1)
        if private:getIndex() > #private:getMessages() then
            private:setIndex(1)
        end
        return private:getMessages()[private:getIndex()]
    end

    -- TIME

    function private:getTime()
        return private.config:get('time') or private.minmax:getMin('time')
    end

    function private:setTime(time)
        private.config:set('time', private.minmax:get(time, 'time'))
        return private
    end

    -- CHATS

    function private:getChats()
        return private.config:get('chats') or {}
    end

    function private:setChats(chats)
        private.config:set('chats', chats or {})
        return private
    end

    function private:getChat(name)
        for _, chat in ipairs(private:getChats()) do
            if name == chat.name then
                return chat
            end
        end
        return nil
    end

    function private:setChat(name, bool)
        local chats = private:getChats()
        for _, chat in ipairs(chats) do
            if name == chat.name then
                chat.active = bool
            end
        end
        private:setChats(chats)
        return private
    end

    function private:toggleChat(name)
        local chats = private:getChats()
        for _, chat in ipairs(chats) do
            if name == chat.name then
                chat.active = not chat.active
            end
        end
        private:setChats(chats)
        return private
    end

    -- PUSH AT

    function private:getPushAt()
        return private.config:get('pushAt') or 0
    end

    function private:setPushAt(time)
        private.config:set('pushAt', math.abs(time or 0))
        return private
    end

    -- PUSHING

    function private:isPushing()
        return private.pushing
    end

    function private:setPushing(bool)
        private.pushing = bool
        return private
    end

    -- SHOP ID

    function private:getShopId()
        return private.shopId
    end

    function private:setShopId(shopId)
        private.shopId = shopId
        return private
    end

    -- PUSHINGS

    function private:getPushingMessages()
        return private.pushingMessages
    end

    function private:setPushingMessages(pushingMessages)
        private.pushingMessages = pushingMessages
        return private
    end

    function private:addPushingMessage(pushingMessage)
        local pushingMessages = private:getPushingMessages()
        table.insert(pushingMessages, pushingMessage)
        private:setPushingMessages(pushingMessages)
        return private
    end

    -- DIALOG CHAT SELECT 

    function private:dialogChatSelect(action)
        _base:get('dialogManager'):close()
        local dialogTable = {
            {
                _base:get('message'):get('message_ad_dialog_table_chat'),
                _base:get('message'):get('message_ad_dialog_table_active'),
            }
        }
        for _, chat in ipairs(private:getChats()) do
            local active = _base:get('message'):get('message_ad_dialog_text_no')
            if chat.active then
                active = _base:get('message'):get('message_ad_dialog_text_yes')
            end
            table.insert(dialogTable, {
                '/' .. chat.name,
                active,
            })
        end
        _base:get('dialogManager'):show(
            _base:get('message'):get('message_ad_dialog_title_chat_select'),
            dialogTable,
            _base:get('message'):get('message_dialog_button_select'),
            _base:get('message'):get('message_dialog_button_cancel'),
            5,
            function (list, _)
                _base:get('chat'):push(list)
                for index, chat in ipairs(private:getChats()) do
                    if list == index then
                        if action == 'add' then
                            private:dialogMessageAdd(chat.name)
                        elseif action == 'change' then
                            private:dialogChatChange(chat.name)
                        end
                        return
                    end
                end
            end
        )
        return private
    end

    -- DIALOG CHAT CHANGE

    function private:dialogChatChange(name)
        _base:get('dialogManager'):close()
        local chat = private:getChat(name)
        if chat ~= nil then
            local dialogList = {}
            local activeMessage = ''
            if chat.active then
                activeMessage = _base:get('message'):get('message_ad_dialog_text_active', {
                    _base:get('message'):get('message_ad_dialog_text_yes')
                })
            else
                activeMessage = _base:get('message'):get('message_ad_dialog_text_active', {
                    _base:get('message'):get('message_ad_dialog_text_no')
                })
            end
            table.insert(dialogList, activeMessage)
            table.insert(dialogList, ' ')
            local messageCount = 0
            for _, message in ipairs(private:getMessages()) do
                if message.chat == chat.name then
                    messageCount = messageCount + 1
                end
            end
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_message_count', {
                messageCount
            }))
            _base:get('dialogManager'):show(
                _base:get('message'):get('message_ad_dialog_title_select'),
                dialogList,
                _base:get('message'):get('message_dialog_button_select'),
                _base:get('message'):get('message_dialog_button_back'),
                2,
                function (list)
                    if dialogList[list] == activeMessage then
                        private:toggleChat(chat.name)
                    end
                    private:dialogChatChange(name)
                end,
                function ()
                    private:dialogChatSelect('change')
                end
            )
        end
        return private
    end

    -- DIALOG MESSAGE ADD

    function private:dialogMessageAdd(chat)
        _base:get('dialogManager'):close()
        local dialogList = {}
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_1'))
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_1_1'))
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_1_2'))
        table.insert(dialogList, ' ')
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_2'))
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_2_1'))
        table.insert(dialogList, ' ')
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_3'))
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_3_1'))
        if chat ~= 'ad' then
            table.insert(dialogList, ' ')
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_4'))
        else
            table.insert(dialogList, ' ')
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_message_add_5'))
        end
        _base:get('dialogManager'):show(
            _base:get('message'):get('message_ad_dialog_title_add') .. chat,
            dialogList,
            _base:get('message'):get('message_dialog_button_add'),
            _base:get('message'):get('message_dialog_button_cancel'),
            1,
            function (_, input)
                if chat == 'ad' then
                    if input:len() < 20 or 80 < input:len() then
                        _base:getNew('error', _base:get('message'):get('message_ad_push_error_ad_len'))
                        _base:getNew('error', _base:get('message'):get('message_ad_push_error_ad_len_entered', {
                            input:len()
                        }))
                        private:dialogMessageAdd(chat)
                        return
                    end
                end
                local index = private:addMessage(chat, input)
                private:dialogMessageSelected(index)
            end
        )
        return private
    end

    -- DIALOG MESSAGE LIST

    function private:dialogMessageList()
        _base:get('dialogManager'):close()
        local dialogTable = {
            {
                _base:get('message'):get('message_ad_dialog_table_chat'),
                _base:get('message'):get('message_ad_dialog_table_active'),
                _base:get('message'):get('message_ad_dialog_table_message'),
            },
        }
        for _, message in ipairs(private:getMessages()) do
            local active = _base:get('message'):get('message_ad_dialog_text_no')
            if message.active then
                active = _base:get('message'):get('message_ad_dialog_text_yes')
            end
            table.insert(dialogTable, {
                '{' .. _base:get('color'):get('orange') .. '}' .. message.chat,
                active,
                '{' .. _base:get('color'):get('grey') .. '}' .. message.text,
            })
        end
        _base:get('dialogManager'):show(
            _base:get('message'):get('message_ad_dialog_title_list'),
            dialogTable,
            _base:get('message'):get('message_dialog_button_change'),
            _base:get('message'):get('message_dialog_button_cancel'),
            5,
            function (list)
                private:dialogMessageSelected(list)
            end
        )
        return private
    end

    -- DIALOG MESSAGE SELECTED

    function private:dialogMessageSelected(index)
        _base:get('dialogManager'):close()
        local message = private:getMessage(index)
        local dialogList = {}
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_chat', {
            message.chat
        }))
        table.insert(dialogList, ' ')
        local activeMessage = ''
        if message.active then
            activeMessage = _base:get('message'):get('message_ad_dialog_text_active', {
                _base:get('message'):get('message_ad_dialog_text_yes')
            })
        else
            activeMessage = _base:get('message'):get('message_ad_dialog_text_active', {
                _base:get('message'):get('message_ad_dialog_text_no')
            })
        end
        table.insert(dialogList, activeMessage)
        local deleteMessage = _base:get('message'):get('message_ad_dialog_text_delete')
        table.insert(dialogList, deleteMessage)
        table.insert(dialogList, ' ')
        table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_text', {
            message.text
        }))
        table.insert(dialogList, ' ')
        local result, errorMessages = private:replaceText(message.text)
        if #errorMessages <= 0 then
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_result', {
                result
            }))
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_len', {
                result:len()
            }))
        else
            table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_errors'))
            for _, errorMessage in ipairs(errorMessages) do
                table.insert(dialogList, _base:get('message'):get('message_ad_dialog_text_error', {
                    errorMessage
                }))
            end
        end
        _base:get('dialogManager'):show(
            _base:get('message'):get('message_ad_dialog_title_select'),
            dialogList,
            _base:get('message'):get('message_dialog_button_select'),
            _base:get('message'):get('message_dialog_button_back'),
            2,
            function (list)
                if dialogList[list] == activeMessage then
                    local messages = private:getMessages()
                    for _index, _message in ipairs(messages) do
                        if index ~= _index and message.chat == _message.chat then
                            _message.active = false
                        end
                    end
                    message.active = not message.active
                    private:setMessages(messages)
                elseif dialogList[list] == deleteMessage then
                    private:deleteMessage(index)
                    private:dialogMessageList()
                    return
                end
                private:dialogMessageSelected(index)
            end,
            function ()
                private:dialogMessageList()
            end
        )
    end

    -- REMAINING TIME

    function private:getRemainingTime()
        local time = math.ceil((private:getPushAt() - os.time()) / 60)
        if time < 0 then
            time = 0
        end
        return time
    end

    -- REPLACE TEXT

    function private:replaceText(text)
        local errorMessages = {}
        if private:getShopId() == nil then
            if text:find('#shopid#') then
                table.insert(errorMessages, _base:get('message'):get('message_ad_push_error_message', {
                    '#shopid#',
                    _base:get('message'):get('message_ad_push_error_shop_id')
                }))
            elseif text:find('#shop#') then
                table.insert(errorMessages, _base:get('message'):get('message_ad_push_error_message', {
                    '#shop#',
                    _base:get('message'):get('message_ad_push_error_shop_id')
                }))
            end
        end
        if #errorMessages <= 0 then
            text = text:gsub('#shopid#', private:getShopId() or '')
            text = text:gsub('#shop#', _base:get('message'):get('system_regex_gsub_ad_command_shop_id', {
                private:getShopId() or ''
            }))
        end
        return text, errorMessages
    end

    -- PUSH

    function private:push(chat, text)
        local result = true
        local finalText, errorMessages = private:replaceText(text)
        if #errorMessages <= 0 then
            if chat == 'vr' then
                private:pushVR(finalText)
            elseif chat == 'al' then
                private:pushAL(finalText)
            elseif chat == 'fam' then
                private:pushFAM(finalText)
            elseif chat == 'ad' then
                private:pushAD(finalText)
            elseif chat == 's' then
                private:pushS(finalText)
            end
        else
            result = false
        end
        return result, errorMessages
    end

    -- PUSH VR

    function private:pushVR(text)
        local waiting = true
        _base:get('queueManager')
        :add(
            function ()
                _base:get('dialogManager'):close()
                private:setPushing(true)
                sampProcessChatInput('/vr ' .. text)
                while waiting do wait(0) end
                private:setPushing(false)
                wait(1000)
            end,
            1
        )
        :addEvent(
            'onShowDialogVR',
            function (id)
                _base:get('dialogManager'):send(id, 1)
                waiting = false
                return false
            end,
            1
        )
        :push()
        return private
    end

    -- PUSH FAM

    function private:pushFAM(text)
        _base:get('queueManager')
        :add(
            function ()
                private:setPushing(true)
                sampProcessChatInput('/fam ' .. text)
                private:setPushing(false)
                wait(1000)
            end,
            1
        )
        :push()
        return private
    end

    -- PUSH AL

    function private:pushAL(text)
        _base:get('queueManager')
        :add(
            function ()
                private:setPushing(true)
                sampProcessChatInput('/al ' .. text)
                private:setPushing(false)
                wait(1000)
            end,
            1
        )
        :push()
        return private
    end

    -- PUSH S

    function private:pushS(text)
        _base:get('queueManager')
        :add(
            function ()
                private:setPushing(true)
                sampProcessChatInput('/s ' .. text)
                private:setPushing(false)
                wait(1000)
            end,
            1
        )
        :push()
        return private
    end

    -- PUSH AD

    function private:pushAD(text)
        local waiting = true
        _base:get('queueManager')
        :add(
            function ()
                _base:get('dialogManager'):close()
                private:setPushing(true)
                sampProcessChatInput('/ad')
                while waiting do wait(0) end
                private:setPushing(false)
                wait(1000)
            end,
            1
        )
        :addEvent(
            'onShowDialogAdCancel',
            function (id)
                _base:get('dialogManager'):send(id, 1)
                sampProcessChatInput('/ad')
                return false
            end,
            1
        )
        :addEvent(
            'onShowDialogAdSubmittingEnterMessage',
            function (id)
                _base:get('dialogManager'):send(id, 1, nil, text)
                return false
            end,
            1
        )
        :addEvent(
            'onShowDialogAdSelectRadioStation',
            function (id)
                _base:get('dialogManager'):send(id, 1, 0)
                return false
            end,
            1
        )
        :addEvent(
            'onShowDialogAdSelectType',
            function (id)
                _base:get('dialogManager'):send(id, 1, 0)
                return false
            end,
            1
        )
        :addEvent(
            'onShowDialogAdConfirmation',
            function (id)
                _base:get('dialogManager'):send(id, 1)
                waiting = false
                return false
            end,
            1
        )
        :addEvent(
            'onShowDialog',
            function (id)
                _base:get('dialogManager'):close(id)
                return false
            end,
            1000
        )
        :push()
    end

    -- INITS

    function private:init()
        if _base:get(private:getName()) ~= nil then
            return _base:get(private:getName())
        end
        private:initCommands():initEvents():initThreads()
        return this
    end

    function private:initCommands()
        _base:get('commandManager')
        :add({private:getName(), 'active'}, private.toggleActive)
        :add({private:getName(), 'push'}, function ()
            private:setPushAt(0)
        end)
        :add({private:getName(), 'add'}, function ()
            private:dialogChatSelect('add')
        end)
        :add({private:getName(), 'chats'}, function ()
            private:dialogChatSelect('change')
        end)
        :add({private:getName(), 'list'}, private.dialogMessageList)
        :add({private:getName(), 'time'}, function (time)
            time = _base:get('helper'):getNumber(time)
            if private:getPushAt() > 0 then
                private:setPushAt(private:getPushAt() - (private:getTime() - time) * 60)
            end
            private:setTime(time)
        end)
        :add({private:getName(), 'left'}, function ()
            _base:get('chat'):push(_base:get('message'):get('message_ad_next_push_time', {
                private:getRemainingTime()
            }))
        end)
        for _, chat in ipairs(private:getChats()) do
            _base:get('commandManager')
            :add({private:getName(), 'active', chat.name}, function ()
                private:toggleChat(chat.name)
            end)
        end
        return private
    end

    function private:initEvents()
        _base:get('eventManager')
        :add(
            'onOpenShopAdminingList',
            function (id)
                if private:getShopId() == nil or private:getShopId() ~= id then
                    private:setShopId(id)
                    _base:get('chat'):push(_base:get('message'):get('message_ad_init_shop_id',{
                        id
                    }))
                end
            end
        )
        :add(
            'onSendCommand',
            function (message)
                if private:isPushing() then
                    _base:get('chat'):push('pushing: ' .. message)
                    for _, pushing in ipairs(private:getPushingMessages()) do
                        if pushing == message then
                            break
                        end
                    end
                    private:addPushingMessage(message)
                else
                    for _, pushing in ipairs(private:getPushingMessages()) do
                        if pushing == message then
                            _base:getNew('error', _base:get('message'):get('message_ad_push_error_defender'))
                            return false
                        end
                    end
                end
            end,
            1
        )
        return private
    end

    function private:initThreads()
        _base:get('threadManager')
        :add(
            nil,
            function ()
                while true do wait(1000 * 60)
                    if private:isActive()
                    and not _base:get('dialogManager'):isOpened()
                    and not _base:get('playerManager'):isShoping()
                    and not _base:get('playerManager'):isAdmining()
                    then
                        if private:getPushAt() <= os.time() then
                            local chatErrors = {}
                            for _, chat in ipairs(private:getChats()) do
                                if chat.active then
                                    for _, message in ipairs(private:getMessages()) do
                                        if chat.name == message.chat and message.active then
                                            local result, errors = private:push(chat.name, message.text)
                                            if not result then
                                                table.insert(chatErrors, {
                                                    ['name'] = chat.name,
                                                    ['errors'] = errors,
                                                })
                                            end
                                            break
                                        end
                                    end
                                end
                            end
                            if #chatErrors > 0 then
                                for _, chat in ipairs(chatErrors) do
                                    for _, errorMessage in ipairs(chat.errors) do
                                        _base:getNew('error', chat.name .. ' | ' .. errorMessage)
                                    end
                                end
                            end
                            local waiting = true
                            _base:get('queueManager')
                            :add(
                                function ()
                                    private:setPushAt(os.time() + private:getTime() * 60)
                                    _base:get('chat'):push(_base:get('message'):get('message_ad_next_push_time', {
                                        private:getRemainingTime()
                                    }))
                                    waiting = false
                                end,
                                1
                            )
                            :push()
                            while waiting do wait(1000) end
                        end
                    end
                end
            end
        )
        return private
    end

    return private:init()
end
return class