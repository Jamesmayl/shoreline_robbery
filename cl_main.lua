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
                TriggerServerEvent('shoreline_burglary:removeLockpick')
            end
        end
    end


 if lockpicks > 0 and isNight() and not isRobbing then
     local playerCoords = GetEntityCoords(PlayerPedId(), true)
    for id,v in pairs(robbableHouses) do
        if GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true) <= 2.5 then
        TriggerEvent('lockpickAnimation')
        exports["loadingbar"]:StartDelayedFunction("Lockpicking Property", 12000, function()
        isLockpicking = false
        pedSpawned = false

        if math.random(1, 10) == 1 then
            TriggerEvent('police:shoreline_burglary')
        end

        if math.random(1, 20) == 1 then
            TriggerServerEvent('shoreline_burglary:removeLockpick')
        end

        TriggerEvent('shoreline_burglary:createHouse', id)
    end)
   end
end
        
elseif lockpicks == 0 and not isRobbing then
    TriggerEvent('shoreline_notifcation', No 'Lockpick', 2)
elseif not isNight() and not isRobbing then
  TriggerEvent('shoreline_notification', 'It\'s too bright out', 2)
 else
 end
end)

RegisterNetEvent('shoreline_burglary:createHouse')
AddEventHandler('shoreline_burglary:createHouse', function(id)
 local house = robbableHouses[id]

 myRobbableItems = robbableItems

 for i=1,#myRobbableItems do
  myRobbableItems[i]['isSearched'] = false
 end

 DoScreenFadeOut(100)
 Citizen.Wait(100)

 buildBasicHouse({x = house.x, y = house.y, z = house.z-50})
 Citizen.Wait(3000)

 randomAI({x = house.x, y = house.y, z = house.z-50})

 curHouseCoords = {x = house.x, y = house.y, z = house.z-50}
 disturbance = 0
 isAgro = false


 if math.random(10, 10) < 2 then
  TriggerEvent('shoreline_burglary:createDog')
 end

 DoScreenFadeIn(100)
 Citizen.Wait(100)

 isRobbing = true

 while isRobbing do
  Citizen.Wait(5)
  local playerCoords = GetEntityCoords(PlayerPedId(), true)

  if GetDistanceBetweenCoords(playerCoords, house.x+3.6, house.y-15, house.z-50, true) < 2.5 then
   showMessage('Press E To Exit House')
   if IsControlJustPressed(0, 38) then
    TriggerEvent('shoreline_burglary:deleteHouse', id)
   end
  end
 end
end)


RegisterNetEvent('shoreline_burglary:deleteHouse')
AddEventHandler('shoreline_burglary:deleteHouse', function(id)
 local house = robbableHouses[id]

 myRobbableItems = robbableItems
 DoScreenFadeOut(100)
 Citizen.Wait(100)

 FreezeEntityPosition(PlayerPedId(), true)
 DeleteSpawnedHouse(id)

 Citizen.Wait(1000)

 SetEntityCoords(PlayerPedId(), house.x, house.y, house.z)
 FreezeEntityPosition(PlayerPedId(), false)

 Citizen.Wait(500)

 DoScreenFadeIn(100)
 Citizen.Wait(100)


 TriggerEvent("robbery:guiclose")
 disturbance = 0
 isRobbing = false
end)
