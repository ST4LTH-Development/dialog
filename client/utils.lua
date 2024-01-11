local loadModel = function(modelHash)
    if not IsModelValid(modelHash) then
        print(modelHash..' Is not a valid model') 
        return
    end

    RequestModel(modelHash)
    RequestCollisionForModel(modelHash)

    while not HasModelLoaded(modelHash) or not HasCollisionForModelLoaded(modelHash) do
        Wait(10)
    end
end

local getClosestPed = function(coords, max)
	local all = GetGamePool('CPed')
	local closest, closestCoords
	max = max or 2.0

	for i = 1, #all do
		local ped = all[i]

        if IsPedAPlayer(ped) then
            return
        end

        local pedCoords = GetEntityCoords(ped)
        local distance = #(coords - pedCoords)

        if distance < max then
            max = distance
            closest = ped
            closestCoords = pedCoords
        end
	end

	return closest, closestCoords
end

local loadanimDict = function(animDict) 
    if not DoesAnimDictExist(animDict) then 
        print(animDict..' Is not a valid animation dict') 
        return 
    end

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end
end

local playAnimation = function(animData)
    if not IsEntityPlayingAnim(animData.ped, animData.dict, animData.lib, 3) then
        if not animData.flag then animData.flag = 49 end

        loadanimDict(animData.dict)
        TaskPlayAnim(animData.ped, animData.dict, animData.lib, 2.0, -1.0, -1, animData.flag, 0, 0, 0, 0)
    end
end

SpawnPeds = function()
    for v, k in pairs(Config.peds) do
        Peds[v] = k
        SpawnPed(v, k)
    end
end

SpawnPed = function(id, data)
    local ped, pedDist = getClosestPed(data.coords)
    if data.dict then
        dict = data.dict
    else
        dict = "missbigscore2aig_6"
    end

    if data.lib then
        lib = data.lib
    else
        lib = "wait_loop"
    end

    if DoesEntityExist(ped) and pedDist <= 1.2 then
        DeletePed(ped)
    end

    loadModel(data.model)

    Peds[id].ped = CreatePed(5, GetHashKey(data.model), data.coords.x, data.coords.y, data.coords.z - 1.0, data.heading, false, false)

    SetEntityHeading(Peds[id].ped, data.heading)

    SetPedCombatAttributes(Peds[id].ped, 46, true)                     
    SetPedFleeAttributes(Peds[id].ped, 0, 0)               
    SetBlockingOfNonTemporaryEvents(Peds[id].ped, true)
    
    SetEntityAsMissionEntity(Peds[id].ped, true, true)
    FreezeEntityPosition(Peds[id].ped, true)
    SetEntityInvincible(Peds[id].ped, true)
    SetPedDiesWhenInjured(Peds[id].ped, false)
    SetPedHearingRange(Peds[id].ped, 1.0)
    SetPedAlertness(Peds[id].ped, 0)

    if data.type ~= 'scenario' then
        playAnimation({
            ped = Peds[id].ped,
            dict = dict,
            lib = lib,
            flag = 1
        })
    else
        TaskStartScenarioInPlace(Peds[id].ped, data.anim, 0, false)
    end

    opts = {
        label = data.label,
        icon = data.icon,
        action = function()
            if data.data then
                OpenDialog(Peds[id].ped, data.data)
            else 
                if data.server then
                    TriggerServerEvent(data.event, Peds[id].ped)
                else
                    TriggerEvent(data.event, Peds[id].ped)
                end
            end
        end
    }
    exports['qb-target']:AddTargetEntity(Peds[id].ped, {
        options = { opts },
        distance = 2.0
    })
end

SetInvisible = function()
    while Open do
        SetEntityLocallyInvisible(PlayerPedId())
        Wait(5)
    end
end