FWFuncs = {
    CL = {
        AddBoxZone = function(coords, size, rotation, debug, options)
            exports['ox_target']:addBoxZone({
                coords = coords,
                size = size,
                rotation = rotation,
                debug = debug,
                options = options
            })
        end,
        AddCircleZone = function(coords, radius, debug, options)
            exports['ox_target']:addCircleZone({
                coords = coords,
                radius = radius,
                debug = debug,
                options = options
            })
        end,
        AddTargetModel = function(models, options)
            exports['ox_target']:addModel(models, options)
        end,

        GetIdentifier = function()
            return ESX.PlayerData.identifier
        end,
    },

    SV = {
        GetIdentifier = function(source)
            print(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.identifier
        end,
        GetMoney = function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.getMoney()
        end,
        GetBank = function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.getAccount('bank').money
        end,
        AddBank = function(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addAccountMoney('bank', amount)
        end,
        RemoveBank = function(source, amount)
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.removeAccountMoney('bank', amount)
        end,
    }
}