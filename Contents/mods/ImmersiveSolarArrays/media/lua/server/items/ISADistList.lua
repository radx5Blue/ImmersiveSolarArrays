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
registerAsLoot(iReg, 1.5, "ElectronicStoreMagazines");
registerAsLoot(iReg, 0.4, "MagazineRackMixed");
registerAsLoot(iReg, 0.6, "ShelfGeneric");

-- Solar panel

iReg = "ISA.SolarPanel";
registerAsLoot(iReg, 0.10, "CrateCamping");
registerAsLoot(iReg, 0.10, "CrateElectronics");
registerAsLoot(iReg, 0.10, "CrateMechanics");
registerAsLoot(iReg, 0.10, "ToolStoreMetalwork");
registerAsLoot(iReg, 0.10, "ToolStoreTools");
registerAsLoot(iReg, 0.15, "ToolStoreMisc");
registerAsLoot(iReg, 0.20, "StoreShelfElectronics");
registerAsLoot(iReg, 0.10, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.10, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.15, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.10, "CrateRandomJunk");
registerAsLoot(iReg, 0.10, "CrateTools");
registerAsLoot(iReg, 0.10, "CampingStoreGear");
registerAsLoot(iReg, 0.10, "OtherGeneric");
registerAsLoot(iReg, 0.10, "GarageMechanic");
registerAsLoot(iReg, 0.10, "ElectronicStoreAppliances");
registerAsLoot(iReg, 0.10, "ToolStoreFarming");


-- Deep cycle battery

iReg = "ISA.DeepCycleBattery";
registerAsLoot(iReg, 0.15, "JanitorMisc");
registerAsLoot(iReg, 0.15, "StoreShelfElectronics");
registerAsLoot(iReg, 0.15, "MechanicShelfElectric");
registerAsLoot(iReg, 0.2, "StoreShelfMechanics");
registerAsLoot(iReg, 0.15, "CrateElectronics");
registerAsLoot(iReg, 0.15, "CrateMechanics");
registerAsLoot(iReg, 0.15, "ToolStoreTools");
registerAsLoot(iReg, 0.2, "ToolStoreMisc");
registerAsLoot(iReg, 0.15, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.15, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.15, "CrateRandomJunk");
registerAsLoot(iReg, 0.15, "CrateTools");
registerAsLoot(iReg, 0.15, "OtherGeneric");
registerAsLoot(iReg, 0.15, "GarageMechanic");
registerAsLoot(iReg, 0.15, "ToolStoreFarming");

-- Super battery

iReg = "ISA.SuperBattery";
registerAsLoot(iReg, 0.05, "JanitorMisc");
registerAsLoot(iReg, 0.05, "StoreShelfElectronics");
registerAsLoot(iReg, 0.05, "MechanicShelfElectric");
registerAsLoot(iReg, 0.1, "StoreShelfMechanics");
registerAsLoot(iReg, 0.05, "CrateElectronics");
registerAsLoot(iReg, 0.05, "CrateMechanics");
registerAsLoot(iReg, 0.05, "ToolStoreTools");
registerAsLoot(iReg, 0.1, "ToolStoreMisc");
registerAsLoot(iReg, 0.2, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.05, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.05, "CrateRandomJunk");
registerAsLoot(iReg, 0.05, "CrateTools");
registerAsLoot(iReg, 0.05, "OtherGeneric");
registerAsLoot(iReg, 0.05, "GarageMechanic");
registerAsLoot(iReg, 0.05, "ToolStoreFarming");



-- Inverter

iReg = "ISA.ISAInverter";
registerAsLoot(iReg, 0.10, "StoreShelfElectronics");
registerAsLoot(iReg, 0.10, "StoreShelfMechanics");
registerAsLoot(iReg, 0.10, "CrateElectronics");
registerAsLoot(iReg, 0.10, "CrateMechanics");
registerAsLoot(iReg, 0.10, "MechanicShelfMisc");
registerAsLoot(iReg, 0.10, "MechanicShelfElectric");
registerAsLoot(iReg, 0.10, "ToolStoreMisc");
registerAsLoot(iReg, 0.10, "ToolStoreTools");
registerAsLoot(iReg, 0.10, "GigamartHouseElectronics");
registerAsLoot(iReg, 0.10, "ArmyStorageElectronics");
registerAsLoot(iReg, 0.10, "ElectronicStoreMisc");
registerAsLoot(iReg, 0.10, "CrateRandomJunk");
registerAsLoot(iReg, 0.10, "CrateTools");
registerAsLoot(iReg, 0.10, "OtherGeneric");
registerAsLoot(iReg, 0.10, "GarageMechanic");
registerAsLoot(iReg, 0.10, "ElectronicStoreAppliances");
registerAsLoot(iReg, 0.10, "ToolStoreFarming");

