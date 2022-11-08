if isClient() then return end

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
    isoObject:createContainersFromSpriteProperties()
    ISAWorldSpawns.fill(isoObject,sprite)

    square:AddSpecialObject(isoObject)
    if isServer() then
        isoObject:transmitCompleteItemToClients()
    end
    triggerEvent("OnObjectAdded", isoObject)
    --else get another tile
    --end
end

function ISAWorldSpawns.fill(isoObject,sprite)
    local container = isoObject:getContainer()
    if not container then return end
    local fillType, overlayType
    if sprite == "solarmod_tileset_01_36" then fillType = "SolarBox"; overlayType = "solarmod_tileset_01_38"
    --elseif sprite == "solarmod_tileset_01_0" then overlayType = false
    end
    if fillType == "SolarBox" then
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
    else
        ItemPicker.fillContainer(container,getPlayer())
    end
    if overlayType then
        isoObject:setOverlaySprite(overlayType)
    --elseif overlayType == nil then
    --    getContainerOverlays():updateContainerOverlaySprite(isoObject)
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

local spawnBatteryBankRooms = { shed = 12, garagestorage = 12, storageunit = 12, electronicsstorage = 3, farmstorage = 8 }
local spawnBatteryBankChance = { 9999, 10, 3, 1 }
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
