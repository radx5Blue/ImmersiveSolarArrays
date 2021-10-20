require "ISAConfig/ISAConfig"


ISA = ISA or {}

ISA.config = {
    --Infection Settings
    infectionEnabled = true,
    biteInfectionChance = 95,
    biteInfectionChanceDeath = 50,
    lacerationInfectionChance = 25,
    lacerationInfectionChanceDeath = 25,
    scratchInfectionChance = 7,
    scratchInfectionChanceDeath = 0,
    --ISAeed Settings
    ISAeedEnabled = true,
    percentRunners = 10,
    percentWalkers = 60,
    percentShamblers = 25,
    percentFakeDead = 3,
    percentCrawlers = 2,
    --Group Settings
    groupEnabled = true,
    groupPeakDay = 180,
    groupSize = 200,
    groupDistance = 30,
    groupSeperation = 15,
    groupRadius = 10,
    --Other Zombie Settings
    fallDamageEnabled = true,
    openDoorChance = 5,
    --General Settings    
    shutoffs = 2,
    armorEnabled = true,
    xpEnabled = true,
    combatEnabled = true,
    fasterSeasons = 1,
    --experimental
    weatherEnabled = true,
}



ISA.modId = "ISA" -- needs to the same as in your mod.info
ISA.name = "Immersive Solar Arrays Settings" -- the name that will be shown in the MOD tab

ISA.menu = {
    infectionTitle = {
        type = "Text",
        text = "Infection Settings",
    },
    infectionEnabled = {
        type = "Tickbox",
        title = "Enabled",
    },
    biteInfectionChance = {
        type = "Numberbox",
        title = "Bite infection (%)",
        tooltip = "The chance that a bite will result in getting infected.",
    },
    biteInfectionChanceDeath = {
        type = "Numberbox",
        title = "Bite infection mortality (%)",
        tooltip = "The chance that the infection will lead to zombification.",
    },
    lacerationInfectionChance = {
        type = "Numberbox",
        title = "Laceration infection (%)",
        tooltip = "The chance that a scratch will result in getting infected.",
    },
    lacerationInfectionChanceDeath = {
        type = "Numberbox",
        title = "Laceration infection mortality (%)",
        tooltip = "The chance that the infection will lead to zombification.",
    },
    scratchInfectionChance = {
        type = "Numberbox",
        title = "Scratch infection (%)",
        tooltip = "The chance that a scratch will result in getting infected.",
    },
    scratchInfectionChanceDeath = {
        type = "Numberbox",
        title = "Scratch infection mortality (%)",
        tooltip = "The chance that the infection will lead to zombification.",
    },
    infectionISAace = {
        type = "ISAace",
    },

    ISAeedTitle = {
        type = "Text",
        text = "ISAeed Settings",
    },
    ISAeedEnabled = {
        type = "Tickbox",
        title = "Enabled",
    },
    percentRunners = {
        type = "Numberbox",
        title = "Runners (%)",
    },
    percentWalkers = {
        type = "Numberbox",
        title = "Walkers (%)",
    },
    percentShamblers = {
        type = "Numberbox",
        title = "Shamblers (%)",
    },
    percentCrawlers = {
        type = "Numberbox",
        title = "Crawlers (%)",
    },
    percentFakeDead = {
        type = "Numberbox",
        title = "Fake dead (%)",
    },
    ISAeedISAace = {
        type = "ISAace",
    },

    groupTitle = {
        type = "Text",
        text = "Grouping Settings",
    },
    groupEnabled = {
        type = "Tickbox",
        title = "Enabled",
        tooltip = "Zombie grouping behaviour will change over time.",
    },
    groupPeakDay = {
        type = "Numberbox",
        title = "Peak day",
    },
    groupSize = {
        type = "Numberbox",
        title = "Rally Group Size (0-1000)",
    },
    groupDistance = {
        type = "Numberbox",
        title = "Rally Travel Distance (5-50)",
    },
    groupSeperation = {
        type = "Numberbox",
        title = "Rally Group Seperation (5-25)",
    },
    groupRadius = {
        type = "Numberbox",
        title = "Rally Group Radius (1-10)",
    },
    groupISAace = {
        type = "ISAace",
    },

    zombieTitle = {
        type = "Text",
        text = "Other Zombie Settings",
    },
    fallDamageEnabled = {
        type = "Tickbox",
        title = "Realistic fall damage",
        tooltip = "Zombies take increased fall damage and have a chance to break their legs.",
    },
    openDoorChance = {
        type = "Numberbox",
        title = "Thumps open doors (%)",
        tooltip = "The chance that a zombie will open an unlocked door by accident.",
    },
    zombieISAace = {
        type = "ISAace",
    },

    generalTitle = {
        type = "Text",
        text = "General Settings",
    },
    shutoffs = {
        type = "Combobox",
        title = "Water & electricity shutoffs",
        options = {
            {"use sandbox settings", 0},
            {"14 days (standard setting)", 1},
            {"12-16 days", 2},
            {"1-3 weeks", 3},
            {"2-4 weeks", 4},
        }
    },
    armorEnabled = {
        type = "Tickbox",
        title = "Add clothing defenses",
        tooltip = "Adds armor defense values to clothing that doesn't have any.",
    },
    xpEnabled = {
        type = "Tickbox",
        title = "Strength & Fitness x3",
        tooltip = "Increased strength & fitness gains.",
    },
    combatEnabled = {
        type = "Tickbox",
        title = "Alternative combat",
        tooltip = "The chance to hit several targets with a weapon depends on skills & current condition. Pushing does not interrupt movement. Turn ISAeed is doubled.",
    },
    fasterSeasons = {
        type = "Combobox",
        title = "Season ISAeed",
        tooltip = "Makes days pass faster on the clock. This ISAeeds up seasons & weather simulation, but has no effects on day length or gameplay.",
        options = {
            {"1x", 0},
            {"2x", 1},
            {"3x", 2},
            {"4x", 3},
        }
    },
    generalISAace = {
        type = "ISAace",
    },

    experimentalTitle = {
        type = "Text",
        text = "Experimental Settings",
    },
    weatherEnabled = {
        type = "Tickbox",
        title = "Weather affects Zombies",
        tooltip = "Weather conditions have effects on movement, activity, sight, and hearing.",
    },
}

ISA.addMod(ISA.modId, ISA.name, ISA.config, ISA.menu, "Immersive Solar Arrays")



local function OnGameStart()
    SandboxVars.StartTime = 2 -- if this isn't set to the default time, Zomboid may reset the clock time after every Sandbox change.
end
Events.OnGameStart.Add(OnGameStart);