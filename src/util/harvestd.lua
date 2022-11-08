-- SCU home directory
local scuDirectory = "/.scu"

-- Parses the relative config file
local libconfig = require ( scuDirectory .. "/core/libconfig" )
local config = libconfig.parseConfigFile ( "harvest" )

local pretty = require ( "cc.pretty" )
pretty.pretty_print ( config )

 
-- -- local variables
-- local plantMinAge = 7
-- local maxSuckIterations = 5
-- local plantType = "minecraft:potato"
-- local currentLimit = 1 -- 1 Represents right, 0 left
-- local facingPlant = true
-- local debugLogPath = scuDirectory .. "/utils/harvest.debug.log"
-- local logPath = scuDirectory .. "/utils/harvest.log"

-- function log ( str )
--     local debugLog = fs.open ( logFile, "a" )
--     debugLog.writeLine ( str )
--     debugLog.close ()
-- end

-- -- Gets the item index 
-- -- RETURNS: Slot index if the item is in the inventory, or nil
-- function getItemIndex ( index )
--     for x = 1, 16, 1 do

--         -- Checks if the item matches the index
--         local item = turtle.getItemDetail ( x )
--         if ( item ~= nil and item["name"] == index ) then
--             log ( "[getItemIndex]: Found " .. index .. " at index " .. x )
--             return x
--         end
--     end

--     -- The item is not in the inventory
--     log ( "[getItemIndex]: No index " .. index .. " found!" )
--     return nil
-- end

-- -- Checks if the current plant has grown
-- -- RETURNS: A boolean representing whether or not the current plant is eligible to be harvested, nil if the block is not a plant
-- function isPlantGrown ()
--     if ( facingPlant ~= true ) then return nil end
--     local _, blockData = turtle.inspect ()
--     log ( "[isPlantGrown]: Current plant state: " .. blockData["state"]["age"] )
--     return blockData["state"]["age"] >= plantMinAge
-- end

-- -- Succ
-- function suckItems ()
--     log ( "[suckItems]: Succing" )
--     for x = 1, maxSuckIterations, 1 do
--         turtle.suck ()
--     end
-- end

-- -- Replants the current plantPLANT_MIN_AGE
-- -- RETURNS: A boolean representing whether or not the plant was replanted
-- function replant ()

--     log ( "[replant]: Replanting!" )

--     -- Checks if the block exists
--     if ( turtle.detect () ) then

--         -- Replaces the block
--         log ( "[replant]: Found plant!" )
--         turtle.dig ()
--         suckItems ()
--         local plantIndex = getItemIndex ( plantType )
--         if ( plantIndex ~= nil ) then
--             turtle.select ( plantIndex )
--             turtle.place ()
--             log ( "[replant]: Replanted!" )
--             return true
--         else

--             -- No plant available
--             log ( "[replant]: No plant available!" )
--             return false
--         end
--     else

--         -- No block in front
--         log ( "[replant]: No plant found!" )
--         return false
--     end
-- end

-- -- Checks if the turtle has reached the limit
-- -- RETURNS: Boolean representing whether or not it has reached the limit
-- function updateLimit ()

--     -- Checks if there is an obstruction to the current path
--     if ( currentLimit == 1 ) then
--         log ( "[updateLimit]: Turning left!" )
--         turtle.turnLeft ()
--         facingPlant = false
--     else
--         log ( "[updateLimit]: Turning right!" )
--         turtle.turnRight ()
--         facingPlant = false
--     end

--     local reached = turtle.detect ()
--     if ( reached ) then
--         currentLimit = math.abs ( currentLimit - 1 )
--         log ( "[updateLimit]: Current limit: " .. currentLimit )
--         return reached
--     end

--     return false
-- end

-- -- Moves the turtle laterally alogn the row
-- function moveLaterally ()

--     -- Checks if the turtle has reached the limit
--     local reached = updateLimit ()
--     log ( "[moveLaterally]: Currently at limit: " .. currentLimit )
--     log ( "[moveLaterally]: Reached limit now: " .. tostring ( reached ) )
--     if ( reached ) then

--         if ( currentLimit == 0 ) then 
--             turtle.turnRight ()    
--             facingPlant = true
--         else 
--             turtle.turnLeft ()
--             facingPlant = true
--         end

--         return false
--     end

--     -- Currently at the right limit (needs to move left)
--     if ( currentLimit == 1 ) then
--         log ( "[moveLaterally]: Moved left!" )
--         turtle.forward ()
--         turtle.turnRight ()

--     -- Currently at the left limit (needs to move right)
--     else
--         log ( "[moveLaterally]: Moved right!" )
--         turtle.forward ()
--         turtle.turnLeft ()
--     end

--     return true
-- end


-- -- MAIN FUNCTION
-- while true do

--     -- Checks if the current plant has grown
--     if ( isPlantGrown () ) then

--         log ( "[main]: Plant has grown! Staring loop!" )

--         replant ()
--         while moveLaterally () do
--             replant ()
--         end
--     end
-- end