ISAPowerbank = {}

ISAPowerbank.maxBatteryCapacity = {
    ["50AhBattery"] = 50,
    ["75AhBattery"] = 75,
    ["100AhBattery"] = 100,
    ["DeepCycleBattery"] = 200,
    ["SuperBattery"] = 400,
    ["DIYBattery"] = (SandboxVars.ISA.DIYBatteryCapacity or 200)
}
