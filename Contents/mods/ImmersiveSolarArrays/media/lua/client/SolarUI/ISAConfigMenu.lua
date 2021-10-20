require "ISAConfig/ISAConfig"


ISA = ISA or {}

ISA.config = {
    solarPanelEfficiency = 16,
    worldSpawn = 50,
    containerSpawn = 5,
    batteryDegradeRate = 25,
    DIYBatteryCap = 200,
}



ISA.modId = "ISA" -- needs to the same as in your mod.info
ISA.name = "Immersive Solar Arrays Settings" -- the name that will be shown in the MOD tab

ISA.menu = {
    solarPanelEfficiency = {
        type = "Numberbox",
        title = "Solar Panel Efficiency",
        tooltip = "How much energy the solar panels generate (Default 16).",
    },
    worldSpawn = {
        type = "Numberbox",
        title = "World Spawn Rarity",
        tooltip = "How often solar panels will spawn at certain places in the world.",
    },
    containerSpawn = {
        type = "Numberbox",
        title = "Container Spawn Rarity",
        tooltip = "How often solar panels and other mod items spawn in containers.",
    },
    batteryDegradeRate = {
        type = "Numberbox",
        title = "Battery Degrade Rate",
        tooltip = "How quickly batteries become broken.",
    },
    DIYBatteryCap = {
        type = "Numberbox",
        title = "DIY Battery Capacity",
        tooltip = "How much charge a DYI battery can hold (Default 200).",
    },
}

ISAConfig.addMod(ISA.modId, ISA.name, ISA.config, ISA.menu, "Immersive Solar Arrays")



local function OnGameStart()
    SandboxVars.StartTime = 2 -- if this isn't set to the default time, Zomboid may reset the clock time after every Sandbox change.
end
Events.OnGameStart.Add(OnGameStart);