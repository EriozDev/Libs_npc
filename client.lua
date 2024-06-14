-- ERIOZ
npc = {}
npcCreated = {}
npcUIDCounter = 0
displayUIDs = false

local __instance = {
    __index = npc,
    __type = 'npc'
}

setmetatable({}, __instance)

function npc:new(playerSrc, model, pos)
    local self = {}
    setmetatable(self, { __index = npc })
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
    npc:init(uid)
    return uid
end

function npc:GetNpcByUniqueId(uid)
    local npc = npcCreated[uid]
    if npc then
        return npc
    end
    print("No NPC found with UID :", uid)
end

function npc:delete(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        if DoesEntityExist(npcPed) then
            DeleteEntity(npcPed)
        else
            print('No NPC found with UID:', uid)
        end
    else
        print('No NPC found with UID:', uid)
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

function npc:addName(uid, name)
    local npcPed = npcCreated[uid]
    if npcPed then
        GamerTag = CreateFakeMpGamerTag(npcPed,
            ("%s"):format(name), false, false, "test", false)
        SetMpGamerTagAlpha(GamerTag, 0, 150)
        SetMpGamerTagColour(GamerTag, 0, 4)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:removeName(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        RemoveMpGamerTag(GamerTag)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:freeze(uid, toggle)
    local npcPed = npcCreated[uid]
    if npcPed then
        FreezeEntityPosition(npcPed, toggle)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:godMod(uid, toggle)
    local npcPed = npcCreated[uid]
    if npcPed then
        SetEntityInvincible(npcPed, toggle)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:alpha(uid, level)
    local npcPed = npcCreated[uid]
    if npcPed then
        SetEntityAlpha(npcPed, level)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:addWeapon(uid, weapon, ammoCount)
    local npcPed = npcCreated[uid]
    if npcPed then
        local weaponHash = GetHashKey(weapon)
        GiveWeaponToPed(npcPed, weaponHash, ammoCount, false, true)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:removeWeapon(uid, weapon)
    local npcPed = npcCreated[uid]
    if npcPed then
        local weaponHash = GetHashKey(weapon)
        RemoveWeaponFromPed(npcPed, weaponHash)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:taskCombatNPC(uid, uid2)
    local npcPed = npcCreated[uid]
    local npcPed2 = npcCreated[uid2]
    if npcPed and npcPed2 then
        TaskCombatPed(npcPed, npcPed2, false, false)
    else
        print("An npc is invalid")
    end
end

function npc:followPlayer(uid, player)
    local playerPed = GetPlayerPed(player)
    local npcPed = npcCreated[uid]
    if npcPed then
        TaskFollowToOffsetOfEntity(npcPed, playerPed, 0.0, 0.0, 0.0, 1.0, -1, 5.0, true)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:PlayAnim(uid, animDict, animName)
    local npcPed = npcCreated[uid]
    if npcPed then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(1)
        end
        TaskPlayAnim(npcPed, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:StopAnim(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        ClearPedTasks(npcPed)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:revive(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        if IsEntityDead(npcPed) then
            ResurrectPed(npcPed)
            ClearPedTasksImmediately(npcPed)
            SetEntityHealth(npcPed, GetEntityMaxHealth(npcPed))
            print("NPC with UID " .. uid .. " has been revived.")
        else
            print("NPC with UID " .. uid .. " is not dead.")
        end
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:SetCoords(uid, coords)
    local npcPed = npcCreated[uid]
    local w = coords
    if npcPed then
        SetEntityCoords(npcPed, w.x, w.y, w.z, false, false, false, false)
    else
        print('No NPC found with UID:', uid)
    end
end

function npc:tpToNpc(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        local i = PlayerPedId()
        local x = GetEntityCoords(npcPed)
        SetEntityCoords(i, x.x, x.y, x.z, false, false, false, false)
    else
        print('No NPC found with UID: ', uid)
    end
end

function npc:tpNpcAtMe(uid)
    local npcPed = npcCreated[uid]
    if npcPed then
        local pos = GetEntityCoords(PlayerPedId())
        SetEntityCoords(npcPed, pos.x, pos.y, pos.z, false, false, false, false)
    else
        print('No NPC found with UID: ', uid)
    end
end

function npc:ignore(uid, toggle)
    local npcPed = npcCreated[uid]
    if npcPed then
        SetBlockingOfNonTemporaryEvents(npcPed, toggle)
    else
        print('No NPC found with UID: ', uid)
    end
end

function npc:init(uid)
    local x = GetPlayerServerId(PlayerId())
    print('[^6DEBUG^0] Npc with uid ' .. uid .. ' was created by ' .. x)
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
    if uid then
        npc:revive(uid)
    else
        print("Please specify a valid UID.")
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
