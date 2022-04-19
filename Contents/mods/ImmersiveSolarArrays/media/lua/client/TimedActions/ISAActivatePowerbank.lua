require "TimedActions/ISBaseTimedAction"

ISAActivatePowerbank = ISBaseTimedAction:derive("ISAConnectPanel");

function ISAActivatePowerbank:new(character, powerbank, activate)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.activate = activate;
    o.isopb = powerbank;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    local level = character:getPerkLevel(Perks.Electricity)
    o.maxTime = 40 - 3 * level
    if o.character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end

function ISAActivatePowerbank:isValid()
    return self.isopb:getObjectIndex() ~= -1
end

function ISAActivatePowerbank:perform()
    local luapb = CPowerbankSystem.instance:getLuaObjectOnSquare(self.isopb:getSquare())
    --luapb:updateFromIsoObject() --getluaobject does that
    if self.activate then
        local level = self.character:getPerkLevel(Perks.Electricity)
        if level < 3 and ZombRand(6-2*level) ~= 0 then
            self.character:playSound("GeneratorFailedToStart")
            self.activate = false
        end
    end
    if self.activate and luapb.charge > 0 then
        self.character:playSound("GeneratorStarting")
    elseif self.activate then
        self.character:playSound("GeneratorFailedToStart")
        ISAStatusWindow.OnOpenPanel(self.isopb:getSquare())
    else
        self.character:playSound("GeneratorStopping")
    end

    --luapb.on = self.activate
    local pb =  { x = luapb.x, y = luapb.y, z = luapb.z }
    CPowerbankSystem.instance:sendCommand(self.character,"activatePowerbank", { pb = pb, activate = self.activate })

    ISBaseTimedAction.perform(self)
end