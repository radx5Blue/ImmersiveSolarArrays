require 'Items/ProceduralDistributions'

function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";


-- Solar Mag
iReg = "ISA.ISAMag1";
registerAsLoot(iReg, 1.0, "BookstoreBooks");
registerAsLoot(iReg, 0.5, "PostOfficeBooks");
registerAsLoot(iReg, 0.8, "LibraryBooks");
registerAsLoot(iReg, 1.0, "LivingRoomShelf");

-- Solar panel

iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.04, "CrateCamping");
registerAsLoot(iReg, 0.10, "CrateElectronics");
registerAsLoot(iReg, 0.002, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.8, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.08, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.08, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.002, "CrateRandomJunk");
registerAsLoot(iReg, 0.002, "CrateTools");
registerAsLoot(iReg, 0.02, "CampingStoreGear");

-- Deep cycle battery

iReg = "ISA.DeepCycleBattery";
registerAsLoot(iReg, 0.04, "StoreShelfMechanics");
registerAsLoot(iReg, 0.8, "CrateElectronics");
registerAsLoot(iReg, 0.8, "CrateMechanics");
registerAsLoot(iReg, 0.8, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.8, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.004, "CrateRandomJunk");
registerAsLoot(iReg, 0.004, "CrateTools");

-- Inverter

iReg = "ISA.ISAInverter";
registerAsLoot(iReg, 0.8, "StoreShelfMechanics");
registerAsLoot(iReg, 0.8, "CrateElectronics");
registerAsLoot(iReg, 0.8, "CrateMechanics");
registerAsLoot(iReg, 0.02, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.04, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.002, "CrateRandomJunk");
registerAsLoot(iReg, 0.02, "CrateTools");
