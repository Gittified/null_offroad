fx_version 'cerulean'
games { 'gta5' }

version 'v1.0.0-beta' -- Do not modify
lua54 'yes'

author 'Nullified'

shared_scripts {
	'config.lua',
	'shared/*.lua'
}

server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
client_script 'client/*.lua'

dependencies {
	'/onesync',
	'oxmysql'
}
