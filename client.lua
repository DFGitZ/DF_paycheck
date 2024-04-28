Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.MinutesToPay*60*1000)
        TriggerServerEvent('DF_paycheck:payment')
    end
end)