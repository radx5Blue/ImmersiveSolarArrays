local ISA = ImmersiveSolarArrays

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
    self.lastHour = modData["lastHour"]
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

function CPowerbank:isValidPanel(panel)
    local x,y,z = panel:getX(), panel:getY(), panel:getZ()
    if IsoUtils.DistanceToSquared(x, y, self.x, self.y) <= 400.0 and math.abs(z - self.z) <= 3 then
        for _,panel in ipairs(self.panels) do
            if x == panel.x and y == panel.y and z == panel.z then return "valid" end
        end
        return "not connected"
    else
        return "far"
    end
end

---checks the square for a panel object and returns the object and status
function CPowerbank:isValidPanelOnSquare(square)
    local panel = ISA.WorldUtil.findTypeOnSquare(square,"Panel")
    if panel ~= nil then
        return panel, square:isOutside() and self:isValidPanel(panel) or "inside"
    end
end

return CPowerbank