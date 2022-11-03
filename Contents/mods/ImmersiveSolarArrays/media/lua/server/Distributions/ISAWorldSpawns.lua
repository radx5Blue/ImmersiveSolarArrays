if isClient() then return end

--require "Distributions/ISAWorldSpawnsMapLocations"

ISAWorldSpawns = {}
local data

local function stringXYZ(iso)
    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
end

function ISAWorldSpawns.addToWorld(square, sprite)
    --if square:isFree(true) or (sprite == "solarmod_tileset_01_6" or sprite == "solarmod_tileset_01_7") and square:isFreeOrMidair(true) then
    local isoObject
    if ISAScan.Types[sprite] == "Powerbank" then
        isoObject = IsoThumpable.new(square:getCell(), square, sprite, false, {})
        isoObject:setThumpDmg(8)
    else
        isoObject = IsoObject.new(square:getCell(), square, sprite)
    end
    ISAWorldSpawns.addContainer(isoObject,sprite)

    --square:getObjects():add(isoObject)
    --square:getSpecialObjects():add(isoObject)
    --square:RecalcProperties()
    square:AddSpecialObject(isoObject)

    if isServer() then
        isoObject:transmitCompleteItemToClients()
    end
    triggerEvent("OnObjectAdded", isoObject)
    --else get another tile
    --end
end

function ISAWorldSpawns.addContainer(isoObject,sprite)
    local fillType, updateOverlay
    if sprite == "solarmod_tileset_01_36" then fillType = "SolarBox"; updateOverlay = true
    elseif sprite == "solarmod_tileset_01_0" then fillType = "BatteryBank"
    else return
    end
    isoObject:createContainersFromSpriteProperties()
    local container = isoObject:getContainer()
    if fillType == "proc" then
        ItemPicker.fillContainer(container,getPlayer())
    elseif fillType == "BatteryBank" then
        for i = 1, SandboxVars.ISA.LRMBatteries>=2 or 1 do --fixme sanboxvars
            ItemPicker.fillContainer(container,getPlayer())
        end
    elseif fillType == "SolarBox" then
        local panelnumber = ZombRand(3, 5) * SandboxVars.ISA.LRMSolarPanels
        local batterynumber = ZombRand(1, 2) * SandboxVars.ISA.LRMBatteries
        panelnumber = panelnumber < 8 and panelnumber or 7
        batterynumber = batterynumber < 4 and batterynumber or 3
        container:AddItems("ISA.SolarPanel",panelnumber)
        container:AddItems("Radio.ElectricWire",panelnumber*3)
        container:AddItems("Base.MetalBar",panelnumber*2)
        container:AddItems("ISA.DeepCycleBattery",batterynumber)
        container:AddItem("ISA.ISAInverter")
        container:AddItem("ISA.ISAMag1")
    --elseif fillType == "batteries" then
    --    local batteryNumber1 = ZombRand(2*SandboxVars.ISA.LRMBatteries)
    --    local batteryNumber2 = ZombRand(2*SandboxVars.ISA.LRMBatteries)
    --    --local batteryNumber3 = ZombRand(SandboxVars.ISA.LRMBatteries)
    --    local maxBatteries = 100
    --    batteryNumber1 = batteryNumber1 <= maxBatteries and batteryNumber1 or maxBatteries
    --    container:AddItems("ISA.DeepCycleBattery",batteryNumber1)
    --    maxBatteries = maxBatteries - batteryNumber1
    --    batteryNumber2 = batteryNumber2 <= maxBatteries and batteryNumber2 or maxBatteries
    --    container:AddItems("ISA.DIYBattery",batteryNumber2)
    end
    if updateOverlay then
        isoObject:setOverlaySprite("solarmod_tileset_01_38")
        --getContainerOverlays():updateContainerOverlaySprite(isoObject)
    end
    container:setExplored(true)
end

function ISAWorldSpawns.doRolls()
    local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns
    if spawnChance == 0 then return end

    local mapLocations = ISAWorldSpawns.defs.mapLocations
    local loaded = {}
    for _,map in ipairs(getWorld():getMap():split(";")) do
        if mapLocations[map] then
            for _,location in ipairs(mapLocations[map]) do
                local valid = true
                for _,over in ipairs(location.overwrite) do
                    if loaded[over] then valid = false end
                end
                if valid and ZombRand(1, 100) <= spawnChance then
                    data[location.x .. "," .. location.y .. "," .. location.z] = location.type
                end
            end
        end
        loaded[map] = true
    end
end

local spawnBatteryBankRooms = { shed = 10, garagestorage = 10, storageunit = 10, electronicsstorage = 3 }
local spawnBatteryBankChance = { 0, 10, 3, 1 }
function ISAWorldSpawns.OnSeeNewRoom(room)
    local name = room:getName()
    local chance = spawnBatteryBankRooms[name]
    if chance and ZombRand(chance * SandboxVars.ISA.BatteryBankSpawn) == 0 then
        local square = room:getRandomFreeSquare()
        if square then
            ISAWorldSpawns.addToWorld(square,"solarmod_tileset_01_0")
        end
    end
end

local LoadGridsquare = function(square)
    local xyz = stringXYZ(square)
    local spawn = data[xyz]
    if spawn then
        ISAWorldSpawns.addToWorld(square,spawn)
        data[xyz] = nil
    end
end

ISAWorldSpawns.OnInitGlobalModData = function(newGame)
    if ModData.exists("ISAWorldSpawns") then
        data = ModData.get("ISAWorldSpawns")
    else
        data = ModData.create("ISAWorldSpawns")
        ISAWorldSpawns.doRolls()
    end

    for _,_ in pairs(data) do
        Events.LoadGridsquare.Add(LoadGridsquare)
        break
    end
    if SandboxVars.ISA.BatteryBankSpawn > 1 then
        Events.OnSeeNewRoom.Add(ISAWorldSpawns.OnSeeNewRoom)
    end
end
Events.OnInitGlobalModData.Add(ISAWorldSpawns.OnInitGlobalModData)

ISAWorldSpawns.defs = { spawnBatteryBankRooms = spawnBatteryBankRooms, spawnBatteryBankChance = spawnBatteryBankChance }

--debug
if not SandboxVars.ISA.BatteryBankSpawn then print("ISA Warning: Missing BatteryBankSpawn"); SandboxVars.ISA.BatteryBankSpawn = 1 end

--if getPlayer() or isServer() and true then ISAWorldSpawns.OnInitGlobalModData() end
--ISAWorldSpawns.OnInitGlobalModData()
spawnBatteryBankRooms.garage = 0
