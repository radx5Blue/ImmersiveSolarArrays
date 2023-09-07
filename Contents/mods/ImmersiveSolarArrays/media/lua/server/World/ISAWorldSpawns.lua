if isClient() then return end

local isa = require "ISAUtilities"
local TargetSquare_OnLoad = require "!_TargetSquare_OnLoad"
local sandbox = SandboxVars.ISA

local ISAWorldSpawns = {}
ISAWorldSpawns.spawnBatteryBankRooms = { shed = 12, garagestorage = 12, storageunit = 12, electronicsstorage = 3, farmstorage = 8 }
ISAWorldSpawns.spawnBatteryBankChance = { 9999, 10, 3, 1 }

function ISAWorldSpawns.addToWorld(square, sprite, index)
    --if square:isFree(true) or (sprite == "solarmod_tileset_01_6" or sprite == "solarmod_tileset_01_7") and square:isFreeOrMidair(true) then
    local isoObject
    if isa.WorldUtil.Types[sprite] == "Powerbank" then
        isoObject = IsoThumpable.new(square:getCell(), square, sprite, false, {})
        isoObject:setThumpDmg(8)
    else
        isoObject = IsoObject.new(square:getCell(), square, sprite)
    end
    isoObject:createContainersFromSpriteProperties()
    ISAWorldSpawns.fill(isoObject,sprite)

    square:AddSpecialObject(isoObject,index or -1)
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
        local panelnumber = ZombRand(3, 5) * sandbox.LRMSolarPanels
        local batterynumber = ZombRand(1, 2) * sandbox.LRMBatteries
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

function ISAWorldSpawns.doRolls(ws)
    local spawnChance = sandbox.solarPanelWorldSpawns
    if spawnChance == 0 then return end
    local ZombRand, ipairs = ZombRand, ipairs
    local Maps = require("World/ISAWorldSpawnsMapLocations")

    local loaded = {}
    for _,map in ipairs(getWorld():getMap():split(";")) do
        local mapLocations = Maps[map]
        if mapLocations ~= nil then
            for _,location in ipairs(mapLocations) do
                local valid = true
                for _,over in ipairs(location.overwrite) do
                    if loaded[over] then valid = false break end
                end
                if valid and ZombRand(100) < spawnChance then
                    ws.addCommand(location.x,location.y,location.z,{ command = "isaWorldSpawn", sprite = location.type})
                end
            end
        end
        loaded[map] = true
    end
end

function ISAWorldSpawns.OnSeeNewRoom(room)
    local roomChance = ISAWorldSpawns.spawnBatteryBankRooms[room:getName()]
    if roomChance and ZombRand(roomChance * ISAWorldSpawns.spawnBatteryBankChance[sandbox.BatteryBankSpawn]) == 0 then
        local square = room:getRandomFreeSquare()
        if square then
            ISAWorldSpawns.addToWorld(square,"solarmod_tileset_01_0")
        end
    end
end

function ISAWorldSpawns.InitSpawns()
    if sandbox.BatteryBankSpawn > 1 then
        Events.OnSeeNewRoom.Add(ISAWorldSpawns.OnSeeNewRoom)
    end

    local instance = TargetSquare_OnLoad and TargetSquare_OnLoad.instance
    if not instance then return end

    instance.OnLoadCommands.isaWorldSpawn = function(square,command)
        ISAWorldSpawns.addToWorld(square,command.sprite)
    end

    if instance.savedData["isaWorldSpawns"] then return end

    local oldData = ModData.remove("ISAWorldSpawns")
    if oldData then
        for k,v in pairs(oldData) do
            local split = k:split(",")
            instance.addCommand(tonumber(split[1]), tonumber(split[2]), tonumber(split[3]),{ command = "isaWorldSpawn", sprite = v })
        end
    else
        ISAWorldSpawns.doRolls(instance)
    end

    instance.savedData["isaWorldSpawns"] = true
end

Events.OnSGlobalObjectSystemInit.Add(ISAWorldSpawns.InitSpawns)

return ISAWorldSpawns