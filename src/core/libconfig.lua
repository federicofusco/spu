-- Gets the TOML parser from libtoml
local libtoml = require ( "libtoml" )

-- Inits the config object
local libconfig = {}

-- Parses a given config file
-- PARAMS: 
--  * util -> the name of the util who'se config file will be parsed (ex "harvest" -> "/config/harvest.toml")
libconfig.parseConfigFile = function ( util )

    -- Opens the config file
    local configFile = fs.open ( "/.scu/config/" .. util .. ".toml", "r" )
    local config = configFile.readAll ()
    configFile.close ()

    -- Parses the config 
    config = libtoml.parse ( config )

    return config
end

return libconfig