ISAScan = {}

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

--function ISAScan.squareHasPowerbank(square)
--    local special = square:getSpecialObjects()
--    for i = 1, special:size() do
--        local obj = special:get(i-1)
--        if obj then
--            local spritename = obj:getSprite() and obj:getSprite():getName()
--            if spritename and spritename == "solarmod_tileset_01_0" then
--                return obj
--            end
--        end
--    end return false
--end

--function ISAScan.scanFull(square,powerbanks,panels)
--    local distance = 20
--    local x = square:getX()
--    local y = square:getY()
--    local z = square:getZ()
--    local bottom = math.max(0, z - 3)
--    local top = math.min(8, z + 3)
--    local list = { powerbanks = {}, panels = {} }
--    for iz = bottom, top do
--        for ix = x - distance, x + distance do
--            for iy = y - distance, y + distance do
--                if IsoUtils.DistanceToSquared(ix, iy, x, y) <= 400.0 then
--                    local isquare = getSquare(ix,iy,iz)
--                    if isquare then
--                        local pb = ISAScan.squareHasPowerbank(isquare)
--                        if pb then table.insert(pblist,pb) end
--                    end
--                end
--            end
--        end
--    end
--    return pblist
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

--function ISAScan.getPanels(square)
--    local distance = 20
--    local x = square:getX()
--    local y = square:getY()
--    local z = square:getZ()
--    local bottom = math.max(0, z - 3)
--    local top = math.min(8, z + 3)
--    local panels = {}
--    for iz = bottom, top do
--        for ix = x - distance, x + distance do
--            for iy = y - distance, y + distance do
--                if IsoUtils.DistanceToSquared(ix, iy, x, y) <= 400.0 then
--                    local isquare = getSquare(ix,iy,iz)
--                    if isquare then
--                        local panel = ISAScan.squareHasPanel(isquare)
--                        if panel then table.insert(panels,panel) end
--                    end
--                end
--            end
--        end
--     end
--    return panels
--end

--function ISAScan.connectPanel(bsquare,psquare,initial,key)
--	local x = psquare:getX()
--	local y = psquare:getY()
--	local z = psquare:getZ()
--	local distance = IsoUtils.DistanceToSquared(x,y,z,bsquare:getX(),bsquare:getY(),bsquare:getZ())
--	local add = true
--	for i,panel in ipairs(ISAScan.Panels) do
--		if panel.x == x and panel.y == y and panel.z == z then
--			add = distance < IsoUtils.DistanceToSquared(x,y,z,isaData.x[panel.key], isaData.y[panel.key], isaData.z[panel.key])
--			if add then add = false;panel.key = key end
--			break
--		end
--	end
--	if add then table.insert(ISAScan.Panels,{x=x,y=y,z=z,key=key}) end
--end
