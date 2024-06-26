import in your fxmanifest script :

client scripts {
    '@erioz_npc_lib/client.lua'
}

for use functions :

npc:new(playerSrc, model, pos) : create an npc
npc:delete(uid) : delete an npc
npc:deleteall() : delete all npc
npc:addName(uid, 'name') : add name a an npc / exemple : npc:addName(1, 'its a name')
npc:removeName(uid) : remove name a an npc with an name
npc:replaceName(uid, 'newName') : set a name for an npc with an name
npc:freeze(uid, toggle) : freeze an npc / toggle = true or false
npc:godMod(uid, toggle) : set an npc in a godMod / toggle = true or 
npc:alpha(uid, level) : set an npc in a alpha mod / level = alpha, 500 = normal level, 100 = transparent level
npc:addWeapon(uid, weapon, ammoCount) : add weapon a an npc exemple weapon = 'WEAPON_PISTOL', exemple ammoCount : 500
npc:removeWeapon(uid, weapon) : remove weapon a an npc exemple weapon = 'WEAPON_PISTOL'
npc:taskCombatNPC(uid, uid2) : uid / uid2 = ped fight ped2
npc:followPlayer(uid, player) : An npc follow an player for player = source then player = PlayerId()
npc:PlayAnim(uid, animDict, animName) : An npc executed an animation exemple : npc:PlayAnim(ped, "amb@world_human_cheering@male_a", "base")
npc:stopAnim(uid) : stop an animation of an npc
npc:revive(uid) : revive an npc dead
npc:SetCoords(uid, coords) : set a coords of an npc
npc:tpToNpc(uid) : tp to npc
npc:tpNpcAtMe(uid) : tp an npc at me
npc:BlockingEvent(uid, toggle) : off an environment for an npc


principal command 'crun' for execute an code in a f8 console !
command 'npcuid' for see a uid of all npc created !
command 'npc_revive (uid)' for revive an npc dead !

exemple d'utilisation :

f8 -> crun npc:new(PlayerPedId(), 'a_f_m_tramp_01', GetEntityCoords(PlayerPedId()))