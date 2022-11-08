-- [[
--     This file is responsible for the execution of all the CLI commands
-- ]]

local stdout = require ( "stdout" )

-- Initializes the command object
local command = {}
local commands = { 
    {
        name = "start",
        run = "/.scu/services/",
        options = {
            { "harvest", "harvestd" }
        }
    },
    {
        name = "help",
        run = "/.scu/cli/help/",
        options = {
            { "start", "start" }
        }
    }
}

-- Gets the command object by its name
local function getCommand ( cmd )
    for _, c in ipairs ( commands ) do
        if c["name"] == cmd then
            return c
        end
    end

    return nil
end

-- Gets the option array based on its first value
local function getOption ( cmd, option )
    for _, o in ipairs ( cmd["options"] ) do
        if o[1] == option then
            return o
        end
    end

    return nil
end

-- Determines whether or not a command is valid
-- RETURNS: A boolean
command.valid = function ( cmd, option )
    
    -- Checks if the command is valid
    local _cmd = getCommand ( cmd )
    if ( _cmd == nil ) then 
        return false 
    end

    for _, o in ipairs ( _cmd["options"] ) do
        if o[1] == option then
            return true
        end
    end

    return false
end

-- Executes a given command, 
-- WARNING: This function assumes that command.valid has already validated the command and option
command.run = function ( cmd, option )
   
    -- Gets the command
    local _cmd = getCommand ( cmd )
    if ( _cmd == nil ) then 
        stdout.error ( "Something went wrong!\n(code: command.run/invalid-command)!", "PANIC" )
        return nil
    end

    -- Gets the option 
    local _option = getOption ( _cmd, option )
    if ( _option == nil ) then 
        stdout.error ( "Something went wrong!\n(code: command.run/invalid-option)!", "PANIC" )
        return nil 
    end

    shell.run ( _cmd["run"] .. _option[1] )
end

return command