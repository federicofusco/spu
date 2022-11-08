-- This is a file which should be called to init the SCU system

-- The lib URLs
local libURL = "https://raw.githubusercontent.com/federicofusco/spu/main/src/core"
local serviceURL = "https://raw.githubusercontent.com/federicofusco/spu/main/src/util/"
local configURL = "https://raw.githubusercontent.com/federicofusco/spu/main/src/config"

-- Creates the SCU directory
local directory = "/.scu"
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