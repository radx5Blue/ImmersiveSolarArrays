require "Map/CGlobalObject"

CPowerbank = CGlobalObject:derive("CPowerbank")

function CPowerbank:new(luaSystem, globalObject)
    return CGlobalObject.new(self, luaSystem, globalObject)
end

function CPowerbank:shouldDrain()
    local isoPb = self:getIsoObject()
    if not self.switchchanged and not self.on then return false end
    if self.conGenerator and self.conGenerator.ison then return false end
    if getWorld():isHydroPowerOn() then
        if isoPb and not isoPb:getSquare():isOutside() then return false end
    end
    return true
end
