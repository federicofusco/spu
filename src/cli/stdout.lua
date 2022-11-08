
-- [[
--     This file is responsible for all the CLI's standard output methods
-- ]]

-- Initializes the stdout object
local stdout = {}

-- Displays an error message
stdout.error = function ( error, context )
    context = context or "Error"
    print ( "[" .. context .. "]: " .. error )
end

-- Displays an info message
stdout.info = function ( info, context ) 
    context = context or "Info"
    print ( "[" .. context .. "]: " .. info )
end

return stdout