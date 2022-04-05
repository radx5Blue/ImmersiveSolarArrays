require "PowerBank/SpowerbankSystem"

local function OnObjectAboutToBeRemoved(isoObject)
    local spritename = isoObject:getTextureName()
    if spritename == "solarmod_tileset_01_6" or spritename == "solarmod_tileset_01_7" or spritename == "solarmod_tileset_01_8" or
            spritename == "solarmod_tileset_01_9" or spritename == "solarmod_tileset_01_10" then
        SPowerbankSystem.instance.removePanel(isoObject)
    end
end
Events.OnObjectAboutToBeRemoved.Add(OnObjectAboutToBeRemoved)