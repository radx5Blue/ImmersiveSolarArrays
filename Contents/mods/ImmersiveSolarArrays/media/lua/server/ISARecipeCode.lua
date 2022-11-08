ISARecipe = {}
ISARecipe.OnTest = {}
ISARecipe.OnCreate = {}
ISARecipe.OnGiveXP = {}

function SolarModConvertBattery(items, result, player)
	--this function makes sure charge and condition remain the same when converting a car battery for solar use

	for i=0, items:size()-1 do
		if(items:get(i):getType() == "CarBattery1" or items:get(i):getType() == "CarBattery2" or items:get(i):getType() == "CarBattery3") then
			local item = items:get(i)
			result:setUsedDelta(item:getUsedDelta());
			result:setCondition(item:getCondition());
		end
	end
	player:getXp():AddXP(Perks.Electricity, 1);
end

function SolarModConvertBatteryReverse(items, result, player)
	--this function makes sure charge and condition remain the same when converting a battery back for car use
	for i=0, items:size()-1 do
		if(items:get(i):getType() == "50AhBattery" or items:get(i):getType() == "75AhBattery" or items:get(i):getType() == "100AhBattery") then
			local item = items:get(i)
			result:setUsedDelta(item:getUsedDelta());
			result:setCondition(item:getCondition() - (25 - (player:getPerkLevel(Perks.Electricity)*2)));	--make it worse to prevent misuse
		end
	end
end

function SolarModConvertBatteryDIY(items, result, player)
	local addUpDelta = 0
	local addUpCond = 0
	local tick = 0
	for i=0, items:size()-1 do
		if(items:get(i):getType() == "50AhBattery" or items:get(i):getType() == "75AhBattery" or items:get(i):getType() == "100AhBattery") then
			local item = items:get(i)
			addUpDelta = addUpDelta + item:getUsedDelta()
			addUpCond = addUpCond + item:getCondition()
			tick = tick + 1
		end
	end
	result:setUsedDelta(addUpDelta / tick)
	result:setCondition(addUpCond / tick)
end

function ISARecipe.OnCreate.ReverseSolarPanel(items, result, player)
	local inventory = player:getInventory()

	if items:get(1):getWorldSprite() == "solarmod_tileset_01_8" then
		inventory:AddItems("Radio.ElectricWire",2)
	else
		inventory:AddItems("Radio.ElectricWire",2)
		inventory:AddItems("Base.MetalBar",3)
		inventory:AddItem(InventoryItemFactory.CreateItem("Base.Screws"))
		inventory:AddItem(InventoryItemFactory.CreateItem("Base.Screws"))
	end
end

function ISARecipe.OnGiveXP.CreateBatteryBank(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 8)
	player:getXp():AddXP(Perks.MetalWelding, 2)
end

