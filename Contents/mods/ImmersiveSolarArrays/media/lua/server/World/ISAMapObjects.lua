local isa = require "ISAUtilities"
local WorldSpawns = require "World/ISAWorldSpawns"

local isClient = isClient()

local function LoadPowerbank(isoObject)
    isoObject:getContainer():setAcceptItemFunction("AcceptItemFunction.ISA_Batteries")
    if isClient then
        local gen = isoObject:getSquare():getGenerator()
        if gen then gen:getCell():addToProcessIsoObjectRemove(gen) end
    else
        isa.PbSystem_server:loadIsoObject(isoObject)
    end
end
MapObjects.OnLoadWithSprite("solarmod_tileset_01_0", LoadPowerbank, 5)

if not isClient then
    --- if a map had our objects
    local function OnNewWithSprite(isoObject)
        local spriteName = isoObject:getTextureName()
        local type = isa.WorldUtil.Types[spriteName]
        local square = isoObject:getSquare()

        if not square or not type then return error("ISA OnNewWithSprite "..spriteName) end

        if type == "Powerbank" then
            local index = isoObject:getObjectIndex()
            square:transmitRemoveItemFromSquare(isoObject)
            WorldSpawns.addToWorld(square,spriteName,index)
        else
            square:getSpecialObjects():add(isoObject)
        end
    end

    local MapObjects = MapObjects
    for sprite,type in pairs(isa.WorldUtil.Types) do
        MapObjects.OnNewWithSprite(sprite, OnNewWithSprite, 5)
    end
end
