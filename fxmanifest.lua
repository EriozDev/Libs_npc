fx_version 'bodacious'
games { 'gta5' }

lua54 'yes'

client_scripts {
    '@shadow/client/cl_antitriggers.lua',
'client.lua',
}

            
server_scripts {
    '@shadow/config.lua',
    '@shadow/server/antitrigger_shared.lua',
    '@shadow/server/_antitriggers.lua',
    '@shadow/server/funcs.lua',
'server.lua'
}