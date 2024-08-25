---@class npc
npc = {}
npcCreated = {}
npcUIDCounter = 0
displayUIDs = false

local __instance = {
    __index = npc,
    __type = 'npc'
}

function npc:new(playerSrc, model, pos)
    local self = setmetatable({}, __instance)
    self.source = playerSrc
    self.heading = GetEntityHeading(playerSrc)
    local modelHash = GetHashKey(model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end

    local npcPed = CreatePed(4, modelHash, pos.x, pos.y, pos.z, self.heading, true, false)
    npcUIDCounter = npcUIDCounter + 1
    local uid = npcUIDCounter
    npcCreated[uid] = npcPed
    self.handle = npcPed
    npc:__init(uid)
    return uid, self
end

function GetNpcByUniqueId(uid)
    local npc = npcCreated[uid]
    if npc then
        return npc
    end
    print("No NPC found with UID :", uid)
end

function npc:delete()
    if DoesEntityExist(self.handle) then
        DeleteEntity(self.handle)
    end
end

function npc:deleteall()
    for uid, npcPed in pairs(npcCreated) do
        if DoesEntityExist(npcPed) then
            DeleteEntity(npcPed)
        end
    end
    npcUIDCounter = 0
    npcCreated = {}
end

function npc:addName(name)
    local npcPed = self.handle
    if npcPed then
        GamerTag = CreateFakeMpGamerTag(npcPed,
            ("%s"):format(name), false, false, "test", false)
        SetMpGamerTagAlpha(GamerTag, 0, 150)
        SetMpGamerTagColour(GamerTag, 0, 4)
    end
end

function npc:removeName()
    local npcPed = self.handle
    if npcPed then
        RemoveMpGamerTag(GamerTag)
    end
end

function npc:freeze(toggle)
    local npcPed = self.handle
    if npcPed then
        FreezeEntityPosition(npcPed, toggle)
    end
end

function npc:godMod(toggle)
    local npcPed = self.handle
    if npcPed then
        SetEntityInvincible(npcPed, toggle)
    end
end

function npc:alpha(level)
    local npcPed = self.handle
    if npcPed then
        SetEntityAlpha(npcPed, level)
    end
end

function npc:addWeapon(weapon, ammoCount)
    local npcPed = self.handle
    if npcPed then
        local weaponHash = GetHashKey(weapon)
        GiveWeaponToPed(npcPed, weaponHash, ammoCount, false, true)
    end
end

function npc:removeWeapon(weapon)
    local npcPed = self.handle
    if npcPed then
        local weaponHash = GetHashKey(weapon)
        RemoveWeaponFromPed(npcPed, weaponHash)
    end
end

function npc:taskCombatNPC(uid2)
    local npcPed = self.handle
    local npcPed2 = npcCreated[uid2]
    if npcPed and npcPed2 then
        TaskCombatPed(npcPed, npcPed2, false, false)
    end
end

function npc:followPlayer(player)
    local playerPed = GetPlayerPed(player)
    local npcPed = self.handle
    if npcPed then
        TaskFollowToOffsetOfEntity(npcPed, playerPed, 0.0, 0.0, 0.0, 1.0, -1, 5.0, true)
    end
end

function npc:PlayAnim(animDict, animName)
    local npcPed = self.handle
    if npcPed then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(1)
        end
        TaskPlayAnim(npcPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end

function npc:StopAnim()
    local npcPed = self.handle
    if npcPed then
        ClearPedTasks(npcPed)
    end
end

function npc:revive()
    local npcPed = self.handle
    if npcPed then
        if IsEntityDead(npcPed) then
            ResurrectPed(npcPed)
            ClearPedTasksImmediately(npcPed)
            SetEntityHealth(npcPed, GetEntityMaxHealth(npcPed))
        end
    end
end

function npc:SetCoords(coords)
    local npcPed = self.handle
    local w = coords
    if npcPed then
        SetEntityCoords(npcPed, w.x, w.y, w.z, false, false, false, false)
    end
end

function npc:tpToNpc()
    local npcPed = self.handle
    if npcPed then
        local i = PlayerPedId()
        local x = GetEntityCoords(npcPed)
        SetEntityCoords(i, x.x, x.y, x.z, false, false, false, false)
    end
end

function npc:tpNpcAtMe()
    local npcPed = self.handle
    if npcPed then
        local pos = GetEntityCoords(PlayerPedId())
        SetEntityCoords(npcPed, pos.x, pos.y, pos.z, false, false, false, false)
    end
end

function npc:BlockingEvent(toggle)
    local npcPed = self.handle
    if npcPed then
        SetBlockingOfNonTemporaryEvents(npcPed, toggle)
    end
end

function npc:__init(uid)
    if Config.Debug then
        local x = GetPlayerServerId(PlayerId())
        print('[^6DEBUG^0] Npc with uid ' .. uid .. ' was created by ' .. x)
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if displayUIDs then
            for uid, npcPed in pairs(npcCreated) do
                if DoesEntityExist(npcPed) then
                    local pos = GetEntityCoords(npcPed)
                    DrawText3D(pos.x, pos.y, pos.z + 1.0, tostring(uid))
                end
            end
        end
    end
end)

RegisterCommand('npc_uid', function(source)
    displayUIDs = not displayUIDs
end, false)

RegisterCommand('npc_revive', function(source, args, rawCommand)
    local uid = tonumber(args[1])
    local npc = GetNpcByUniqueId(uid)
    if npc then
        npc:revive()
    end
end)

RegisterCommand('crun', function(source, args, rawCommand)
    load(rawCommand:sub(6))()
end, false)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/npc_uid', 'Activer/Désactiver infos NPC')
    TriggerEvent('chat:addSuggestion', '/npc_revive', 'Relancer un NPC', {
        { name = "npcUID", help = "uid npc." }
    })
end)
