require "Powerbank/SPowerbankSystem"

local function LoadPowerbank(isoObject)
    if isClient() then
        local gen = isoObject:getSquare():getGenerator()
        if gen then gen:getCell():addToProcessIsoObjectRemove(gen) end
    else
    --if isServer() then
        SPowerbankSystem.instance:loadIsoObject(isoObject)
    end
end

MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadPowerbank, 5)