local isa = require "ISAUtilities"
local sandbox = SandboxVars.ISA

local PbSystem = { common = {} }

function PbSystem:addCommon(obj)
    for key,value in pairs(self.common) do
        obj[key] = value
    end
end

function PbSystem.common:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function PbSystem.common:getIsoObjectOnSquare(square)
    if not square then return end
    local objects = square:getSpecialObjects()
    for i=0,objects:size()-1 do
        local isoObject = objects:get(i)
        if self:isValidIsoObject(isoObject) then
            return isoObject
        end
    end
end

function PbSystem.common:getMaxSolarOutput(SolarInput)
    return SolarInput * (83 * ((sandbox.solarPanelEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
end

local climateManager
function PbSystem.common:getModifiedSolarOutput(SolarInput)
    if not climateManager then climateManager = getClimateManager() end
    local cloudiness = climateManager:getCloudIntensity()
    local light = climateManager:getDayLightStrength()
    local fogginess = climateManager:getFogIntensity()
    local CloudinessFogginessMean = 1 - (((cloudiness + fogginess) / 2) * 0.25) --make it so that clouds and fog can only reduce output by 25%
    local temperature = climateManager:getTemperature()
    local temperaturefactor = temperature * -0.0035 + 1.1 --based on linear single crystal sp efficiency
    local output = self:getMaxSolarOutput(SolarInput)
    output = output * CloudinessFogginessMean
    output = output * temperaturefactor
    output = output * light
    return output
end

function PbSystem.common:getValidBackupOnSquare(square)
    local generator = square:getGenerator()
    --return generator and instanceof(generator,"IsoGenerator") and generator:isConnected() and not isa.WorldUtil.findTypeOnSquare(square,"Powerbank")
    return generator:isConnected() and not isa.WorldUtil.findTypeOnSquare(square,"Powerbank")
end

function PbSystem.common:getValidPanelOnSquare(square)
    return square:isOutside() and isa.WorldUtil.findTypeOnSquare(square,"Panel")
end

--function PbSystem.common:isValidBackup(generator,square)
--    --return generator and instanceof(generator,"IsoGenerator") and generator:isConnected() and not isa.WorldUtil.findTypeOnSquare(square,"Powerbank")
--    return generator:isConnected() and not isa.WorldUtil.findTypeOnSquare(square,"Powerbank")
--end

return PbSystem