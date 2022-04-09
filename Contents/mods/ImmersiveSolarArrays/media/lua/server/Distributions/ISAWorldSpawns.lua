if isClient() then return end

ISAWorldSpawns = {}

local data
<<<<<<< Updated upstream
=======
local ModLocations = require "Distributions/ISAWorldSpawnsModMaps"
>>>>>>> Stashed changes

local function stringXYZ(iso)
    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
end

function ISAWorldSpawns.Place(square,sprite)
    if square:isFree(true) then
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

ISAWorldSpawns.Locations = {
    { x = 4722, y = 7997, z = 0, type = 'solarmod_tileset_01_07' },
    { x = 4743, y = 7848, z = 0, type = 'solarmod_tileset_01_7' },
    { x = 9656, y = 10156, z = 1, type = 'solarmod_tileset_01_8' },
    { x = 10254, y = 8762, z = 1, type = 'solarmod_tileset_01_8' },
    { x = 9670, y = 8775, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 12482, y = 8879, z = 0, type = 'solarmod_tileset_01_7' },
    { x = 12477, y = 8918, z = 0, type = 'solarmod_tileset_01_6' },
    { x = 12066, y = 7378, z = 1, type = 'solarmod_tileset_01_7' },
    { x = 13631, y = 7220, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 9345, y = 10292, z = 1, type = 'solarmod_tileset_01_8' },
    { x = 9671, y = 8775, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 4253, y = 7228, z = 0, type = 'solarmod_tileset_01_6' },
    { x = 7460, y = 7968, z = 0, type = 'solarmod_tileset_01_6' },
    { x = 11612, y = 9295, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 11588, y = 9292, z = 1, type = 'solarmod_tileset_01_8' },
    { x = 10379, y = 10098, z = 1, type = 'solarmod_tileset_01_9' },
    { x = 10182, y = 6761, z = 1, type = 'solarmod_tileset_01_8' },
    { x = 10745, y = 9843, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 8540, y = 9037, z = 0, type = 'solarmod_tileset_01_6' },
    { x = 8622, y = 8824, z = 1, type = 'solarmod_tileset_01_10' },
    { x = 11619, y = 9961, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11619, y = 9934, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11642, y = 9762, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11644, y = 9754, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11642, y = 9744, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11735, y = 9763, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11735, y = 10045, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11735, y = 10054, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11735, y = 10060, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 11735, y = 10085, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 5332, y = 10558, z = 0, type = 'solarmod_tileset_01_10' },
    { x = 6363, y = 5324, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 11971, y = 6907, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 7251, y = 8226, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 13917, y = 5786, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 13916, y = 5804, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 9185, y = 11828, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 8279, y = 10028, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10698, y = 10450, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5878, y = 9861, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 12621, y = 4712, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5541, y = 12440, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 7248, y = 8313, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 7308, y = 8248, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 7648, y = 9331, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 6548, y = 8930, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5878, y = 9852, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10693, y = 10099, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10623, y = 9890, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10633, y = 9375, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 11618, y = 9935, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10672, y = 9819, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10752, y = 10344, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10613, y = 9311, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10018, y = 10913, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 10716, y = 10419, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 12828, y = 6432, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 14318, y = 4947, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 13843, y = 4748, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 11133, y = 6861, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 11961, y = 6920, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 12148, y = 7099, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 12148, y = 7074, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 11835, y = 6916, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 9204, y = 11823, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 7243, y = 8285, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5541, y = 6068, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5577, y = 5875, z = 0, type = 'solarmod_tileset_01_36' },
<<<<<<< Updated upstream
    { x = 5628, y = 5957, z = 0, type = 'solarmod_tileset_01_36' },
    { x = 5704, y = 5717, z = 0, type = 'solarmod_tileset_01_36' },
}

function ISAWorldSpawns.Rolls()
    if ModData.exists("ISAWorldSpawns")then
        data = ModData.get("ISAWorldSpawns")
    else
        data = ModData.create("ISAWorldSpawns")

        local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns

        for _,spawn in ipairs(ISAWorldSpawns.Locations) do
            if ZombRand(1, 100) <= spawnChance then
                data[spawn.x .. "," .. spawn.y .. "," .. spawn.z] = spawn.type
            end
        end
    end
end

local LoadGridsquare = function(square)
    local spawn = data[stringXYZ(square)]
    if spawn then
        ISAWorldSpawns.Place(square,spawn)
        spawn = nil
    end
end

--ModData.remove("ISAWorldSpawns")
--ISAWorldSpawns = ModData.getOrCreate("ISAWorldSpawns")
Events.OnInitGlobalModData.Add(ISAWorldSpawns.Rolls)
Events.LoadGridsquare.Add(LoadGridsquare)

--if getPlayer() then ISAWorldSpawns.Rolls() end
=======
    { x = 5628, y = 5957, z = 0, type = 'solarmod_tileset_01_36' }, --factory storage
    { x = 5704, y = 5717, z = 0, type = 'solarmod_tileset_01_36' },
}

function ISAWorldSpawns.addModLocations()
    local mods = getActivatedMods()
    for id,locations in pairs(ModLocations) do
        if mods:contains(id) then
            for _,location in ipairs(locations) do
                table.insert(ISAWorldSpawns.Locations,location)
            end
        end
    end
    --print("ISA Spawns Locations: ",#ISAWorldSpawns.Locations)
end

function ISAWorldSpawns.Rolls()
    local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns
    for _,spawn in ipairs(ISAWorldSpawns.Locations) do
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
        if not string.find(getWorld():getMap(),"challengemaps") then
            ISAWorldSpawns.addModLocations()
            ISAWorldSpawns.Rolls()
        end
    end
    --if not next(data) == nil then --doesn't seem to work in PZ
    for _,_ in pairs(data) do
        Events.LoadGridsquare.Add(LoadGridsquare)
        break
    end
end
Events.OnInitGlobalModData.Add(OnInitGlobalModData)

--if getPlayer() then ModData.remove("ISAWorldSpawns"); OnInitGlobalModData() end
>>>>>>> Stashed changes
