require "Items/AcceptItemFunction"
require "recipecode"
local util = require("ISAUtilities")

local def = {}

local function addOrDrop(character, item)
	local inv = character:getInventory()
	if inv:getCapacityWeight() + item:getWeight() < inv:getEffectiveCapacity(character) then
		inv:AddItem(item)
	else
		character:getCurrentSquare():AddWorldInventoryItem(item,
			character:getX() - math.floor(character:getX()),
			character:getY() - math.floor(character:getY()),
			character:getZ() - math.floor(character:getZ()))
	end
end

AcceptItemFunction.ISA_Batteries = function(container,item)
	if item:hasModData() and item:getModData().ISAMaxCapacityAh or util.maxBatteryCapacity[item:getType()] then return true end
	return false
end

--function SolarModConvertBattery(items, result, player)
--	--this function makes sure charge and condition remain the same when converting a car battery for solar use
--
--	for i=0, items:size()-1 do
--		if(items:get(i):getType() == "CarBattery1" or items:get(i):getType() == "CarBattery2" or items:get(i):getType() == "CarBattery3") then
--			local item = items:get(i)
--			result:setUsedDelta(item:getUsedDelta());
--			result:setCondition(item:getCondition());
--		end
--	end
--	player:getXp():AddXP(Perks.Electricity, 1);
--end
--
--function SolarModConvertBatteryReverse(items, result, player)
--	--this function makes sure charge and condition remain the same when converting a battery back for car use
--	for i=0, items:size()-1 do
--		if(items:get(i):getType() == "50AhBattery" or items:get(i):getType() == "75AhBattery" or items:get(i):getType() == "100AhBattery") then
--			local item = items:get(i)
--			result:setUsedDelta(item:getUsedDelta());
--			result:setCondition(item:getCondition() - (25 - (player:getPerkLevel(Perks.Electricity)*2)));	--make it worse to prevent misuse
--		end
--	end
--end

function Recipe.OnCreate.SolarModConvertBatteryDIY(items, result, player)
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

--Recipe.convertBatteries = { ["Base.CarBattery1"] = "50AhBattery", ["Base.CarBattery2"] = "100AhBattery", ["Base.CarBattery3"] = "75AhBattery" }
def.carBatteries = { ["Base.CarBattery1"] = 50, ["Base.CarBattery2"] = 100, ["Base.CarBattery3"] = 75 }
function Recipe.GetItemTypes.wireCarBattery(scriptItems)
	for type,_ in pairs(def.carBatteries) do
		scriptItems:add(getScriptManager():getItem(type))
	end
end

function Recipe.OnCreate.ISA_wireCarBattery(items, result, player)
	local carBattery = items:get(2)
	local type = carBattery:getFullType()
	local resultData = result:getModData()
	resultData.ISAMaxCapacityAh = def.carBatteries[type]
	resultData.unwiredType = type
	if carBattery:hasModData() then
		resultData.unwiredData = carBattery:getModData()
	end
	--result:setName(getText("ItemName_ISA.DIYBattery"))
	result:setUsedDelta(carBattery:getUsedDelta())
	result:setCondition(carBattery:getCondition()-ZombRand((11-player:getPerkLevel(Perks.Electricity))/2))
end

function Recipe.OnCreate.ISA_unwireCarBattery(items, result, player)
	local wiredBattery = items:get(1)
	local oldData = wiredBattery:getModData()
	local type = oldData.unwiredType or "CarBattery1"
	local item = InventoryItemFactory.CreateItem(type)
	item:setUsedDelta(items:get(1):getUsedDelta())
	item:setCondition(items:get(1):getCondition()-ZombRand(11-player:getPerkLevel(Perks.Electricity)))
	if oldData.unwiredData then
		local itemData = item:getModData()
		for i,v in pairs(oldData.unwiredData) do
			itemData[i] = v
		end
	end
	addOrDrop(player,item)
end

function Recipe.OnCreate.ISA_ReverseSolarPanel(items, result, player)
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

function Recipe.OnGiveXP.ISA_CreateBatteryBank(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 8)
	player:getXp():AddXP(Perks.MetalWelding, 2)
end

return def