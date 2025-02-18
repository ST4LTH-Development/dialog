Open = false
cam = nil
Peds = {}

if Config.FrameworkLoadinEvent ~= '' then
    RegisterNetEvent(Config.FrameworkLoadinEvent, function()
        SpawnPeds()
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if #Config.peds ~= 0 then SpawnPeds() end
    end
end)

---@param ped number # The id of the ped
---@param data table # The data for the interaction
---@param zoom number # Camera zoom level (optional, default: 40.0)
---@param x number # Camera X position (optional, default: 0)
---@param y number # Camera Y position (optional, default: 1.5)
---@param z number # Camera Z position (optional, default: 0.3)
---@param rotX number # Camera X rotation (optional, default: 0.0)
---@param rotY number # Camera Y rotation (optional, default: 0.0)
---@param rotZ number # Camera Z rotation (optional, default: GetEntityHeading(ped) + 180)
OpenDialog = function(ped, data, zoom, x, y, z, rotX, rotY, rotZ)
    -- Setting defaults
    local newX, newY, newZ = x or 0, y or 1.5, z or 0.3
    local newRotX, newRotY, newRotZ = rotX or 0.0, rotY or 0.0, rotZ or GetEntityHeading(ped) + 180
    local fov = zoom or 40.0

    local coords = GetOffsetFromEntityInWorldCoords(ped, newX, newY, newZ)

    -- camera setup
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetEntityLocallyInvisible(PlayerPedId())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
    SetCamRot(cam, newRotX, newRotY, newRotZ, 5)
    SetCamFov(cam, fov)

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
    DestroyCam(cam, true)
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