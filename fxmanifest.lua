fx_version 'cerulean'
game 'gta5'

author 'ST4lTH'
description 'Conversations'
version '1.0.0'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}


shared_script '@ox_lib/init.lua'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

files {
    'web/dist/index.html',
    'web/dist/**/*',
}

lua54 'yes'

--ui_page 'web/dist/index.html'
ui_page 'http://localhost:3000/' -- Dev