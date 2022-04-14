require 'Items/ProceduralDistributions'
require 'Items/SuburbsDistributions'
require 'Items/Distributions'

function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";
local ISAmiscLootMult = SandboxVars.ISA.LRMMisc;
	if SandboxVars.ISA.LRMMisc == nil then
		ISAmiscLootMult = 1
	end
local ISAbatteryLootMult = SandboxVars.ISA.LRMBatteries;
	if SandboxVars.ISA.LRMBatteries == nil then
		ISAbatteryLootMult = 1
	end
local ISApanelLootMult = SandboxVars.ISA.LRMSolarPanels;
	if SandboxVars.ISA.LRMSolarPanels == nil then
		ISApanelLootMult = 1
	end


-- Solar Mag
iReg = "ISA.ISAMag1";
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "BookstoreBooks");
registerAsLoot(iReg, 0.5 * ISAmiscLootMult, "PostOfficeBooks");
registerAsLoot(iReg, 0.7 * ISAmiscLootMult, "PostOfficeMagazines");
registerAsLoot(iReg, 0.8 * ISAmiscLootMult, "LibraryBooks");
registerAsLoot(iReg, 1.0 * ISAmiscLootMult, "LivingRoomShelf");
registerAsLoot(iReg, 1.5 * ISAmiscLootMult, "ElectronicStoreMagazines");
registerAsLoot(iReg, 0.4 * ISAmiscLootMult, "MagazineRackMixed");
registerAsLoot(iReg, 0.6 * ISAmiscLootMult, "ShelfGeneric");



-- Solar panel
iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateCamping");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateElectronics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateMechanics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreTools");
registerAsLoot(iReg, 0.15 * ISApanelLootMult, "ToolStoreMisc");
registerAsLoot(iReg, 0.20 * ISApanelLootMult, "StoreShelfElectronics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.15 * ISApanelLootMult, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CrateRandomJunk");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateTools");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "CampingStoreGear");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "OtherGeneric");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "GarageMechanics");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ElectronicStoreAppliances");
registerAsLoot(iReg, 0.10 * ISApanelLootMult, "ToolStoreFarming");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CratePaint");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateFarming");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateMetalwork");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "MechanicShelfMisc");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "MechanicShelfElectric");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "LoggingFactoryTools");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GigamartFarming");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GarageTools");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "GarageMetalwork");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateCarpentry");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "BedroomDresser");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "ArmyHangarTools");



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
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CratePaint");
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CrateFarming");
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CrateMetalwork");



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
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CratePaint");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateFarming");
registerAsLoot(iReg, 0.05 * ISApanelLootMult, "CrateMetalwork");



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
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CratePaint");
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CrateFarming");
registerAsLoot(iReg, 0.03 * ISApanelLootMult, "CrateMetalwork");
