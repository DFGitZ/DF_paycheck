Config = {}

Config = {}

Config.groupSalaries = {
    { group = "vip", typeMoney = 0, valueToPay = 5 },
    { group = "admin", typeMoney = 1, valueToPay = 10 }
}

Config.jobSalaries = {
    { job = "police", jobgrade = 1, typeMoney = 0, valueToPay = 50 },
    { job = "doctor", jobgrade = 2, typeMoney = 0, valueToPay = 5 }
}

Config.itemPayments = {
    { group = "vip", item = "acid", quantity = 1 }, -- Add as many items as you want, with their names, quantities and associated groups
}

Config.Translate = {
    [1] = "Recebeste o salário VIP", --"Received the vip salary"
    [2] = "Recebeste o salário", --"Received the salary"
    [3] = "Recebeste o Item como Pagamento", --"You received the item as payment"
}

Config.MinutesToPay = 60 -- 1 hour

