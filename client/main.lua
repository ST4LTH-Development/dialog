Open = false
Peds = {}

RegisterNetEvent(Config.FrameworkLoadinEvent, function()
    SpawnPeds()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        SpawnPeds()
    end
end)

OpenDialog = function(ped, data)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 1.5, 0.3)
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetEntityLocallyInvisible(PlayerPedId())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180, 5)
    SetCamFov(cam, 40.0)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'New',
        data = data
    })
    Open = true
    SetInvisible()
end

SetDialog = function(data)
    SendNUIMessage({
        type = 'Set',
        data = data
    })
end

CloseDialog = function()
    Open = false
    SendNUIMessage({
        type = 'Close',
    })
end

SpawnPedByID = function(id, data) 
    Peds[id] = data
    SpawnPed(id, data)
end

DeletePedByID = function(id) 
    if Peds[id].ped then
        exports['qb-target']:RemoveTargetEntity(Peds[id].ped)
        DeleteEntity(Peds[id].ped)
        Peds[id] = nil
    end
end

RegisterNUICallback('click', function(data, cb)
    if data.data then
        SendNUIMessage({
            type = 'Continue',
            data = data.data
        })
        cb(false)
        return
    end

    if data.close then
        Open = false
        RenderScriptCams(false, true, 500, true, true)
        SetNuiFocus(false, false)
        cb('close')
    end

    if data.event then
        local args = data.args or {}

        if data.server then
            TriggerServerEvent(data.event, args)
        else
            TriggerEvent(data.event, args)
        end
    end
end)
exports('OpenDialog', OpenDialog)
exports('SetDialog', SetDialog)
exports('CloseDialog', CloseDialog)
exports('SpawnPed', SpawnPedByID)
