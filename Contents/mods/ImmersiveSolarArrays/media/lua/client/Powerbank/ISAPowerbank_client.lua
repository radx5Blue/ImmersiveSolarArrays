require "Map/CGlobalObject"

local CPowerbank = CGlobalObject:derive("CPowerbank")

function CPowerbank:new(luaSystem, globalObject)
    return CGlobalObject.new(self, luaSystem, globalObject)
end

function CPowerbank:fromModData(modData)
    self.on = modData["on"]
    self.batteries = modData["batteries"]
    self.charge = modData["charge"]
    self.maxcapacity = modData["maxcapacity"]
    self.drain = modData["drain"]
    self.npanels = modData["npanels"]
    self.panels = modData["panels"]
    --self.lastHour = modData["lastHour"]
    self.conGenerator = modData["conGenerator"]
end

function CPowerbank:shouldDrain()
    local square = self:getSquare()
    if not self.on then return false end
    if self.conGenerator and self.conGenerator.ison then return false end
    if getWorld():isHydroPowerOn() then
        if square and not square:isOutside() then return false end
    end
    return true
end

return CPowerbank