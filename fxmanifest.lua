fx_version 'cerulean'
games { 'gta5' }

author 'HoboDevCo#3011'
description 'SDC | Object Placer Script'
version '1.0.1'

shared_script {
    '@ox_lib/init.lua',
    "config/config.lua",
    "config/lang.lua"
}

client_scripts {
    "src/client/client_customize_me.lua",
    'src/client/client.lua'
}

server_scripts {
    'src/server/server.lua',
}
lua54 'yes'