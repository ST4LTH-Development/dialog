fx_version 'cerulean'
game 'gta5'

author 'ST4lTH'
description 'Dialog'
version '1.0.0'

client_scripts {
    'client/*.lua',
}

shared_scripts {
    'config.lua',
}

files {
    'web/dist/index.html',
    'web/dist/**/*',
}

lua54 'yes'

ui_page 'web/dist/index.html'
--ui_page 'http://localhost:3000/' -- Dev