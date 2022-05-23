if isClient() then return end

require "Distributions/ISAWorldSpawnsMapLocations"

ISAWorldSpawns = {}
local data

local function stringXYZ(iso)
    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
end

function ISAWorldSpawns.Place(square,sprite)
    --if square:isFree(true) or (sprite == "solarmod_tileset_01_06" or sprite == "solarmod_tileset_01_07") and square:isFreeOrMidair(true) then
        local isoObject = IsoObject.new(square:getCell(), square, sprite)
        if sprite == "solarmod_tileset_01_36" then
            isoObject:createContainersFromSpriteProperties()
            ISAWorldSpawns.Fill(isoObject)
        end
        square:getObjects():add(isoObject)
        square:RecalcProperties()
    --else get another tile
    --end
end

function ISAWorldSpawns.Fill(isoObject)
    local container = isoObject:getContainer()
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
    container:setExplored(true)
    isoObject:setOverlaySprite("solarmod_tileset_01_38") --set this because it don't autorefresh
end

function ISAWorldSpawns.doRolls()
    local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns
    if spawnChance == 0 then return end

    local maps = {}
    for _,map in ipairs(getWorld():getMap():split(";")) do
        local loc = ISAWorldSpawnsMaps[map]
        maps[map] = loc and loc or {}
    end

    for map,locations in pairs(maps) do
        for _,location in ipairs(locations) do
            local valid = true
            for _,over in ipairs(location.overwrite) do
                if maps[over] then valid = false end
            end
            if valid and ZombRand(1, 100) <= spawnChance then
                data[location.x .. "," .. location.y .. "," .. location.z] = location.type
            end
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

ISAWorldSpawns.OnInitGlobalModData = function(newGame)
    if ModData.exists("ISAWorldSpawns") then
        data = ModData.get("ISAWorldSpawns")
    else
        data = ModData.create("ISAWorldSpawns")
        ISAWorldSpawns.doRolls()
    end
    --if not next(data) == nil then --doesn't seem to work in PZ
    for _,_ in pairs(data) do
        Events.LoadGridsquare.Add(LoadGridsquare)
        break
    end
end
Events.OnInitGlobalModData.Add(ISAWorldSpawns.OnInitGlobalModData)
