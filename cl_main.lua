local myRobbableItems = {}
local robberyped = nil
local robbableHouses = {
    [1] = {x = -51.01, y = -1783.87, z = 28.31, info = 'Grove Street 1'},
    [2] = {x = -42.56, y = -1792.78, z = 27.83, info = 'Grove Street 2'},
    [3] = {x = 20.57, y = -1844.12, z = 24.61, info = 'Grove Street 3'},
}

local robbableItems = {
    [1] = {x = 1.90339700, y = -3.80026800, z = 1.29917900, name = "Fridge", isSearched = false},
    [2] = {x = -3.50363200, y = -6.55289400, z = 1.30625800, name = "Drawers", isSearched = false},
    [3] = {x = -3.50712600, y = -4.13621600, z = 1.29625800, name = "Table", isSearched = false},
    [4] = {x = 8.47819500, y = -2.50979300, z = 1.19712300, name = "Storage", isSearched = false},
    [5] = {x = 9.75982700, y = -1.35874100, z = 1.29625800, name = "Storage", isSearched = false},
    [6] = {x = 8.46626300, y = 4.53223600, z = 1.19425800, name = "Wardrobe", isSearched = false},
    [7] = {x = 5.84416200, y = 2.57377400, z = 1.22089100, name = "Table", isSearched = false},
}

local ESX = nil
local PlayerData = []
local pedSpawned = false

Citizen.CreateThread(function) ()
    while ESX = nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xplayer)
    PlayerData = xplayer
end)

RegisterNetEvent('shoreline_burglary:attempt')
AddEventHandler('shoreline_burglary:attempt', function(lockpicks)
    if isRobbing and DoesEntityExist(safe) then
        local playerCoords = GetEntityCoords(PlayerPedId(), true)
        if GetDistanceBetweenCoords(playerCoords, safepos.x, safepos.y, safepos.z, true) <= 3.0 then
            TriggerEvent("safecracking:loop",5)

            if math.random(1, 20) == 1 then
                TriggerServerEvent('houseRoberies:removeLockpick')
            end
        end
    end
