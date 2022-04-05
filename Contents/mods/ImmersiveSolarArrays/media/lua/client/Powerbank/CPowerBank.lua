require "Map/CGlobalObject"

CPowerbank = CGlobalObject:derive("CPowerbank")

function CPowerbank:new(luaSystem, globalObject)
    return CGlobalObject.new(self, luaSystem, globalObject)
end

--function CPowerbank:fromModData(modData)
--    self.on = modData["on"]
--    self.batteries = modData["batteries"]
--    self.charge = modData["charge"]
--    self.maxcapacity = modData["maxcapacity"]
--    self.drain = modData["drain"]
--    self.npanels = modData["npanels"]
--    self.panels = modData["panels"]
--    self.overlay = modData["overlay"]
--    self.lastHour = modData["lastHour"]
--end
