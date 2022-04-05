if isClient() then return end
require "Powerbank/SPowerbankSystem"

local function LoadPowerbank(isoObject)
    SPowerbankSystem.instance:loadIsoObject(isoObject)
end

MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadPowerbank, 5)