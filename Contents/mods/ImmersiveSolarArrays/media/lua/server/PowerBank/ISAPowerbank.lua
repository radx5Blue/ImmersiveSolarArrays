ISAPowerbank = {}

ISAPowerbank.maxBatteryCapacity = {
    ["50AhBattery"] = 50,
    ["75AhBattery"] = 75,
    ["100AhBattery"] = 100,
    ["DeepCycleBattery"] = 200,
    ["SuperBattery"] = 400,
    ["DIYBattery"] = SandboxVars.ISA.DIYBatteryCapacity
}

--function ISAPowerbank.AcceptItemFunction(container,item)
--    if ISAPowerbank.maxBatteryCapacity[item:getType()] then return true end
--    return false
--end