ISAScan = {}

ISAScan.Types = {
    solarmod_tileset_01_0 = "Powerbank",
    solarmod_tileset_01_6 = "Panel",
    solarmod_tileset_01_7 = "Panel",
    solarmod_tileset_01_8 = "Panel",
    solarmod_tileset_01_9 = "Panel",
    solarmod_tileset_01_10 = "Panel",
    solarmod_tileset_01_15 = "Failsafe",
}

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

function ISAScan.findOnSquare(square,sprite)
    local special = square:getSpecialObjects()
    for i = 1, special:size() do
        if special:get(i-1):getTextureName() == sprite then
            return special:get(i-1)
        end
    end
end

function ISAScan.findTypeOnSquare(square,type)
    local special = square:getSpecialObjects()
    for i = 1, special:size() do
        if ISAScan.Types[special:get(i-1):getTextureName()] == type then
            return special:get(i-1)
        end
    end
end
