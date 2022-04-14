if isClient() then return end
require "Powerbank/SPowerbankSystem"

local function LoadBank(isoObject)
    SPowerbankSystem.instance:loadIsoObject(isoObject)
    if isoObject:getSquare():getGenerator() == nil then
        local square = isoObject:getSquare()
        print("Isatest MO creating generator")
        local invgenerator = InventoryItemFactory.CreateItem("Base.Generator")
        local generator = IsoGenerator.new(invgenerator, square:getCell(), square)
        generator:setConnected(true)
        generator:setFuel(100)
        generator:setCondition(100)
        generator:setSprite(nil)
    end

end

MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadBank, 5)