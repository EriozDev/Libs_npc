Citizen.CreateThread(function()
    if GetCurrentResourceName() ~= "erioz_npc_lib" then
        for i = 1, 10 do
            print("^1 The name of the resource is Invalid ! Please rename resource to : erioz_npc_lib^0")
        end
        os.exit()
    end
end)
