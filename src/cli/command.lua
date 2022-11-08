-- [[
--     This file is responsible for the execution of all the CLI commands
-- ]]

local stdout = require ( "stdout" )

-- Initializes the command object
local command = {}
local commands = { 
    {
        name = "start",
        run = "/scu/services/",
        options = {
            "harvest"
        }
    },
    {
        name = "help",
        run = "/scu/cli/help/",
        options = {
            "start"
        }
    }
}

local function getCommand ( cmd )
    for _, c in ipairs ( commands ) do
        if c["name"] == cmd then
            return c
        end
    end

    return nil
end

-- Determines whether or not a command is valid
-- RETURNS: A boolean
command.valid = function ( cmd, option )
    
    -- Checks if the command is valid
    local _cmd = getCommand ( cmd )
    if ( _cmd == nil ) then return false end

    for _, o in ipairs ( _cmd["options"] ) do
        if o == option then
            return true
        end
    end

    return false
end

-- Executes a given command, 
-- WARNING: This function assumes that command.valid has already validated the command and option
command.run = function ( cmd, option )
    local _cmd = getCommand ( cmd )
    if ( _cmd == nil ) then 
        stdout.error ( "Something went wrong! (code: command.run/invalid-command)!", "PANIC" )
        return nil
    end

    shell.run ( _cmd["run"] .. option )
end

return command