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

function ISAScan.getValidBackupArea(isoPlayer,level)
    local skillLevel = isoPlayer and isoPlayer:getPerkLevel(Perks.Electricity) or level or 3
    return { radius = skillLevel, levels = skillLevel > 5 and 1 or 0, distance = math.pow(skillLevel, 2) * 1.25 }
end

function ISAScan.findPowerbanks(square,radius,level,distance)
    local banks = {}
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    for ix = x - radius, x + radius do
        for iy = y - radius, y + radius do
            for iz = z - level, z+level do
                local isquare = IsoUtils.DistanceToSquared(x,y,z,ix,iy,iz) <= distance and getSquare(ix, iy, iz)
                local pb
                if isquare then
                    if not isServer() then
                        pb = CPowerbankSystem.instance:getLuaObjectOnSquare(isquare)
                    else
                        pb = SPowerbankSystem.instance:getLuaObjectOnSquare(isquare)
                    end
                end
                if pb then
                    table.insert(banks,pb)
                end
            end
        end
    end
    return banks
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
