if isClient() then return end

local ISAWorldSpawns

local function stringXYZ(iso)
    return iso:getX() .. "," .. iso:getY() .. "," .. iso:getZ()
end

function ISAWorldSpawnsPlace(square,sprite)
    if square:isFree(true) then
        local isoObject = IsoObject.new(square:getCell(), square, sprite)
        if sprite == "solarmod_tileset_01_36" then
            isoObject:createContainersFromSpriteProperties()
            ISAWorldSpawnsFill(isoObject)
            isoObject:setOverlaySprite("solarmod_tileset_01_38") --set this because it don't autorefresh
        end
        square:getObjects():add(isoObject)
        square:RecalcProperties()
    end
end

function ISAWorldSpawnsFill(isoObject)
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

function ISA_WorldSpawnRolls()

    if ModData.exists("ISAWorldSpawns")then
        ISAWorldSpawns = ModData.get("ISAWorldSpawns")
    else
        ISAWorldSpawns = ModData.create("ISAWorldSpawns")

        local chance = 0
        local spawnChance = SandboxVars.ISA.solarPanelWorldSpawns

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            ISAWorldSpawns[4722 .. "," .. 7997 .. "," .. 0] = "solarmod_tileset_01_07"
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            ISAWorldSpawns[4743 .. "," .. 7848 .. "," .. 0] = "solarmod_tileset_01_07"
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            ISAWorldSpawns[9656 .. "," .. 10156 .. "," .. 1] = "solarmod_tileset_01_08"
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10254) --working
            table.insert(spawnCellY, CellKeysNumber, 8762)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9670) --working
            table.insert(spawnCellY, CellKeysNumber, 8775)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12482)
            table.insert(spawnCellY, CellKeysNumber, 8879) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12477) --working
            table.insert(spawnCellY, CellKeysNumber, 8918)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12066) --checked and works
            table.insert(spawnCellY, CellKeysNumber, 7378)
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_7")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13631)
            table.insert(spawnCellY, CellKeysNumber, 7220) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9345)
            table.insert(spawnCellY, CellKeysNumber, 10292) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9671)
            table.insert(spawnCellY, CellKeysNumber, 8775) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 4253)
            table.insert(spawnCellY, CellKeysNumber, 7228) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7460)
            table.insert(spawnCellY, CellKeysNumber, 7968) --working
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11612)
            table.insert(spawnCellY, CellKeysNumber, 9295)
            table.insert(spawnCellZ, CellKeysNumber, 1) --working
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11588)
            table.insert(spawnCellY, CellKeysNumber, 9292)
            table.insert(spawnCellZ, CellKeysNumber, 1) --working
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10379)
            table.insert(spawnCellY, CellKeysNumber, 10098) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_9")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10182)
            table.insert(spawnCellY, CellKeysNumber, 6761) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_8")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10745)
            table.insert(spawnCellY, CellKeysNumber, 9843) --working
            table.insert(spawnCellZ, CellKeysNumber, 1)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8540)
            table.insert(spawnCellY, CellKeysNumber, 9037) --works as intended
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_6")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8622)
            table.insert(spawnCellY, CellKeysNumber, 8824)
            table.insert(spawnCellZ, CellKeysNumber, 1) -- User Suggested Spawn - Works
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11619)
            table.insert(spawnCellY, CellKeysNumber, 9961)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11619)
            table.insert(spawnCellY, CellKeysNumber, 9934)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11642)
            table.insert(spawnCellY, CellKeysNumber, 9762)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11644)
            table.insert(spawnCellY, CellKeysNumber, 9754)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11642)
            table.insert(spawnCellY, CellKeysNumber, 9744)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 9763)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10045)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10054)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10060)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11735)
            table.insert(spawnCellY, CellKeysNumber, 10085)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- Train / Railyard
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5332)
            table.insert(spawnCellY, CellKeysNumber, 10558)
            table.insert(spawnCellZ, CellKeysNumber, 0) -- User Suggested Farmhouse
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_10")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --adding boxes here

        --riverside hardware:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 6363)
            table.insert(spawnCellY, CellKeysNumber, 5324)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --west point hardware:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11971)
            table.insert(spawnCellY, CellKeysNumber, 6907)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --dixie hardware:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7251)
            table.insert(spawnCellY, CellKeysNumber, 8226)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --The mall electronics:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13917)
            table.insert(spawnCellY, CellKeysNumber, 5786)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --The mall hardware:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13916)
            table.insert(spawnCellY, CellKeysNumber, 5804)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --Army quarter warehouse:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9185)
            table.insert(spawnCellY, CellKeysNumber, 11828)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse near rosewood:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 8279)
            table.insert(spawnCellY, CellKeysNumber, 10028)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse in muldraugh:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10698)
            table.insert(spawnCellY, CellKeysNumber, 10450) --may need to fix
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse in the countryside:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5878)
            table.insert(spawnCellY, CellKeysNumber, 9861)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse near valley station:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12621)
            table.insert(spawnCellY, CellKeysNumber, 4712)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --Secret military base:
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5541)
            table.insert(spawnCellY, CellKeysNumber, 12440)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        ------------------------------------- NEW ONES -----------------------------------------
        --- Dixie
        ---farming store
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7248)
            table.insert(spawnCellY, CellKeysNumber, 8313)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        -- general store
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7308)
            table.insert(spawnCellY, CellKeysNumber, 8248)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7648)
            table.insert(spawnCellY, CellKeysNumber, 9331)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 6548)
            table.insert(spawnCellY, CellKeysNumber, 8930)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5878)
            table.insert(spawnCellY, CellKeysNumber, 9852)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --muldraugh
        -- warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10693) --need to check
            table.insert(spawnCellY, CellKeysNumber, 10099)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --elect store
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10623) --no work
            table.insert(spawnCellY, CellKeysNumber, 9890)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --garage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10633)
            table.insert(spawnCellY, CellKeysNumber, 9375)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --railyard
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11618)
            table.insert(spawnCellY, CellKeysNumber, 9935)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --self storage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10672)
            table.insert(spawnCellY, CellKeysNumber, 9819)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --storage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10752)
            table.insert(spawnCellY, CellKeysNumber, 10344)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10613)
            table.insert(spawnCellY, CellKeysNumber, 9311)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10018)
            table.insert(spawnCellY, CellKeysNumber, 10913)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 10716)
            table.insert(spawnCellY, CellKeysNumber, 10419)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --Valley Station
        --
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12828)
            table.insert(spawnCellY, CellKeysNumber, 6432)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --farm
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 14318)
            table.insert(spawnCellY, CellKeysNumber, 4947)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --farm
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 13843)
            table.insert(spawnCellY, CellKeysNumber, 4748)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --West Point
        -- farm
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11133)
            table.insert(spawnCellY, CellKeysNumber, 6861)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --hardwarestore
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11961)
            table.insert(spawnCellY, CellKeysNumber, 6920)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12148)
            table.insert(spawnCellY, CellKeysNumber, 7099)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --storage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 12148)
            table.insert(spawnCellY, CellKeysNumber, 7074)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --hardware store
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 11835)
            table.insert(spawnCellY, CellKeysNumber, 6916)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        -- warehouse
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 9204)
            table.insert(spawnCellY, CellKeysNumber, 11823)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        -- Riverside
        -- farm
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 7243)
            table.insert(spawnCellY, CellKeysNumber, 8285)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --self storage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5541)
            table.insert(spawnCellY, CellKeysNumber, 6068)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        -- factory
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5577)
            table.insert(spawnCellY, CellKeysNumber, 5875)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end


        --factory storage
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5628)
            table.insert(spawnCellY, CellKeysNumber, 5957)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

        --farm
        chance = ZombRand(1, 100)
        if chance <= spawnChance then
            CellKeysNumber = CellKeysNumber + 1
            table.insert(spawnCellKeys, CellKeysNumber, CellKeysNumber)
            table.insert(spawnCellX, CellKeysNumber, 5704)
            table.insert(spawnCellY, CellKeysNumber, 5717)
            table.insert(spawnCellZ, CellKeysNumber, 0)
            table.insert(spawnCellType, CellKeysNumber, "solarmod_tileset_01_36")
            table.insert(spawnCellSpawned, CellKeysNumber, 0)
        end

    end
end

local LoadGridsquare = function(square)
    local spawn = ISAWorldSpawns[stringXYZ(square)]
    if spawn then
        ISAWorldSpawnsPlace(square,spawn)
        spawn = nil
    end
end

--ModData.remove("ISAWorldSpawns")
ISAWorldSpawns = ModData.getOrCreate("ISAWorldSpawns")
--Events.OnInitGlobalModData.Add(ISA_WorldSpawnRolls)
Events.LoadGridsquare.Add(LoadGridsquare)
