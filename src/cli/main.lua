local stdout = require ( "stdout" )
local command = require ( "command" )

-- Checks if the correct number of parameters was supplied
if ( #arg < 2 ) then 
    
    -- Prints the error message
    stdout.error ( "scu <command> <option>", "Usage" )
    return 1
end 

-- Checks if the given command and option are valid
if ( command.valid ( arg[1], arg[2] ) ) then 

    -- Runs the command
    command.run ( arg[1], arg[2] )
else 
    stdout.error ( "Invalid arguments supplied!\nSee \"scu help\" menu for more information." )
end