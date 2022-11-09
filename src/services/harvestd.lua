-- Parses the relative config file
package.path = "/.scu/core/?.lua;" .. package.path
local libconfig = require ( "libconfig" )
local libstdout = require ( "libstdout" )
local config = libconfig.parseConfigFile ( "harvestd" )
local harvestdConfig = config["harvestd"]
local logConfig = config["log"]
local stateConfig = config["state"]

local crop = harvestdConfig["crop"] or libstdout.error ( "Crop property mu be set!", "Config" )
local doubleSided = harvestdConfig["double-sided"] or false
local rowLength = harvestdConfig["row-length"] or nil
local minCropAge = harvestdConfig["min-crop-age"] or 7
local maxSuckIterations = harvestdConfig["max-suck-iterations"] or 5

local debugLogPath = logConfig["debug-log-path"] or "/.scu/services/logs/harvestd.debug.log"
local logPath = logConfig["log-path"] or "/.scu/services/logs/harvestd.log"

local limit = stateConfig["limit"] or 1
local facing = stateConfig["facing"] or 1

local libturtle = require ( "libturtle" )

-- Checks if the front facing plant has grown
function isPlantGrown ()
    local isBlock, blockData = turtle.inspect ()
    if ( isBlock ) then
        return blockData["state"]["age"] >= minCropAge
    else

        -- No plant, somethings wrong
        libstdout.log ( "No plant in inspect!", logPath )
    end

    return nil
end

function moveAlong ()
    if ( rowLength == nil ) then
    
        -- Checks for obstacles
        local reached = turtle.detect ()
        if ( reached ) then
            
            -- Inverts the limit
            limit = math.abs ( limit - 1 )
        
            -- Starts observing plant on the right
            libturtle.setRotation ( 1, limit, facing )
            return false
        end
    end

    turtle.forward ()
    return true
end


-- [[ MAIN LOOP ]]

-- Sets the turtle to face crop on the right
libturtle.setRotation ( 1, limit, facing )

while true do

    -- Checks if the plant has grown
    if ( isPlantGrown () ) then
        if ( rowLength ~= nil ) then
            for _ = 1, rowLength - 1, 1 do

                -- Replants the crop
                libturtle.replant ( doubleSided, crop, limit, facing, maxSuckIterations, logPath )

                -- Moves along the row
                moveAlong ()
            end
        else

            -- Moves until it runs into an obstacle
            while moveAlong () do
                libturtle.replant ( doubleSided, crop, limit, facing, maxSuckIterations, logPath )
            end
        end
    end
end
































-- -- Checks if the turtle has reached the limit
-- -- RETURNS: Boolean representing whether or not it has reached the limit
-- function updateLimit ()

--     -- Checks if there is an obstruction to the current path
--     setRotation ( 0 )
--     local reached = turtle.detect ()
--     if ( reached ) then
--         currentLimit = math.abs ( currentLimit - 1 )
--         return reached
--     end

--     return false
-- end

-- function replantColumn ( endRot )
--     setRotation ( 1 )
--     replant () -- Replants the right
--     turnAround ()
--     replant () -- Replants the left

--     -- Sets the final rotation
--     setRotation ( endRot )
-- end

-- function replant ()
--     if ( config["harvestd"]["double-sided"] ) then
--         replantColumn ( facing )
--     else
--         replantSingle ()
--     end
-- end

-- -- Moves the turtle laterally alogn the row
-- function moveLaterally ( lengthKnown )

--     if ( lengthKnown ~= true ) then

--         -- Checks if the turtle has reached the limit
--         local reached = updateLimit ()
--         if ( reached ) then

--             -- Since the end of the row has been reached, starts observing the crop
--             if ( currentLimit == 0 ) then
--                 turtle.turnRight ()
--             else
--                 turtle.turnLeft ()
--             end

--             return false
--         end
--     else
--         setRotation ( 0 )
--     end

--     -- Currently at the right limit (needs to move left)
--     if ( currentLimit == 1 ) then
--         turtle.forward ()
--         turtle.turnRight ()

--     -- Currently at the left limit (needs to move right)
--     else
--         turtle.forward ()
--         turtle.turnLeft ()
--     end

--     return true
-- end

-- -- MAIN FUNCTION
-- while true do
--     os.sleep ( 0 ) -- Avoids "too long without yielding" error, this could be avoided if there was a crop growth event, but no

--     -- Checks if the current plant has grown
--     if ( isPlantGrown () ) then

--         replant ()

--         if ( config["harvestd"]["row-length"] ~= nil ) then

--             -- Moves the specified length in the config
--             for _ = 1, config["harvestd"]["row-length"] - 1, 1 do -- Needs to subtract 1 from the row length, because one space is already occupied by the turtle itself
--                 moveLaterally ( true )
--                 replant ()
--             end

--             -- Inverts the currentLimit
--             currentLimit = math.abs ( currentLimit - 1 )
--         else

--             -- Moves until it runs into an obstacle
--             while moveLaterally () do
--                replant ()
--             end
--         end
--     end
-- end