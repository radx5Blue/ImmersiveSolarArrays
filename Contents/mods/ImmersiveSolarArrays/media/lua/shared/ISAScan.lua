ISAScan = {}

function ISAScan.findPowerbank(square,radius,level,distance)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    for ix = x - radius, x + radius do
        for iy = y - radius, y + radius do
            for iz = z - level, z+level do
                if IsoUtils.DistanceToSquared(x,y,z,ix,iy,iz) <= distance then
                    local isquare = getSquare(ix, iy, iz)
                    if isquare then
                        local special = isquare:getSpecialObjects()
                        for i = 1, special:size() do
                            if special:get(i-1):getTextureName() == "solarmod_tileset_01_0" then
                                return special:get(i-1)
                            end
                        end
                    end
                end
            end
        end
    end
end

function ISAScan.squareHasPowerbank(square)
    local special = square:getSpecialObjects()
    for i = 1, special:size() do
        if special:get(i-1):getTextureName() == "solarmod_tileset_01_0" then
            return special:get(i-1)
        end
    end
    return false
end

function ISAScan.squareHasPanel(square)
    if square and square:isOutside() then
        local special = square:getSpecialObjects()
        for i = 1, special:size() do
            local obj = special:get(i-1)
            if obj then
                local spritename = obj:getSprite() and obj:getSprite():getName()
                if spritename and (spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
                        spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10") then
                    return obj
                end
            end
        end
    end
    return false
end

--function ISAScan.isSolarPanel(isoObject)
--    local spritename = isoObject:getTextureName()
--    if spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
--            spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10" then
--        return true
--    end
--    return nil
--end

--function ISAScan.canConnectPanelTo_test(square)
--    local distance = 20
--    local x = square:getX()
--    local y = square:getY()
--    local z = square:getZ()
--    local bottom = math.max(0, z - 3)
--    local top = math.min(8, z + 3)
--    local keylist = {}
--    for iz = bottom, top do
--        for ix = x - distance, x + distance do
--            for iy = y - distance, y + distance do
--                if IsoUtils.DistanceToSquared(ix, iy, x, y) <= 400.0 then
--                    local isquare = getSquare(ix,iy,iz)
--                    if isquare then
--                        if ISAScan.squareHasPowerbank(isquare) then
--                            local key = ISA.findKeyFromSquare(isquare)
--                            if key then table.insert(keylist,key) end
--                        end
--                    end
--                end
--            end
--        end
--     end
--    return keylist
--end
