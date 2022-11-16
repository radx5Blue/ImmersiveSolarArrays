require "Powerbank/SPowerbankSystem"

local function LoadPowerbank(isoObject)
    --isoObject:getContainer():setAcceptItemFunction("ISAUtilities.AcceptItemFunction")
    if isClient() then
        local gen = isoObject:getSquare():getGenerator()
        if gen then gen:getCell():addToProcessIsoObjectRemove(gen) end
    else
        SPowerbankSystem.instance:loadIsoObject(isoObject)
    end
end
MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadPowerbank, 5)

-- if a map had our objects, to skip pick up - place
--if not isClient() then
--    local function OnNewWithSprite(object)
--        object:getSquare():getSpecialObjects():add(object)
--    end
--    for sprite,type in pairs(ISAScan.Types) do
--        MapObjects.OnNewWithSprite(sprite, OnNewWithSprite, 5)
--    end
--end
