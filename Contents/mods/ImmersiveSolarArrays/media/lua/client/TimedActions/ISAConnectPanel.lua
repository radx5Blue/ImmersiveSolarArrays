require "TimedActions/ISBaseTimedAction"
local isa = require "ISAUtilities"

local ISAConnectPanel = ISBaseTimedAction:derive("ISAConnectPanel")

function ISAConnectPanel:isValid()
    self.character:faceThisObject(self.panel)
    return self.panel:getObjectIndex() ~= -1
    --return self.panel:getObjectIndex() ~= -1 and self.panel:getSquare():isOutside()
end

function ISAConnectPanel:start()
    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Low")
    self.character:reportEvent("EventLootItem")
    self.sound = self.character:playSound("GeneratorConnect")

    local x = self.panel:getX()
    local y = self.panel:getY()
    local z = self.panel:getZ()
    local data = self.panel:getModData()
    local prevdelta = data["connectDelta"]
    if not prevdelta then prevdelta = 0 elseif prevdelta > 90 then prevdelta = 90 end
    data["connectDelta"] = prevdelta
    self:setCurrentTime(self.maxTime * prevdelta / 100)
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
    self.character:faceThisObject(self.generator)
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

--ISAConnectPanel.connectTime = 12
function ISAConnectPanel:new(character, panel, powerbank)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.panel = panel
    o.powerbank = powerbank
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.stopOnAim = false
    --o.maxTime = (120 - (character:getPerkLevel(Perks.Electricity) - 3) * 10) * 2 * getGameTime():getMinutesPerDay() / 10 --2 hours at level 3, ~half at level 10 --- temp /10
    --o.maxTime = self.connectTime * (1 - 0.07 * (character:getPerkLevel(Perks.Electricity) - 3)) * 2 * getGameTime():getMinutesPerDay() --connectTime in minutes at level 3, ~half at level 10
    o.maxTime = SandboxVars.ISA.ConnectPanelMin * (1 - 0.095 * (character:getPerkLevel(Perks.Electricity) - 3)) * 2 * getGameTime():getMinutesPerDay() --base time in minutes at level 3, ~1/3 at level 10

    if o.character:isTimedActionInstant() then o.maxTime = 1 end
    return o
end

--if not SandboxVars.ISA.ConnectPanelMin then SandboxVars.ISA.ConnectPanelMin = 120 end

isa.ConnectPanel = ISAConnectPanel