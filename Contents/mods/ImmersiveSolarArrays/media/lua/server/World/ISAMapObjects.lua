local isa = require "ISAUtilities"
local WorldSpawns = require "World/ISAWorldSpawns"

local isClient = isClient()

local function LoadPowerbank(isoObject)
    print("ISAtest LoadPowerbank")
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
    local function OnObjectAboutToBeRemoved(isoObject)
        if isa.WorldUtil.objIsType(isoObject,"Panel") then
            isa.PbSystem_server:removePanel(isoObject)
        end
    end
    Events.OnObjectAboutToBeRemoved.Add(OnObjectAboutToBeRemoved)

    --- if a map had our objects
    local function OnNewWithSprite(isoObject)
        local spriteName = isoObject:getTextureName()
        local type = isa.WorldUtil.Types[spriteName]
        local square = isoObject:getSquare()

        if not square or not type then return error("ISA OnNewWithSprite "..spriteName) end

        if type == "Powerbank" then
            local index = isoObject:getObjectIndex()
            square:transmitRemoveItemFromSquare(isoObject)

            --local newObj = IsoThumpable.new(square:getCell(), square, spriteName, false, {})
            --newObj:setThumpDmg(8)
            --newObj:createContainersFromSpriteProperties()
            --WorldSpawns.fill(newObj,spriteName)
            --square:AddSpecialObject(newObj,index)
            --newObj:transmitCompleteItemToClients()

            --triggerEvent("OnObjectAdded", newObj)
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

--- Debug
local prev_AcceptItemFunction
local function debugAcceptItemFunction(index)
    index = index or 1
    if not isa.PbSystem_client or isa.PbSystem_client:getLuaObjectCount() < index then return end
    local pb = isa.PbSystem_client:getLuaObjectByIndex(index)
    local isoObject = pb and pb:getIsoObject()
    if isoObject then
        local AcceptItemFunction = isoObject:getContainer():getAcceptItemFunction()
        if AcceptItemFunction ~= prev_AcceptItemFunction then
            local player = getPlayer()
            if player then player:Say("ISAtest accepts: "..tostring(AcceptItemFunction)) end
            print("ISAtest AcceptItemFunction changed: ",AcceptItemFunction)
            prev_AcceptItemFunction = AcceptItemFunction
        end
    end
end
Events.EveryTenMinutes.Add(debugAcceptItemFunction)

local function OnSave()
    debugAcceptItemFunction()
    print("ISAtest OnSave AcceptItemFunction",math.floor(getGameTime():getWorldAgeHours()),prev_AcceptItemFunction)
    isa.queueFunction("OnTick",function()
        debugAcceptItemFunction()
        print("ISAtest OnTick after Save AcceptItemFunction",prev_AcceptItemFunction)
    end)
end
Events.OnSave.Add(OnSave)
--local function OnPostSave()
--    debugAcceptItemFunction()
--    print("ISAtest OnPostSave AcceptItemFunction",prev_AcceptItemFunction)
--end
--Events.OnPostSave.Add(OnPostSave)
