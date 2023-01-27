game 'gta5'
fx_version 'cerulean'
author 'n4kruG - Valeria'
server_scripts {
    'server.lua'
}
client_scripts {
    'client.lua',
}

ui_page 'nui/ui.html'

shared_script {
    '@es_extended/imports.lua',
    'config.lua',
    'FrameworkFunctions.lua'
}

files {
    'nui/**/*',
}