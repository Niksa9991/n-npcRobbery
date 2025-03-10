local ESX = exports["es_extended"]:getSharedObject()

local Config = lib.require('shared/config')

lib.callback.register('robbery:reward', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local reward = Config.rewards.money
        xPlayer.addMoney(reward)
        return true
    end
    return false
end)
