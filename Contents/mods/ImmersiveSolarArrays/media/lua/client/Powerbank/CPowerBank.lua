require "Map/CGlobalObject"

CPowerbank = CGlobalObject:derive("CPowerbank")

function CPowerbank:new(luaSystem, globalObject)
    return CGlobalObject.new(self, luaSystem, globalObject)
end

function CPowerbank:shouldDrain()
    local square = self:getSquare()
    if not self.on then return false end
    if self.conGenerator and self.conGenerator.ison then return false end
    --41.69+ version
    if getWorld().isHydroPowerOn and getWorld():isHydroPowerOn() then
        if square and not square:isOutside() then return false end
    end
    return true
end
