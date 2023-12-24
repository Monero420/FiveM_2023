fx_version 	'cerulean'
game 		'gta5'
lua54 		'yes'

author 		'Your Name'
description 'Your Resource Description'
version 	'1.0.0'

-- Specify the server scripts and dependencies
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Adjust this line based on your oxmysql library resource
    'server.lua'
}

client_scripts {
	'client.lua'
}