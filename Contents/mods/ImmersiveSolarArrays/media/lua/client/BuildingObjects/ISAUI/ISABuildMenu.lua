--require '\BuildingObjects\ISUI\ISBuildMenu'

ISBuildMenu = {};

require "ISBaseObject"

ISBuildMenu = ISBaseObject:derive("ISBuildMenu");



ISBuildMenu.buildFurnitureMenu = function(subMenu, context, option, player)
	local powerBankOption = subMenu:addOption(getText("ContextMenu_Rain_Collector_Barrel"), worldobjects, ISBuildMenu.onCreatePowerBank, player, "solarmod_tileset_01_0", 100);
	local tooltip = ISBuildMenu.canBuild(4,4,0,0,0,4,powerBankOption, player);
    -- we add that we need 4 garbage bag too
	local garbagebag = ISBuildMenu.countMaterial(player, "Base.Garbagebag");
    if garbagebag < 4 then
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
        if not ISBuildMenu.cheat then
            powerBankOption.onSelect = nil;
            powerBankOption.notAvailable = true;
        end
    else
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType("Base.Garbagebag") .. " " .. garbagebag .. "/4 ";
    end
	tooltip:setName(getText("ContextMenu_Rain_Collector_Barrel"));
	tooltip.description = getText("Tooltip_craft_rainBarrelDesc") .. tooltip.description;
	tooltip:setTexture("solarmod_tileset_01_0");
	ISBuildMenu.requireHammer(powerBankOption)
	
end
	
	
	
ISBuildMenu.onCreatePowerBank = function(worldobjects, player, sprite, powerGenerated, powerConsumption, powerAmount, powerMax, hasBackup)
	local powerBank = ISAPowerBank:new(player, sprite, powerGenerated, powerConsumption, powerAmount, powerMax, hasBackup );
	-- we now set his the mod data the needed material
	-- by doing this, all will be automatically consummed, drop on the ground if destoryed etc.
	powerBank.modData["need:Base.Plank"] = "4";
	powerBank.modData["need:Base.Nails"] = "4";
    powerBank.modData["need:Base.Garbagebag"] = "4";
    powerBank.modData["xp:Woodwork"] = 5;
    -- and now allow the item to be dragged by mouse
	powerBank.player = player
	getCell():setDrag(powerBank, player);
end