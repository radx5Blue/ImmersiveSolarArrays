if isClient() then return end

require "PowerBank/SpowerbankSystem"

local function OnObjectAboutToBeRemoved(isoObject)
    if ISAScan.Types[isoObject:getTextureName()] == "Panel" then
        SPowerbankSystem.instance.removePanel(isoObject)
    end
end
Events.OnObjectAboutToBeRemoved.Add(OnObjectAboutToBeRemoved)