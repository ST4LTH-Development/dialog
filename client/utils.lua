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
	local peds = GetGamePool('CPed')
	local closest, closestCoords
	max = max or 2.0

	for i = 1, #peds do
		local ped = peds[i]

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
        local ped, pedDist = getClosestPed(k.coords)
        if k.dict then
            dict = k.dict
        else
            dict = "missbigscore2aig_6"
        end

        if k.lib then
            lib = k.lib
        else
            lib = "wait_loop"
        end

        if DoesEntityExist(ped) and pedDist <= 1.2 then
            DeletePed(ped)
        end

        loadModel(k.model)

        ped = CreatePed(5, GetHashKey(k.model), k.coords.x, k.coords.y, k.coords.z - 1.0, k.heading, false, false)

        SetEntityHeading(ped, k.heading)

        SetPedCombatAttributes(ped, 46, true)                     
        SetPedFleeAttributes(ped, 0, 0)               
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedHearingRange(ped, 1.0)
        SetPedAlertness(ped, 0)

        if k.type ~= 'scenario' then
            playAnimation({
                ped = ped,
                dict = dict,
                lib = lib,
                flag = 1
            })
        else
            TaskStartScenarioInPlace(ped, k.anim, 0, false)
        end

        opts = {
            label = k.label,
            icon = k.icon,
            action = function()
                if k.data then
                    OpenDialog(ped, k.data)
                else 
                    if k.server then
                        TriggerServerEvent(k.event, ped)
                    else
                        TriggerEvent(k.event, ped)
                    end
                end
            end
        }
        exports['qb-target']:AddTargetEntity(ped, {
            options = { opts },
            distance = 2.0
        })
    end
end

SpawnPed = function(data)
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

    ped = CreatePed(5, GetHashdataey(data.model), data.coords.x, data.coords.y, data.coords.z - 1.0, data.heading, false, false)

    SetEntityHeading(ped, data.heading)

    SetPedCombatAttributes(ped, 46, true)                     
    SetPedFleeAttributes(ped, 0, 0)               
    SetBlockingOfNonTemporaryEvents(ped, true)
    
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedHearingRange(ped, 1.0)
    SetPedAlertness(ped, 0)

    if data.type ~= 'scenario' then
        playAnimation({
            ped = ped,
            dict = dict,
            lib = lib,
            flag = 1
        })
    else
        TaskStartScenarioInPlace(ped, data.anim, 0, false)
    end

    opts = {
        label = data.label,
        icon = data.icon,
        action = function()
            if data.data then
                OpenDialog(ped, data.data)
            else 
                if data.server then
                    TriggerServerEvent(data.event, ped)
                else
                    TriggerEvent(data.event, ped)
                end
            end
        end
    }
    exports['qb-target']:AddTargetEntity(ped, {
        options = { opts },
        distance = 2.0
    })
end

SetInvisible = function()
    while Open do
        SetEntityLocallyInvisible(PlayerPedId())
        Wait(10)
    end
end