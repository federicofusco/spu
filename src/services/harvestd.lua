-- Parses the relative config file
package.path = "/.scu/core/?.lua;" .. package.path
local libconfig = require ( "libconfig" )
local config = libconfig.parseConfigFile ( "harvestd" )["harvestd"]

-- local variables
local currentLimit = 1 -- 1 Represents right, 0 left

function log ( str, debug )
    debug = debug or true
    if ( debug ) then  
        local log = fs.open ( config["debug-log-path"], "a" )
        log.writeLine ( str )
        log.close ()
    else
        local log = fs.open ( config["log-path"], "a" )
        log.writeLine ( str )
        log.close () 
    end
end

-- Gets the item index 
-- RETURNS: Slot index if the item is in the inventory, or nil
function getItemIndex ( index )
    for x = 1, 16, 1 do

        -- Checks if the item matches the index
        local item = turtle.getItemDetail ( x )
        if ( item ~= nil and item["name"] == index ) then
            return x
        end
    end

    -- The item is not in the inventory
    return nil
end

-- Checks if the current plant has grown
-- RETURNS: A boolean representing whether or not the current plant is eligible to be harvested, nil if the block is not a plant
function isPlantGrown ()
    local _, blockData = turtle.inspect ()
    return blockData["state"]["age"] >= config["min-crop-age"]
end

-- Succ
function suckItems ()
    for x = 1, config["max-suck-iterations"], 1 do
        turtle.suck ()
    end
end

-- Replants the current plantPLANT_MIN_AGE
-- RETURNS: A boolean representing whether or not the plant was replanted
function replant ()

    -- Checks if the block exists
    if ( turtle.detect () ) then

        -- Replaces the block
        turtle.dig ()
        suckItems ()
        local plantIndex = getItemIndex ( config["crop"] )
        if ( plantIndex ~= nil ) then
            turtle.select ( plantIndex )
            turtle.place ()
            return true
        else

            -- No plant available
            return false
        end
    else

        -- No block in front
        return false
    end
end

-- Checks if the turtle has reached the limit
-- RETURNS: Boolean representing whether or not it has reached the limit
function updateLimit ()

    -- Checks if there is an obstruction to the current path
    if ( currentLimit == 1 ) then
        turtle.turnLeft ()
    else
        turtle.turnRight ()
    end

    local reached = turtle.detect ()
    if ( reached ) then
        currentLimit = math.abs ( currentLimit - 1 )
        return reached
    end

    return false
end

-- Moves the turtle laterally alogn the row
function moveLaterally ( lengthKnown )

    if ( lengthKnown ~= true ) then 

        -- Checks if the turtle has reached the limit
        local reached = updateLimit ()
        if ( reached ) then

            if ( currentLimit == 0 ) then
                turtle.turnRight ()
            else
                turtle.turnLeft ()
            end

            return false
        end
    else
        
        -- Turns the turtle
        if ( currentLimit == 1 ) then
            turtle.turnLeft ()
        else
            turtle.turnRight ()
        end
    end

    -- Currently at the right limit (needs to move left)
    if ( currentLimit == 1 ) then
        turtle.forward ()
        turtle.turnRight ()

    -- Currently at the left limit (needs to move right)
    else
        turtle.forward ()
        turtle.turnLeft ()
    end

    return true
end

-- MAIN FUNCTION
while true do
    os.sleep ( 0 ) -- Avoids "too long without yielding" error, this could be avoided if there was a crop growth event, but no

    -- Checks if the current plant has grown
    if ( isPlantGrown () ) then

        replant ()

        if ( config["row-length"] ~= nil ) then

            -- Moves the specified length in the config 
            for _ = 1, config["row-length"] - 1, 1 do -- Needs to subtract 1 from the row length, because one space is already occupied by the turtle itself
                moveLaterally ( true )
                replant ()
            end

            -- Inverts the currentLimit
            currentLimit = math.abs ( currentLimit - 1 )
        else

            -- Moves until it runs into an obstacle
            while moveLaterally () do
               replant ()
            end
        end
    end
end