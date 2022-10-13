fx_version 'cerulean'
games { 'gta5' }

author 'Nullified'

shared_scripts {
	'config.lua',
	'shared/*.lua'
}

server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
client_script 'client/*.lua'
