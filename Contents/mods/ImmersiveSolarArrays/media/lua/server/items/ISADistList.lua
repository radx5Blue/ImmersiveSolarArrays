require 'Items/ProceduralDistributions'

function registerAsLoot(item, chance, allocation)
  table.insert(ProceduralDistributions.list[allocation].items, item);
  table.insert(ProceduralDistributions.list[allocation].items, chance);
end

local iReg = "";


-- Yeast Mag
iReg = "ISA.ISAMag1";
registerAsLoot(iReg, 0.8, "BookstoreBooks");
registerAsLoot(iReg, 0.2, "PostOfficeBooks");
registerAsLoot(iReg, 0.7, "LibraryBooks");
registerAsLoot(iReg, 1.0, "LivingRoomShelf");
