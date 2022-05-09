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

function isNight()
 local hour = GetClockHours()
 if hour > 19 or hour < 5 then
  return true
 end
end

function randomAI(generator)
 local modelhash = GetHashKey("a_m_m_beach_02")
 RequestModel(modelhash)

 while not HasModelLoaded(modelhash) do
  Citizen.Wait(0)
 end

 local airoll = math.random(5)
 if airoll == 1 then
  robberyped = CreatePed(GetPedType(modelhash), modelhash, generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100, 15.0, 1, 1)
  SetEntityCoords(robberyped, generator.x+6.86376900, generator.y+1.20651200, generator.z+1.36589100)
  SetEntityHeading(robberyped, 80.0)
  SetEntityAsMissionEntity(robberyped, false, true)
  loadAnimDict("dead")
  TaskPlayAnim(robberyped, "dead", 'dead_a', 100.0, 1.0, -1, 1, 0, 0, 0, 0)
  pedSpawned = true
 elseif airoll == 2 then
  robberyped = CreatePed(GetPedType(modelhash), modelhash, generator.x+6.86376900,generator.y+1.20651200,generator.z+1.36589100, 15.0, 1, 1)
  SetEntityCoords(robberyped, generator.x-1.48765600, generator.y+1.68100600, generator.z+1.21640500)
  SetEntityHeading(robberyped, 190.0)
  SetEntityAsMissionEntity(robberyped, false, true)
  loadAnimDict("dead")
  TaskPlayAnim(robberyped, "dead", 'dead_b', 100.0, 1.0, -1, 1, 0, 0, 0, 0)
  pedSpawned = true
 end
end

Citizen.CreateThread(function()
 while true do
  Citizen.Wait(5)
  local generator = {x = curHouseCoords["x"], y = curHouseCoords["y"], z = curHouseCoords["z"]}

  if isRobbing then
   for i=1,#myRobbableItems do
    if (GetDistanceBetweenCoords(generator.x + myRobbableItems[i]["x"], generator.y + myRobbableItems[i]["y"], generator.z + myRobbableItems[i]["z"], GetEntityCoords(GetPlayerPed(-1))) < 1.4) and not myRobbableItems[i]['isSearched'] then
     DrawText3Ds(generator.x + myRobbableItems[i]["x"], generator.y + myRobbableItems[i]["y"], generator.z + myRobbableItems[i]["z"], '~w~Press ~g~H~s~ To Search ' .. myRobbableItems[i]["name"])

     if IsControlJustReleased(1, 74) then
      myRobbableItems[i]['isSearched'] = true
      local distance, pedcount = closestNPC()
      local distadd = 0.1
      if pedcount > 0 then
       distadd = distadd + (pedcount / 100)
       local distancealter = (8.0 - distance) / 100
       distadd = distadd + distancealter
      end

      distadd = distadd * 100
      disturbance = disturbance + distadd
      if math.random(100) > 95 then
 			 disturbance = disturbance + 10
      end

      exports["shoreline_loadingbar"]:StartDelayedFunction("Searching "..myRobbableItems[i]['name'], 20000, function()
       TriggerServerEvent('houseRobberies:searchItem')
      end)
     end
    end
 	 end

   if IsPedShooting(PlayerPedId()) then
    disturbance = 90
    if not isAgro then
     agroNPC()
    end
   end

   TriggerEvent("robbery:guiupdate", math.ceil(disturbance))

   if disturbance > 85 then
    if not calledin then
     local num = 150 - disturbance
     num = math.random(math.ceil(num))
     local fuckup = math.ceil(num)

     if fuckup == 2 and GetEntitySpeed(GetPlayerPed(-1)) > 0.8 then
      calledin = true
      if not isAgro then
       agroNPC()
       TriggerEvent('police:houseRobbery')
      end
     end
    end
   end

   if GetEntitySpeed(GetPlayerPed(-1)) > 1.4 then
    local distance, pedcount = closestNPC()
    local alteredsound = 0.1
    if pedcount > 0 then
     alteredsound = alteredsound + (pedcount / 100)
     local distancealter = (8.0 - distance) / 100
     alteredsound = alteredsound + distancealter
    end

    disturbance = disturbance + alteredsound
    if GetEntitySpeed(GetPlayerPed(-1)) > 2.0 then
     disturbance = disturbance + alteredsound
    end

    if GetEntitySpeed(GetPlayerPed(-1)) > 3.0 then
     disturbance = disturbance + alteredsound
    end
   else
    disturbance = disturbance - 0.01
    if disturbance < 0 then
     disturbance = 0
    end
   end
  end
 end
end)


function buildBasicHouse(generator)
 SetEntityCoords(PlayerPedId(), 347.04724121094, -1000.2844848633, -99.194671630859)
 FreezeEntityPosition(PlayerPedId(), true)
 Citizen.Wait(2000)
 local building = CreateObject(GetHashKey("clrp_house_1"), generator.x, generator.y-0.05, generator.z+1.26253700-89.825, false, false, false)
 FreezeEntityPosition(building, true)
 Citizen.Wait(500)
 SetEntityCoords(PlayerPedId(), generator.x+3.6, generator.y-14.8, generator.z+2.9)
 SetEntityHeading(PlayerPedId(), 358.106)

 local dt = CreateObject(GetHashKey("V_16_DT"), generator.x-1.21854400, generator.y-1.04389600, generator.z+1.39068600, false, false, false)
 local mpmid01 = CreateObject(GetHashKey("V_16_mpmidapart01"), generator.x+0.52447510, generator.y-5.04953700, generator.z+1.32, false, false, false)
 local mpmid09 = CreateObject(GetHashKey("V_16_mpmidapart09"), generator.x+0.82202150, generator.y+2.29612000, generator.z+1.88, false, false, false)
 local mpmid07 = CreateObject(GetHashKey("V_16_mpmidapart07"), generator.x-1.91445900, generator.y-6.61911300, generator.z+1.45, false, false, false)

	--props
 local beerbot = CreateObject(GetHashKey("Prop_CS_Beer_Bot_01"), generator.x+1.73134600, generator.y-4.88520200, generator.z+1.91083000, false, false, false)
 local couch = CreateObject(GetHashKey("v_res_mp_sofa"), generator.x-1.48765600, generator.y+1.68100600, generator.z+1.33640500, false, false, false)
 local chair = CreateObject(GetHashKey("v_res_mp_stripchair"), generator.x-4.44770800, generator.y-1.78048800, generator.z+1.21640500, false, false, false)
 local chair2 = CreateObject(GetHashKey("v_res_tre_chair"), generator.x+2.91325400, generator.y-5.27835100, generator.z+1.22746400, false, false, false)
 local plant = CreateObject(GetHashKey("Prop_Plant_Int_04a"), generator.x+2.78941300, generator.y-4.39133900, generator.z+2.12746400, false, false, false)
 local lamp = CreateObject(GetHashKey("v_res_d_lampa"), generator.x-3.61473100, generator.y-6.61465100, generator.z+2.09373700, false, false, false)
 local fridge = CreateObject(GetHashKey("v_res_fridgemodsml"), generator.x+1.90339700, generator.y-3.80026800, generator.z+1.29917900, false, false, false)
 local micro = CreateObject(GetHashKey("prop_micro_01"), generator.x+2.03442400, generator.y-4.64585100, generator.z+2.28995600, false, false, false)

 FreezeEntityPosition(couch,true)
 FreezeEntityPosition(chair,true)
 FreezeEntityPosition(chair2,true)
 FreezeEntityPosition(plant,true)
 FreezeEntityPosition(lamp,true)
 FreezeEntityPosition(fridge,true)
 FreezeEntityPosition(micro,true)
end
