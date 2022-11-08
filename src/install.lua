-- This is a file which should be called to init the SCU system

-- The lib URLs
local baseURL = "https://raw.githubusercontent.com/federicofusco/spu/main/src"
local libURL = baseURL .. "/core"
local serviceURL = baseURL .. "/services"
local configURL = baseURL .. "/config"
local cliURL = baseURL .. "/cli"

-- Creates the SCU directory
local directory = "/scu"
fs.makeDir ( directory )

-- [[ Downloads libs ]]
shell.run ( "wget", libURL .. "/libtoml.lua", directory .. "/core/libtoml.lua" )
shell.run ( "wget", libURL .. "/libconfig.lua", directory .. "/core/libconfig.lua" )

shell.run ( "wget", serviceURL .. "/harvestd.lua", directory .. "/services/harvestd.lua" )

-- [[ Sets up logs ]]
fs.open ( directory .. "/services/logs/harvestd.debug.log", "w" ).close ()
fs.open ( directory .. "/services/logs/harvestd.log", "w" ).close ()

-- [[ Creates default config files ]]
shell.run ( "wget", configURL .. "/harvestd.toml", directory .. "/config/harvestd.toml" )

-- [[ Sets up the CLI ]]
shell.run ( "wget", cliURL .. "/main.lua", directory .. "/cli/main.lua" )
shell.run ( "wget", cliURL .. "/stdout.lua", directory .. "/cli/stdout.lua" )
shell.run ( "wget", cliURL .. "/command.lua", directory .. "/cli/command.lua" )
shell.run ( "wget", cliURL .. "/help/start.lua", directory .. "/cli/help/start.lua" )
shell.run ( "wget", cliURL .. "/help/nil.lua", directory .. "/cli/help/nil.lua" )

-- [[ Sets up aliases ]]
shell.setAlias ( "scu", "/scu/cli/main" )