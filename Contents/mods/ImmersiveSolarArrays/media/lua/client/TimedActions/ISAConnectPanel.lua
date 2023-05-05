require "TimedActions/ISBaseTimedAction"
local isa = require "ISAUtilities"

local ISAConnectPanel = ISBaseTimedAction:derive("ISAConnectPanel")

function ISAConnectPanel:isValid()
    return self.panel:getObjectIndex() ~= -1
end

function ISAConnectPanel:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    self.character:reportEvent("EventLootItem")
    self.sound = self.character:playSound("GeneratorConnect")

    local data = self.panel:getModData()
    local prevDelta = data["connectDelta"]
    if not prevDelta then prevDelta = 0 elseif prevDelta > 90 then prevDelta = 90 end
    data["connectDelta"] = prevDelta
    self:setCurrentTime(self.maxTime * prevDelta / 100)
    if data["pbLinked"] then
        local pb = isa.PbSystem_client:getIsoObjectAt(data["pbLinked"].x,data["pbLinked"].y,data["pbLinked"].z) and data["pbLinked"]
        if pb then
            isa.PbSystem_client:sendCommand(self.character,"disconnectPanel", { panel= { x = self.panel:getX(), y = self.panel:getY(), z = self.panel:getZ() }, pb = { x = pb.x, y = pb.y, z = pb.z } })
        end
        data["pbLinked"] = nil
    end
    self.panel:transmitModData()
end

function ISAConnectPanel:waitToStart()
    self.character:faceThisObject(self.panel)
    return self.character:shouldBeTurning()
end

function ISAConnectPanel:update()
    self.character:faceThisObject(self.panel)
end

function ISAConnectPanel:stop()
    self.character:stopOrTriggerSound(self.sound)
    local delta = math.floor(self:getJobDelta()*100)
    local data = self.panel:getModData()
    if delta > data.connectDelta and self.panel:getObjectIndex() ~= -1 then
        data.connectDelta = delta
        self.panel:transmitModData()
    end

    ISBaseTimedAction.stop(self);
end

function ISAConnectPanel:perform()
    self.character:stopOrTriggerSound(self.sound)

    local data = self.panel:getModData()
    data.connectDelta = 100
    if self.powerbank:getIsoObject() then
        local pb = { x = self.powerbank.x , y = self.powerbank.y, z = self.powerbank.z }
        local panel = { x = self.panel:getX(), y = self.panel:getY(), z = self.panel:getZ() }
        isa.PbSystem_client:sendCommand(self.character,"connectPanel", { panel = panel, pb = pb })
        data.pbLinked = pb
    end
    self.panel:transmitModData()

    ISBaseTimedAction.perform(self);
end

function ISAConnectPanel:new(character, panel, luaPb)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.panel = panel
    o.powerbank = luaPb
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = false
    o.maxTime = SandboxVars.ISA.ConnectPanelMin * (1 - 0.095 * (character:getPerkLevel(Perks.Electricity) - 3)) * 2 * getGameTime():getMinutesPerDay() --base time in minutes at level 3, ~1/3 at level 10

    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

isa.ConnectPanel = ISAConnectPanel