    local VorpCore = {}
    local json = require("json")
    
    TriggerEvent("getCore",function(core)
        VorpCore = core
    end)
    
    -- 
    function sendToDiscord(webhookUrl, playerName, steamId, message)
        local embeds = {
            {
                ["title"] = "Payment received",
                ["description"] = "**Player:** " .. playerName .. " (" .. steamId .. ")\n**Message:** " .. message,
                ["color"] = 65280, -- green color
                ["thumbnail"] = {
                    ["url"] = "https://camo.githubusercontent.com/efa7ef1629da9c8b80435ebefdb37d44d013e99fa69f442cdef6d664b075f12e/687474703a2f2f66656d67612e636f6d2f696d616765732f73616d706c65732f75695f74657874757265732f696e76656e746f72795f6974656d732f6d6f6e65795f6d6f6e6579737461636b2e706e67"
                }
            }
        }
        
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end
     
    RegisterServerEvent('DF_paycheck:payment')
    AddEventHandler('DF_paycheck:payment', function()
        local _source = source
        local Character = VorpCore.getUser(_source).getUsedCharacter
        local playerName = GetPlayerName(_source)
        local steamId = tostring(GetPlayerIdentifier(_source, 0)) 
    
        -- cash
        for _, salary in ipairs(Config.groupSalaries) do
            if Character.group == salary.group then
                Character.addCurrency(salary.typeMoney, salary.valueToPay)
                TriggerClientEvent('vorp:NotifyLeft', _source, Config.Translate[1], tostring(salary.valueToPay) .. "$", "inventory_items", "money_moneystack", 4000, "COLOR_WHITE")
                sendToDiscord("", playerName, steamId, "Payment of $" .. tostring(salary.valueToPay) .. " received for the group " .. Character.group)
            end
        end
    
        -- gold
        for _, salary in ipairs(Config.jobSalaries) do
            if Character.job == salary.job and Character.jobGrade == salary.jobgrade then
                Character.addCurrency(salary.typeMoney, salary.valueToPay)
                TriggerClientEvent('vorp:NotifyLeft', _source, Config.Translate[2], tostring(salary.valueToPay) .. "$", "inventory_items", "money_moneystack", 4000, "COLOR_WHITE") 
                sendToDiscord("", playerName, steamId, "Payment of $" .. tostring(salary.valueToPay) .. " Received for work " .. Character.job .. " like grade " .. Character.jobGrade)
            end
        end
    
        -- item 
        for _, itemPayment in ipairs(Config.itemPayments) do
            if Character.group == itemPayment.group and (not Character.lastItemPaymentTime or os.time() - Character.lastItemPaymentTime >= (Config.MinutesToPay * 60)) then 
                -- add item
                exports.vorp_inventory:addItem(_source, itemPayment.item, itemPayment.quantity, nil, function()
                    TriggerClientEvent('vorp:NotifyLeft', _source, Config.Translate[3], "" .. itemPayment.item .. "", "inventory_items", "money_moneystack", 4000, "COLOR_WHITE")
                    -- discord
                    sendToDiscord("", playerName, steamId, "Received a " .. itemPayment.item .. " as payment.")
                end)
            end
        end
    
        Character.lastItemPaymentTime = os.time()
    end)
