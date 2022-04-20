local ESX = nil
local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(1, 900)},
 [2] = {chance = 10, id = 'WEAPON_PISTOL', name = 'Pistol', isWeapon = true},
 [3] = {chance = 3, id = 'scratchoff', name = 'Lottery Ticket', quantity = math.random(1, 3)},
 [4] = {chance = 5, id = 'weed_pooch', name = 'Bag of Weed', quantity = 1},
 [5] = {chance = 4, id = '2ct_gold_chain', name = '2CT Gold Chain (P)', quantity = 1},
 [6] = {chance = 8, id = 'drill_bit', name = 'Drill Bit', quantity = 1},
 [7] = {chance = 3, id = 'sunglasses', name = 'Oakley Sunglasses (P)', quantity = 1},
 [8] = {chance = 4, id = 'gameboy', name = 'Gameboy (P)', quantity = 1},
 [9] = {chance = 3, id = 'casio_watch', name = 'Casio Watch (P)', quantity = 1},
 [10] = {chance = 5, id = 'apple_iphone', name = 'Apple iPhone (P)', quantity = 1},
 [11] = {chance = 2, id = 'rubber', name = 'Rubber', quantity = 1},
 [12] = {chance = 1, id = 'rolling_paper', name = 'Rolling Paper', quantity = 1},
 [13] = {chance = 3, id = 'glass', name = 'Glass', quantity = 1}
 [14] = {chance = 7, id = 'fuse', name = 'Fuse', quantity = 1},
 [15] = {chance = 7, id = 'white_pearl', name = 'White Pearl (P)', quantity = 1},
 [16] = {chance = 9, id = 'coke_pooch', name = 'Bag of Coke', quantity = 1},
}


TriggerEvent('esx:getSharedObject', function(obj)
 ESX = obj
end)

ESX.RegisterUsableItem('lockpick', function(source)
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 TriggerClientEvent('shoreline_burglary:attempt', source, xPlayer.getInventoryItem('lockpick').count)
end)

RegisterServerEvent('shoreline_burglary:removeLockpick')
AddEventHandler('shoreline_burglary:removeLockpick', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 xPlayer.removeInventoryItem('lockpick', 1)
 TriggerClientEvent('shoreline_notification', source, 'The lockpick bent out of shape', 2)
end)

RegisterServerEvent('shoreline_burglary:giveMoney')
AddEventHandler('shoreline_burglary:giveMoney', function()
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local cash = math.random(500, 3000)
 xPlayer.addMoney(cash)
 --TriggerClientEvent('chatMessage', source, '^4You have found $'..cash)
 TriggerClientEvent('shoreline_notification', source, 'You found $'..cash)
end)


RegisterServerEvent('houseRobberies:searchItem')
AddEventHandler('shoreline_notification:searchItem', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}
