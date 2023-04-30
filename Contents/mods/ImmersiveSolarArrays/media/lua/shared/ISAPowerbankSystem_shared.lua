--[[
Shared functions between client and server systems
--]]

local isa = require "ISAUtilities"
local sandbox = SandboxVars.ISA

local PbSystem = {}

--also adds this function
function PbSystem:new(obj)
    for key,value in pairs(self) do
        obj[key] = value
    end
    return obj
end

function PbSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function PbSystem:getIsoObjectOnSquare(square)
    if not square then return end
    local objects = square:getSpecialObjects()
    for i=0,objects:size()-1 do
        local isoObject = objects:get(i)
        if self:isValidIsoObject(isoObject) then
            return isoObject
        end
    end
end

function PbSystem:getMaxSolarOutput(SolarInput)
    return SolarInput * (83 * ((sandbox.solarPanelEfficiency * 1.25) / 100)) --changed to more realistic 1993 levels
end

local climateManager
function PbSystem:getModifiedSolarOutput(SolarInput)
    climateManager = climateManager or getClimateManager()
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

function PbSystem:getValidBackupOnSquare(square)
    local generator = square:getGenerator()
    if generator and generator:isConnected() and not isa.WorldUtil.findTypeOnSquare(square,"Powerbank") then
        return generator
    end
end

return PbSystem