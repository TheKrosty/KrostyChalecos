

fx_version 'adamant'
game 'gta5'


client_script {
	'config.lua',
	'client/*.lua',
} 

server_scripts {
	'config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua',
} 

