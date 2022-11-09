
-- [[
--     This file is responsible for all turtle's "abstract" movement
-- ]]

local libstdout = require ( "libstdout" )

-- Initializes the libturtle object
local libturtle = {}

-- Makes a 180 degree rotation
libturtle.turnAround = function ()
    turtle.turnRight ()
    turtle.turnRight ()
end

-- Gets the index of a given item in the inventory, or nil if it isn't present
libturtle.getItemIndex = function ( index, log )
    for x = 1, 16, 1 do

        -- Checks if the item matches the index
        local item = turtle.getItemDetail ( x )
        if ( item ~= nil and item["name"] == index ) then
            return x
        end
    end

    -- The item is not in the inventory
    if ( log ~= nil ) then libstdout.log ( "Didn't find item " .. index .. "in inventory!", log, "WARN" ) end
    return nil
end

-- Sucks all of the items in front of the turtle
libturtle.suckItems = function ( maxSuckIterations )
    for _ = 1, maxSuckIterations, 1 do
        turtle.suck ()
    end
end

-- Sets the turtle's rotation based on its path
libturtle.setRotation = function ( rot, limit, facing )
    if ( facing == rot ) then return end -- edge case where if rot is 0 it might mean to turnAround, but that doesn't seem to be an issue

    if ( rot == 0 ) then

        -- Moving left
        if ( limit == 1 ) then
            if ( facing == 1 ) then turtle.turnLeft () elseif ( facing == -1 ) then turtle.turnRight () end
        
        -- Moving right
        else
            if ( facing == 1 ) then turtle.turnRight () elseif ( facing == -1 ) then turtle.turnLeft () end
        end
    elseif ( rot == 1 ) then
        if ( facing == 0 ) then
            if ( limit == 1 ) then turtle.turnRight () else turtle.turnLeft () end
        else
            libturtle.turnAround ()
        end
    elseif ( rot == -1 ) then
        if ( facing == 0 ) then
            if ( limit == 1 ) then turtle.turnLeft () else turtle.turnRight () end
        else
            libturtle.turnAround ()
        end
    end

    facing = rot
end

-- Replants the front facing crop
libturtle.replantSingle = function ( crop, maxSuckIterations, log )

    -- Checks if the block exists
    if ( turtle.detect () ) then

        -- Replaces the block
        turtle.dig ()
        libturtle.suckItems ( maxSuckIterations )
        local plantIndex = libturtle.getItemIndex ( crop )
        if ( plantIndex ~= nil ) then
            turtle.select ( plantIndex )
            turtle.place ()
            return true
        else

            -- No plant available
            if ( log ~= nil ) then libstdout.log ( "No plant in inventory to replant!", log, "ERROR" ) end
            return false
        end
    else

        -- No block in front
        if ( log ~= nil ) then  libstdout.log ( "No block to replant!", log, "ERROR" ) end
        return false
    end
end

-- Replants crop on both sides 
libturtle.replantDouble = function ( crop, limit, facing, maxSuckIterations, log )
    libturtle.setRotation ( 1, limit, facing )
    libturtle.replantSingle ( crop, maxSuckIterations, log )
    libturtle.turnAround ()
    libturtle.replantSingle ( crop, maxSuckIterations, log )
end

-- Handler for replantSingle() and replantDouble()
libturtle.replant = function ( doubleSided, crop, limit, facing, maxSuckIterations, log )
    if ( doubleSided ) then libturtle.replantDouble ( crop, limit, facing, maxSuckIterations, log ) else libturtle.replantSingle ( crop, maxSuckIterations, log ) end
    libturtle.setRotation ( 0, limit, facing )
end

return libturtle