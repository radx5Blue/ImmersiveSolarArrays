if isClient() then return end

require "Distributions/ISAWorldSpawnsMapLocations"

ISAWorldSpawns = {}

local data

local function stringXYZ(iso)
    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
end

function ISAWorldSpawns.Place(square,sprite)
    if square:isFree(true) or (sprite == "solarmod_tileset_01_06" or sprite == "solarmod_tileset_01_07") and square:isFreeOrMidair(true) then
        local isoObject = IsoObject.new(square:getCell(), square, sprite)
        if sprite == "solarmod_tileset_01_36" then
            isoObject:createContainersFromSpriteProperties()
            ISAWorldSpawns.Fill(isoObject)
            isoObject:setOverlaySprite("solarmod_tileset_01_38") --set this because it don't autorefresh
        end
        square:getObjects():add(isoObject)
        square:RecalcProperties()
    end
    --else get another tile
end

function ISAWorldSpawns.Fill(isoObject)
    local container = isoObject:getContainer()
	--generate numbers:
	local panelnumber = ZombRand(4, 5) * SandboxVars.ISA.LRMSolarPanels
	local batterynumber = ZombRand(1, 2) * SandboxVars.ISA.LRMBatteries
	local miscnumber = 1 * SandboxVars.ISA.LRMMisc
    for i=1,panelnumber do
        container:AddItem("ISA.SolarPanel")
        container:AddItem("Radio.ElectricWire")
        container:AddItem("Radio.ElectricWire")
        container:AddItem("Radio.ElectricWire")
        container:AddItem("Base.MetalBar")
        container:AddItem("Base.MetalBar")
    end
    for i=1,batterynumber do
        container:AddItem("ISA.DeepCycleBattery")
    end
    for i=1,miscnumber do
        container:AddItem("ISA.ISAInverter")
        container:AddItem("ISA.ISAMag1")
    end
end

function ISAWorldSpawns.spawnLocations()
    local maps = ISAWorldSpawnsMaps
    local gamemap = getWorld():getMap():split(";")
    local spawnLocations = {}

    for _,map in ipairs(gamemap) do
        local maplocations = maps[map]
        if maplocations then
            for _,location in ipairs(maplocations) do
                table.insert(spawnLocations,location)
            end
        end
    end
    print("ISA Spawns Locations: ",#spawnLocations)
    return spawnLocations
end

function ISAWorldSpawns.Rolls()
    local spawnLocations = ISAWorldSpawns.spawnLocations()
    local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns
    for _,spawn in ipairs(spawnLocations) do
        if ZombRand(1, 100) <= spawnChance then
            data[spawn.x .. "," .. spawn.y .. "," .. spawn.z] = spawn.type
        end
    end
end

local LoadGridsquare = function(square)
    local xyz = stringXYZ(square)
    local spawn = data[xyz]
    if spawn then
        ISAWorldSpawns.Place(square,spawn)
        data[xyz] = nil
    end
end

local OnInitGlobalModData = function(newGame)
    if ModData.exists("ISAWorldSpawns") then
        data = ModData.get("ISAWorldSpawns")
    else
        data = ModData.create("ISAWorldSpawns")
        ISAWorldSpawns.Rolls()
    end
    --if not next(data) == nil then --doesn't seem to work in PZ
    for _,_ in pairs(data) do
        Events.LoadGridsquare.Add(LoadGridsquare)
        break
    end
end
Events.OnInitGlobalModData.Add(OnInitGlobalModData)
