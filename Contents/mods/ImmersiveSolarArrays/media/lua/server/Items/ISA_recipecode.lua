require "Items/AcceptItemFunction"
require "recipecode"
local isa = require("ISAUtilities")

local RecipeDef = {}

--ISCraftAction:addOrDropItem
local function addOrDrop(character, item)
	local inv = character:getInventory()
	if inv:getCapacityWeight() + item:getWeight() < inv:getEffectiveCapacity(character) then
		inv:AddItem(item)
	else
		character:getCurrentSquare():AddWorldInventoryItem(item,
			character:getX() %1,
			character:getY() %1,
			character:getZ() %1)
	end
end

local function roundCapacity(x)
	return math.ceil(x / 5 - 0.5) * 5
end

AcceptItemFunction.ISA_Batteries = function(container,item)
	if item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()] then return true end
	return false
end

RecipeDef.carBatteries = { ["Base.CarBattery1"] = { ah = 50, degrade = 10 }, ["Base.CarBattery2"] = { ah = 100, degrade = 6 }, ["Base.CarBattery3"] = { ah = 75, degrade = 8 } }
function Recipe.GetItemTypes.wireCarBattery(scriptItems)
	local manager = getScriptManager()
	for fullType,_ in pairs(RecipeDef.carBatteries) do
		scriptItems:add(manager:getItem(fullType))
	end
end

function Recipe.OnCreate.ISA_wireCarBattery(items, result, player)
	for i=items:size()-1,0,-1 do
		local carBattery = items:get(i)
		local fullType = carBattery:getFullType()
		local batteryInfo = RecipeDef.carBatteries[fullType]
		if batteryInfo then
			local resultData = result:getModData()
			resultData.unwiredType = fullType
			if carBattery:hasModData() then
				resultData.unwiredData = carBattery:getModData() --works in test
				--resultData.unwiredData = copyTable(carBattery:getModData())
			end

			local skillMod = math.min(10, ZombRand(1 + player:getPerkLevel(Perks.Electricity)))

			local qualityMod = math.min(11, ZombRand(9,11) + skillMod / 4) / 10
			--local qualityMod = math.min(12, ZombRand(8,12) + skillMod / 3) / 10

			resultData.ISA_maxCapacity = roundCapacity(batteryInfo.ah * qualityMod)
			resultData.ISA_BatteryDegrade = batteryInfo.degrade / qualityMod
			result:setUsedDelta(0)
			--result:setUsedDelta(carBattery:getUsedDelta())
			result:setCondition(carBattery:getCondition() - ZombRand(1,12 - skillMod))

			break
		end
	end
end

function Recipe.OnCreate.ISA_unwireCarBattery(items, result, player)
	for i=items:size()-1,0,-1 do
		local wiredBattery = items:get(i)
		if wiredBattery:getType() == "WiredCarBattery" then
			local oldData = wiredBattery:getModData()
			local fullType = oldData.unwiredType or "CarBattery1"
			local item = InventoryItemFactory.CreateItem(fullType)
			if oldData.unwiredData then
				local newData = item:getModData()
				for k,v in pairs(oldData.unwiredData) do
					newData[k] = v
				end
			end
			local skillMod = math.min(10, ZombRand(1 + player:getPerkLevel(Perks.Electricity)))

			item:setUsedDelta(0)
			--item:setUsedDelta(wiredBattery:getUsedDelta())
			item:setCondition(wiredBattery:getCondition() - ZombRand(1,12 - skillMod))
			addOrDrop(player,item)

			break
		end
	end
end

--todo result condition formula (average vs mix vs 100), maxCapacity formula (sum of max vs sum of current), v42 when?
function Recipe.OnCreate.ISA_createDiyBattery(items, result, player)
	--local addUpDelta = 0
	local sourceItems = 0
	local sumCondition = 0
	local sumCapacity = 0
	for i=0, items:size()-1 do
		local item = items:get(i)
		local maxCapacity = item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()]
		if maxCapacity then
			--addUpDelta = addUpDelta + item:getUsedDelta()
			sourceItems = sourceItems + 1
			sumCapacity = sumCapacity + maxCapacity
			sumCondition = sumCondition + item:getCondition()
		end
	end

	local resultData = result:getModData()
	resultData.ISA_maxCapacity = roundCapacity(sumCapacity * SandboxVars.ISA.DIYBatteryMultiplier)

	result:setUsedDelta(0)
	--result:setUsedDelta(addUpDelta / tick)
	result:setCondition(math.floor(sumCondition / sourceItems))
end

--assumes panel is i = 1
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

function Recipe.OnGiveXP.ISA_minorElectricalXP(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 0.4)
end

function Recipe.OnGiveXP.ISA_CreateBatteryBank(recipe, ingredients, result, player)
	player:getXp():AddXP(Perks.Electricity, 8)
	player:getXp():AddXP(Perks.MetalWelding, 2)
end

return RecipeDef