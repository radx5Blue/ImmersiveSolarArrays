require 'Items/ProceduralDistributions'

function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";


-- Solar Mag
iReg = "ISA.ISAMag1";
registerAsLoot(iReg, 0.8, "BookstoreBooks");
registerAsLoot(iReg, 0.2, "PostOfficeBooks");
registerAsLoot(iReg, 0.7, "LibraryBooks");
registerAsLoot(iReg, 1.0, "LivingRoomShelf");

-- Solar panel

iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.02, "CrateCamping");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.001, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.05, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.005, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.05, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.001, "CrateRandomJunk");
registerAsLoot(iReg, 0.001, "CrateTools");
registerAsLoot(iReg, 0.01, "CampingStoreGear");

-- Deep cycle battery

iReg = "ISA.DeepCycleBattery";
registerAsLoot(iReg, 0.02, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.05, "CrateMechanics");
registerAsLoot(iReg, 0.05, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.001, "CrateRandomJunk");
registerAsLoot(iReg, 0.001, "CrateTools");

-- Inverter

iReg = "ISA.ISAInverter";
registerAsLoot(iReg, 0.05, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.05, "CrateMechanics");
registerAsLoot(iReg, 0.01, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.02, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.001, "CrateRandomJunk");
registerAsLoot(iReg, 0.01, "CrateTools");
