ISAMenu = ISAMenu or {};
ISAMenu._index = ISAMenu

ISAMenu.createMenuEntries = function(_player, _context, _worldObjects)

	local context = _context;
	local worldobjects = _worldObjects; 
	
	
	local ISAOption = context:addOption("Solar", worldobjects);
	local subMenu = ISContextMenu:getNew(context);
	context:addSubMenu(ISAOption, subMenu);
	
	ISAOption.context = context
	ISAOption.subMenu = subMenu
	--[[ depreciated
	local godFuncCall = "getPlayer():setGodMod(CheatCoreCM.IsGod)"
	if versionNumber <= 39 then	-- the new cheat uses the game's built-in isGodMod() function that was added in build 40. The legacy function is used for builds 39 and under.
		godFuncCall = nil
	end	
	--]]
		
		
	 subMenu:addOption("Place Battery Bank", worldobjects, function() SaySolar() end);
	-- subMenu:addOption("Creative", worldobjects, function() CheatCoreCM.HandleToggle("Creative Mode", "CheatCoreCM.buildCheat") end);
	-- subMenu:addOption("Ghost Mode", worldobjects, function() CheatCoreCM.HandleToggle("Ghost Mode", "CheatCoreCM.IsGhost") end);
	-- subMenu:addOption("Heal Yourself", worldobjects, CheatCoreCM.DoHeal);
	-- subMenu:addOption("Noclip", worldobjects, function() CheatCoreCM.HandleToggle("Noclip", "CheatCoreCM.IsNoClip", "getPlayer():setNoClip(CheatCoreCM.IsNoClip)") end);
	-- subMenu:addOption("Refill Ammo", worldobjects, CheatCoreCM.DoRefillAmmo);
	-- subMenu:addOption("Infinite Ammo", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Ammo", "CheatCoreCM.IsAmmo") end);
	-- subMenu:addOption("No Delay Between Shots", worldobjects, function() CheatCoreCM.HandleToggle("No Shot Delay", "CheatCoreCM.NoReload", "CheatCoreCM.DoNoReload()") end);
	-- subMenu:addOption("Open Item Spawner", worldobjects, function() if crucibleCore.mainWindow == nil then crucibleUI.makeWindow() else crucibleCore.mainWindow:setVisible(true) end end)
	-- subMenu:addOption("Open Teleport Menu", worldobjects, compassCore.makeWindow);
	-- subMenu:addOption("Open Lua Interpreter/File Editor", worldobjects, function() ISUILuaWindow.SetupBar() end);
	-- subMenu:addOption("Toggle Delete Mode (X to Delete)", worldobjects, function() CheatCoreCM.HandleToggle("Delete Mode", "CheatCoreCM.IsDelete") end);
	
	-- ISUICheatMenu:createTerraformMenu()
	
	-- ISUICheatMenu:createBarricadeMenu()
	
	-- subMenu:addOption("Toggle Fire Brush (N To Start Fire, F To Extinguish)", worldobjects, function() CheatCoreCM.HandleToggle("Fire Brush", "CheatCoreCM.FireBrushEnabled") end);
	-- subMenu:addOption("Toggle Fly Mode (Up/Down Arrow To Change Height)", worldobjects, function() CheatCoreCM.HandleToggle("Fly Mode", "CheatCoreCM.IsFly") end);
	
	-- ISUICheatMenu:createZombieMenu()
	
	-- subMenu:addOption("Infinite Carryweight", worldobjects, CheatCoreCM.DoCarryweightCheat);
	-- subMenu:addOption("Prevent death", worldobjects, function() CheatCoreCM.HandleToggle("Prevent Death", "CheatCoreCM.DoPreventDeath") end);
	-- subMenu:addOption("Insta-Kill Melee", worldobjects, function() CheatCoreCM.HandleToggle("Insta-kill Melee", "CheatCoreCM.IsMelee","CheatCoreCM.DoWeaponDamage()") end);
	-- subMenu:addOption("Infinite Weapon Durability", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Weapon Durability", "CheatCoreCM.IsRepair") end);
	-- subMenu:addOption("Repair Equipped Item", worldobjects, function() CheatCoreCM.HandleToggle(nil, nil, "CheatCoreCM.DoRepair()", "getPlayer():Say('Weapon Repaired!')") end);
	-- subMenu:addOption("Learn All Recipes", worldobjects, function() CheatCoreCM.DoLearnRecipes() end)
	-- subMenu:addOption("Toggle Instant/Free Crafting", worldobjects, function() CheatCoreCM.HandleToggle("Instant Crafting", "CheatCoreCM.IsCraftingCheat", "CheatCoreCM.ToggleInstantCrafting()") end);
	-- subMenu:addOption("Toggle Instant Actions", worldobjects, function() CheatCoreCM.HandleToggle("Instant Actions", "CheatCoreCM.IsActionCheat", "CheatCoreCM.ToggleInstantActions()") end);
	-- --local NutritionOption = subMenu:addOption("Nutrition...", worldobjects);
	
	
	-- ISUICheatMenu:createStatsMenu()
	-- ISUICheatMenu:createTimeMenu()
	-- ISUICheatMenu:createWeatherMenu()
	-- ISUICheatMenu:createXPMenu()
	
	-- if versionNumber >= 39 then
		-- ISUICheatMenu:createVehicleMenu()
	-- end
	
	-----------------------------
	--Making the Nutrition menu--
	-----------------------------
	
	--[[
	local subMenuNutrition = subMenu:getNew(subMenu);
	context:addSubMenu(NutritionOption, subMenuNutrition)
	
	local HealthyOption = subMenuNutrition:addOption("Become Healthy", worldobjects, CheatCoreCM.becomeHealthy)
	
	local EditOption = subMenuNutrition:addOption("Edit...", worldobjects)
	local subMenuEdit = subMenuNutrition:getNew(subMenuNutrition)
	context:addSubMenu(EditOption, subMenuEdit)
	
	local NutrTable = {
	"Calories",
	"Carbohydrates",
	"Lipids",
	"Proteins",
	"Weight"
	}
	
	for k,v in ipairs(NutrTable) do
		subMenuEdit:addOption(v, worldobjects, function() CheatCoreCM.editNutrition(v) end)
	end
	--]]

	
	--[[
	subMenuStats:addOption("No Hunger", worldobjects, function() CheatCoreCM.HandleToggle("No Hunger", "CheatCoreCM.IsHunger") end);
	subMenuStats:addOption("No Thirst", worldobjects, function() CheatCoreCM.HandleToggle("No Thirst", "CheatCoreCM.IsThirst") end);
	subMenuStats:addOption("Never panic", worldobjects, function() CheatCoreCM.HandleToggle("Never Panic", "CheatCoreCM.IsPanic") end);
	subMenuStats:addOption("Always sane", worldobjects, function() CheatCoreCM.HandleToggle("Always Sane", "CheatCoreCM.IsSanity") end);
	subMenuStats:addOption("No stress", worldobjects, function()CheatCoreCM.HandleToggle("No Stress", "CheatCoreCM.IsStress") end);
	subMenuStats:addOption("No boredom", worldobjects, function() CheatCoreCM.HandleToggle("No Boredom", "CheatCoreCM.IsBoredom") end);
	subMenuStats:addOption("Never angry", worldobjects, function() CheatCoreCM.HandleToggle("Never Angry", "CheatCoreCM.IsAnger") end);
	subMenuStats:addOption("Never feel pain", worldobjects, function() CheatCoreCM.HandleToggle("Never Feel Pain", "CheatCoreCM.IsPain") end);
	subMenuStats:addOption("Never sick/remove sickness", worldobjects, function() CheatCoreCM.HandleToggle("Never Sick/Remove Sickness", "CheatCoreCM.IsSick") end);
	subMenuStats:addOption("Never drunk", worldobjects, function() CheatCoreCM.HandleToggle("Never Drunk", "CheatCoreCM.IsDrunk") end);
	subMenuStats:addOption("Infinite endurance", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Endurance", "CheatCoreCM.IsEndurance") end);
	subMenuStats:addOption("Infinite fitness", worldobjects, function() CheatCoreCM.HandleToggle("Infinite Fitness", "CheatCoreCM.IsFitness") end);
	subMenuStats:addOption("Never tired", worldobjects, function() CheatCoreCM.HandleToggle("Never Tired", "CheatCoreCM.IsSleep") end);
	--]]
	

end


SaySolar = function()

player = getPlayer()

player:Say("Solar")

end


Events.OnFillWorldObjectContextMenu.Add(ISAMenu.createMenuEntries);