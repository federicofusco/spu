-- SCU home directory
local scuDirectory = "/.scu"

-- Gets the TOML parser from libtoml
local toml = require ( scuDirectory .. "/core/libtoml" )

-- Inits the config object
local config = {}

-- Parses a given config file
-- PARAMS: 
--  * util -> the name of the util who'se config file will be parsed (ex "harvest" -> "/config/harvest.toml")
config.parseConfigFile = function ( util )
    
    -- Opens the config file
    local configFile = fs.open ( scuDirectory .. "/config/" .. util .. ".toml", "r" )
    local config = configFile.readAll ()
    configFile.close ()

    -- Parses the config 
    config = toml.parse ( config )

    return config
end

return config