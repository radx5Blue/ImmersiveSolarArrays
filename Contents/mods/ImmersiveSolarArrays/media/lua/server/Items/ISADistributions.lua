--fixme SandboxVars are default value at this stage, MP are loaded already OnPreDistributionMerge???, SP are not

local require, pairs, ipairs, table, type = require, pairs, ipairs, table, type --I mean why not

require 'Items/Distributions'
require 'Items/ProceduralDistributions'
local util = require "ISAUtilities"

local copyTable = copyTable
local SuburbsDistributions = SuburbsDistributions
local ProceduralDistributions = ProceduralDistributions
local VehicleDistributions = VehicleDistributions

local function registerAsLoot(item, chance, allocation)
	local insertTo = ProceduralDistributions.list[allocation].items
	table.insert(insertTo, item)
	table.insert(insertTo, chance)
end

local function addItem(item, chance, allocation)
  table.insert(allocation, item)
  table.insert(allocation, chance)
end

local function insertSimilarItems(base,targets,items)
	for _,t in ipairs(targets) do
		local insertTo = base[t] and base[t].items
		if insertTo then
			for _,i in ipairs(items) do
				table.insert(insertTo,i)
			end
		end
	end
end

local function insertRecursive(insertKey,insertInto,insertFrom,default)
	for key,value in pairs(insertFrom) do
		local _insertInto = insertInto[key]
		if not _insertInto and default then
			_insertInto = copyTable(default)
			insertInto[key] = _insertInto
		end
		if type(_insertInto) == "table" then
			if key == insertKey then
				for _,i in ipairs(value) do
					table.insert(_insertInto,i)
				end
			else
				insertRecursive(insertKey,_insertInto,value,default)
			end
		end
	end
end

--local function insertInto(targetKey,distName,modDist,default,doParse)
--	local dist = {
--		suburbs = SuburbsDistributions,
--		procedural = ProceduralDistributions,
--		vehicle = VehicleDistributions,
--	}
--	util.distributions.doParse = doParse or util.distributions.doParse
--	return insertRecursive(targetKey,dist[distName],modDist,default)
--end


---edit tables for container loot types / item rolls

local iReg = ""
local ISAmiscLootMult = SandboxVars.ISA.LRMMisc or 1
local ISAbatteryLootMult = SandboxVars.ISA.LRMBatteries or 1
local ISApanelLootMult = SandboxVars.ISA.LRMSolarPanels or 1

-- Solar Mag
iReg = "ISA.ISAMag1";
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "BookstoreBooks");
registerAsLoot(iReg, 0.5 * ISAmiscLootMult, "BookstoreMisc");
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "CrateMagazines");
registerAsLoot(iReg, 1.5 * ISAmiscLootMult, "ElectronicStoreMagazines");
registerAsLoot(iReg, 0.2 * ISAmiscLootMult, "EngineerTools");
registerAsLoot(iReg, 0.8 * ISAmiscLootMult, "LibraryBooks");
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "LivingRoomShelf");
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "LivingRoomShelfNoTapes");
registerAsLoot(iReg, 0.4 * ISAmiscLootMult, "MagazineRackMixed");
registerAsLoot(iReg, 0.5 * ISAmiscLootMult, "PostOfficeBooks");
registerAsLoot(iReg, 0.7 * ISAmiscLootMult, "PostOfficeMagazines");
registerAsLoot(iReg, 0.6 * ISAmiscLootMult, "ShelfGeneric");
addItem(iReg, 1, VehicleDistributions.ElectricianTruckBed.items)



-- Solar panel
iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "ArmyHangarTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ArmyStorageElectronics");
--registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CampingStoreGear");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateCarpentry");
--registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateCamping");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateElectronics");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateFarming");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateMechanics");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateMetalwork");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CratePaint");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateRandomJunk");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ElectronicStoreAppliances");
registerAsLoot(iReg, 0.15 * ISApanelLootMult, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "EngineerTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "GarageMechanics");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GarageMetalwork");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GarageTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GigamartFarming");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "LoggingFactoryTools");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "MechanicShelfElectric");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "MechanicShelfMisc");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "MetalShopTools");
registerAsLoot(iReg, 0.20 * ISApanelLootMult, "StoreShelfElectronics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreFarming");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.15 * ISApanelLootMult, "ToolStoreMisc");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "OtherGeneric");
addItem(iReg, 0.002, SuburbsDistributions.all.crate.items)
addItem(iReg, 0.001, SuburbsDistributions.all.metal_shelves.items)
addItem(iReg, 1, VehicleDistributions.ElectricianTruckBed.items)



-- Deep cycle battery
iReg = "ISA.DeepCycleBattery";
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "JanitorMisc");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "StoreShelfElectronics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "MechanicShelfElectric");
registerAsLoot(iReg, 0.2 * ISAbatteryLootMult, "StoreShelfMechanics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "CrateElectronics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "CrateMechanics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "ToolStoreTools");
registerAsLoot(iReg, 0.2 * ISAbatteryLootMult, "ToolStoreMisc");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "CrateRandomJunk");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "CrateTools");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "OtherGeneric");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "GarageMechanics");
registerAsLoot(iReg, 0.15 * ISAbatteryLootMult, "ToolStoreFarming");
registerAsLoot(iReg, 0.03 * ISAbatteryLootMult, "CratePaint");
registerAsLoot(iReg, 0.03 * ISAbatteryLootMult, "CrateFarming");
registerAsLoot(iReg, 0.03 * ISAbatteryLootMult, "CrateMetalwork");
addItem(iReg, 0.002, SuburbsDistributions.all.crate.items)
addItem(iReg, 0.001, SuburbsDistributions.all.metal_shelves.items)
addItem(iReg, 1, VehicleDistributions.ElectricianTruckBed.items)


-- Super battery
iReg = "ISA.SuperBattery";
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "JanitorMisc");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "StoreShelfElectronics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "MechanicShelfElectric");
registerAsLoot(iReg, 0.1 * ISAbatteryLootMult, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateElectronics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateMechanics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "ToolStoreTools");
registerAsLoot(iReg, 0.1 * ISAbatteryLootMult, "ToolStoreMisc");
registerAsLoot(iReg, 0.2 * ISAbatteryLootMult, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateRandomJunk");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateTools");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "OtherGeneric");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "GarageMechanics");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "ToolStoreFarming");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CratePaint");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateFarming");
registerAsLoot(iReg, 0.05 * ISAbatteryLootMult, "CrateMetalwork");
addItem(iReg, 0.002, SuburbsDistributions.all.crate.items)
addItem(iReg, 0.001, SuburbsDistributions.all.metal_shelves.items)
addItem(iReg, 0.4, VehicleDistributions.ElectricianTruckBed.items)



-- Inverter
iReg = "ISA.ISAInverter";
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "StoreShelfElectronics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "StoreShelfMechanics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "CrateElectronics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "CrateMechanics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "MechanicShelfMisc");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "MechanicShelfElectric");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ToolStoreMisc");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ToolStoreTools");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "CrateRandomJunk");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "CrateTools");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "OtherGeneric");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "GarageMechanics");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ElectronicStoreAppliances");
registerAsLoot(iReg, 0.10 * ISAmiscLootMult, "ToolStoreFarming");
registerAsLoot(iReg, 0.03 * ISAmiscLootMult, "CratePaint");
registerAsLoot(iReg, 0.03 * ISAmiscLootMult, "CrateFarming");
registerAsLoot(iReg, 0.03 * ISAmiscLootMult, "CrateMetalwork");
addItem(iReg, 0.005, SuburbsDistributions.all.crate.items)
addItem(iReg, 0.005, SuburbsDistributions.all.metal_shelves.items)
addItem(iReg, 0.6, VehicleDistributions.ElectricianTruckBed.items)



local SolarBox = {
	rolls = 4,
	items = {
		"ISA.SolarPanel", 32,
		"ISA.DeepCycleBattery", 24,
		"ISA.SuperBattery", 16,
	},
	junk = {
		rolls = 1,
		items = {
			"ISA.ISAMag1", 64,
			"ISA.ISAInverter", 64,
			"ISA.SolarPanel", 16,
			"ISA.DeepCycleBattery", 16,
			"ISA.SuperBattery", 16,
			"ElectronicsScrap", 20,
			"MetalBar", 10,
			"SmallSheetMetal", 10,
			"Screws", 5,
			"Radio.ElectricWire", 20,
			"RemoteCraftedV3", 0.1,
		}
	}
}

local Batteries = {
	rolls = 4,
	items = {
		"ISA.DeepCycleBattery", 36,
		"ISA.SuperBattery", 8,
		"ISA.DIYBattery", 8,
		"ISA.WiredCarBattery", 8,
	}
}

ProceduralDistributions.list.ISABatteries = Batteries
ProceduralDistributions.list.ISASolarBox = SolarBox
SuburbsDistributions.all.BatteryBank = Batteries
SuburbsDistributions.all.SolarBox = SolarBox

---edit tables for room / cache house types

--all is more of a direct check of container type loot, procedural ends up with no loot when outside
--SuburbsDistributions.all.BatteryBank = {
--	procedural = true,
--	procList = {
--		{name="ISABatteries", min=0, max=99},
--	},
--}
--SuburbsDistributions.all.SolarBox = {
--	procedural = true,
--	procList = {
--		{ name = "ISASolarBox", min = 0, max = 99, weightChance = 80 },
--		{ name = "ISABatteries", min = 0, max = 99, weightChance = 20 },
--	},
--}
local SolarBoxCache = copyTable(SuburbsDistributions.electronicsstorage)
SolarBoxCache.isStore = nil
SolarBoxCache.SolarBox = copyTable(SolarBox)
SolarBoxCache.SolarBox.rolls = 32
SuburbsDistributions.ISASolarBoxCache = SolarBoxCache

insertRecursive("procList",SuburbsDistributions,{
	electronicsstorage = {
		metal_shelves = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 10 },
			},
		},
		crate = {
			proclist = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 20 },
				{ name = "ISABatteries", min = 0, max = 1, weightChance = 5 },
			},
		},
	},
	garagestorage = {
		crate = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 3 },
			},
		},
	},
	storageunit = {
		crate = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 5 },
			},
		},
		metal_shelves = {
			proclist = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 3 },
			}
		}
	},
	warehouse = {
		crate = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 5 },
				{ name = "ISABatteries", min = 0, max = 1, weightChance = 5 },
			},
		},
	},
	--Cache
	SafehouseLoot = {
		metal_shelves = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 1, weightChance = 5 },
			},
		},
	},
	ISASolarBoxCache = {
		crate = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 3, weightChance = 25 },
				{ name = "ISABatteries", min = 0, max = 1, weightChance = 10 },
			},
		},
		metal_shelves = {
			procList = {
				{ name = "ISASolarBox", min = 0, max = 3, weightChance = 20 },
			},
		},
	}
})

--stash items
util.distributions = {insertSimilarItems = insertSimilarItems}
util.queueFunction("OnLoadedMapZones",function()
	if util.distributions.doParse then
		ItemPickerJava.Parse()
	end
	util.distributions = nil
end)

--util.distributions = {insertInto = insertInto,checkList = {}}
--util.queueFunction("OnLoadedMapZones",function()
--	for _,fn in ipairs(util.distributions.checkList) do
--		fn()
--	end
--	if util.distributions.doParse then
--		ItemPickerJava.Parse()
--	end
--	util.distributions = nil
--end)
