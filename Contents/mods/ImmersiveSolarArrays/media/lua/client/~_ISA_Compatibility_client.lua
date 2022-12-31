local isa = require "ISAUtilities"
require "UI/ISAUI"
require "Powerbank/ISAPowerbankSystem_client"

isa.patchClassMetaMethod(zombie.inventory.types.DrainableComboItem.class,"DoTooltip",isa.UI.DoTooltip_patch)

require "ISUI/ISInventoryPane"
ISInventoryPane.drawItemDetails = isa.UI.ISInventoryPane_drawItemDetails_patch(ISInventoryPane.drawItemDetails)

require "TimedActions/ISActivateGenerator"
ISActivateGenerator.perform = isa.PbSystem_client.ISActivateGenerator_perform(ISActivateGenerator.perform)

require "TimedActions/ISInventoryTransferAction"
ISInventoryTransferAction.transferItem = isa.PbSystem_client.ISInventoryTransferAction_transferItem(ISInventoryTransferAction.transferItem)

require "TimedActions/ISPlugGenerator"
ISPlugGenerator.perform = isa.PbSystem_client.ISPlugGenerator_perform(ISPlugGenerator.perform)

require "Moveables/ISMoveablesAction"
ISMoveablesAction.perform = isa.PbSystem_client.ISMoveablesAction_perform(ISMoveablesAction.perform)
