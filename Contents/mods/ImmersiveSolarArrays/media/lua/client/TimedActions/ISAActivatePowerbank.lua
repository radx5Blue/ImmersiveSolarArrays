require "TimedActions/ISBaseTimedAction"
local isa = require "ISAUtilities"

local ActivatePowerbank = ISBaseTimedAction:derive("ISAActivatePowerbank")

function ActivatePowerbank:new(character, powerbank, activate)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.activate = activate;
    o.isoPb = powerbank;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    local level = character:getPerkLevel(Perks.Electricity)
    o.maxTime = 40 - 3 * level
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end

function ActivatePowerbank:isValid()
    return self.isoPb:getObjectIndex() ~= -1
end

function ActivatePowerbank:perform()
    local luapb = isa.PbSystem_client:getLuaObjectOnSquare(self.isoPb:getSquare())
    if self.activate then
        local level = self.character:getPerkLevel(Perks.Electricity)
        if level < 3 and ZombRand(6-2*level) ~= 0 then
            self.isoPb:getSquare():playSound("GeneratorFailedToStart")
            self.activate = false
        end
    end
    if self.activate and luapb.charge > 0 then
        self.isoPb:getSquare():playSound("GeneratorStarting")
    elseif self.activate then
        self.isoPb:getSquare():playSound("GeneratorFailedToStart")
    else
        self.isoPb:getSquare():playSound("GeneratorStopping")
    end

    local pb =  { x = luapb.x, y = luapb.y, z = luapb.z }
    isa.PbSystem_client:sendCommand(self.character,"activatePowerbank", { pb = pb, activate = self.activate })

    ISBaseTimedAction.perform(self)
end

isa.ActivatePowerbank = ActivatePowerbank