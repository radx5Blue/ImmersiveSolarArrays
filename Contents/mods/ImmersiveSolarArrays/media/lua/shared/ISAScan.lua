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
