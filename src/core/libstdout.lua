
-- [[
--     This file is responsible for all the turtle's standard output methods
-- ]]

-- Initializes the libstdout object
local libstdout = {}

-- Displays an error message
libstdout.error = function ( error, context )
    context = context or "Error"
    print ( "[" .. context .. "]: " .. error )
end

-- Displays an info message
libstdout.info = function ( info, context ) 
    context = context or "Info"
    print ( "[" .. context .. "]: " .. info )
end

-- Prints a log statement to the given debug log
libstdout.debugLog = function ( str, debugLogPath, context )
    context = context or "Debug"
    local logFile = fs.open ( debugLogPath, "a" )
    logFile.writeLine ( str )
    logFile.close ()
end

-- Prints a log statement to the given log
libstdout.log = function ( str, logPath, context )
    context = context or "Log"
    local logFile = fs.open ( logPath, "a" )
    logFile.writeLine ( str )
    logFile.close ()
end

return libstdout