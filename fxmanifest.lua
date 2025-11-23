fx_version 'cerulean'
game 'gta5'

author 'Mohammed AbuYasser'
description 'ESX Arabic Command Logger with RTL Discord Webhooks'
version '1.3.0'

lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'Client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/main.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
