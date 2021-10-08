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
registerAsLoot(iReg, 0.7, "PostOfficeMagazines");
registerAsLoot(iReg, 0.8, "LibraryBooks");
registerAsLoot(iReg, 1.0, "LivingRoomShelf");
registerAsLoot(iReg, 1.0, "ElectronicStoreMagazines");
registerAsLoot(iReg, 0.4, "MagazineRackMixed");
registerAsLoot(iReg, 0.6, "ShelfGeneric");

-- Solar panel

iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.02, "CrateCamping");
registerAsLoot(iReg, 0.07, "CrateElectronics");
registerAsLoot(iReg, 0.03, "CrateMechanics");
registerAsLoot(iReg, 0.01, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.07, "ToolStoreTools");
registerAsLoot(iReg, 0.1, "ToolStoreMisc");
registerAsLoot(iReg, 0.2, "StoreShelfElectronics");
registerAsLoot(iReg, 0.05, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.07, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.05, "CrateRandomJunk");
registerAsLoot(iReg, 0.02, "CrateTools");
registerAsLoot(iReg, 0.05, "CampingStoreGear");
registerAsLoot(iReg, 0.01, "OtherGeneric");
registerAsLoot(iReg, 0.005, "GarageMechanic");
registerAsLoot(iReg, 0.01, "ElectronicStoreAppliances");

-- Deep cycle battery

iReg = "ISA.DeepCycleBattery";
registerAsLoot(iReg, 0.01, "JanitorMisc");
registerAsLoot(iReg, 0.05, "StoreShelfElectronics");
registerAsLoot(iReg, 0.02, "MechanicShelfElectric");
registerAsLoot(iReg, 0.04, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.05, "CrateMechanics");
registerAsLoot(iReg, 0.05, "ToolStoreTools");
registerAsLoot(iReg, 0.1, "ToolStoreMisc");
registerAsLoot(iReg, 0.05, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.02, "CrateRandomJunk");
registerAsLoot(iReg, 0.02, "CrateTools");
registerAsLoot(iReg, 0.01, "OtherGeneric");
registerAsLoot(iReg, 0.01, "GarageMechanic");


-- Inverter

iReg = "ISA.ISAInverter";
registerAsLoot(iReg, 0.05, "StoreShelfElectronics");
registerAsLoot(iReg, 0.07, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.07, "CrateMechanics");
registerAsLoot(iReg, 0.07, "MechanicShelfMisc");
registerAsLoot(iReg, 0.07, "MechanicShelfElectric");
registerAsLoot(iReg, 0.1, "ToolStoreMisc");
registerAsLoot(iReg, 0.07, "ToolStoreTools");
registerAsLoot(iReg, 0.02, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.02, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.02, "CrateRandomJunk");
registerAsLoot(iReg, 0.02, "CrateTools");
registerAsLoot(iReg, 0.01, "OtherGeneric");
registerAsLoot(iReg, 0.03, "GarageMechanic");
registerAsLoot(iReg, 0.01, "ElectronicStoreAppliances");
