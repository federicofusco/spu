-- This is a file which should be called to init the SCU system

-- The lib URLs
local libtoml = "https://pastebin.com/raw/m4iYRdfV"
local libconfig = "https://pastebin.com/raw/iC78qRa1"
local harvestd = "https://pastebin.com/raw/QRyZ8b9i"

-- Creates the SCU directory
local directory = "/.scu"
fs.makeDir ( directory )

-- Checks if there is enough free space
local freeSpace = fs.getFreeSpace ( directory )

-- [[ Downloads libs ]]
shell.run ( "wget", libtoml, directory .. "/core/libtoml.lua" )
shell.run ( "wget", libconfig, directory .. "/core/libconfig.lua" )

shell.run ( "wget", harvestd, directory .. "/services/harvestd.lua" )

-- [[ Sets up logs ]]
fs.open ( directory .. "/services/logs/harvestd.debug.log", "w" ).close ()
fs.open ( directory .. "/services/logs/harvestd.log", "w" ).close ()

-- [[ Creates default config files ]]
fs.open ( directory .. "/config/harvestd.toml", "w" )
    .write ( "[harvestd]\nrow-length = 9\ndouble-sided = false\ncrop = \"minecraft:potato\"" )