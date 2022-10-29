require "Powerbank/SPowerbankSystem"

local function LoadPowerbank(isoObject)
    if isClient() then
        local gen = isoObject:getSquare():getGenerator()
        if gen then gen:getCell():addToProcessIsoObjectRemove(gen) end
    else
        SPowerbankSystem.instance:loadIsoObject(isoObject)
    end
end

MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadPowerbank, 5)

-- in case map has our objects
if not isClient() then
    local function addSpecialObject(object)
        object:getSquare():addSpecialObject(object)
    end
    for sprite,type in pairs(ISAScan.Types) do
        if type == "Powerbank" or type == "Panel" then
            MapObjects.OnNewWithSprite(sprite, addSpecialObject, 5)
        end
    end
end
