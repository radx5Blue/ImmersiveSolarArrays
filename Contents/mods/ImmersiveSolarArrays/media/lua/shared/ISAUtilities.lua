local util = {}

util.maxBatteryCapacity = {
    ["50AhBattery"] = 50,
    ["75AhBattery"] = 75,
    ["100AhBattery"] = 100,
    ["DeepCycleBattery"] = 200,
    ["SuperBattery"] = 400,
    ["DIYBattery"] = SandboxVars.ISA.DIYBatteryCapacity
}
--Events.OnInitGlobalModData.Add(function()
--    local manager = getScriptManager()
--    for i,v in pairs(util.maxBatteryCapacity) do
--        manager:getItem("ISA."..i):DoParam("maxCapacity = "..v)
--        manager:getItem("ISA."..i):DoParam("ItemCapacity = "..math.floor((v/2)))
--    end
--end)

util.patchClassMetaMethod = function(class, methodName, createPatch)
    local metatable = __classmetatables[class]
    if not metatable then
        error("Unable to find metatable for class "..tostring(class))
    end
    local metatable__index = metatable.__index
    if not metatable__index then
        error("Unable to find __index in metatable for class "..tostring(class))
    end
    local originalMethod = metatable__index[methodName]
    metatable__index[methodName] = createPatch(originalMethod)
end

Events.OnInitGlobalModData.Add(function()
    if not SandboxVars.ISA.DIYBatteryCapacity then SandboxVars.ISA.DIYBatteryCapacity = 200 end
    util.maxBatteryCapacity["DIYBattery"] = SandboxVars.ISA.DIYBatteryCapacity
end)

function util.AcceptItemFunction(container,item)
    if util.maxBatteryCapacity[item:getType()] then return true end
    return false
end


--debug
ISASharedUtil = util
--if not SandboxVars.ISA.BatteryCapacity then SandboxVars.ISA.BatteryCapacity = 1 end
--ISADebug_onGameBoot = OnGameBoot
--SandboxVars.ISA.BatteryCapacity = 2
return util