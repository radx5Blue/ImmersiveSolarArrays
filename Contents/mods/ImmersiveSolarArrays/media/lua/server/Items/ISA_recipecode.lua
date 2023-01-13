require "Items/AcceptItemFunction"
require "recipecode"
local isa = require("ISAUtilities")

local RecipeDef = {}

local function addOrDrop(character, item)
	local inv = character:getInventory()
	if inv:getCapacityWeight() + item:getWeight() < inv:getEffectiveCapacity(character) then
		inv:AddItem(item)
	else
		character:getCurrentSquare():AddWorldInventoryItem(item,
			character:getX() %1,
			character:getY() %1,
			character:getZ() %1)
			--character:getX() - math.floor(character:getX()),
			--character:getY() - math.floor(character:getY()),
			--character:getZ() - math.floor(character:getZ()))
	end
end

--just a minor adjustment
local function roundCapacity(x)
	--return x
	--return math.floor(x/2 + 0.5) * 2
	return math.ceil(x/5 - 0.5) * 5
end

AcceptItemFunction.ISA_Batteries = function(container,item)
	if item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()] then return true end
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


--Recipe.convertBatteries = { ["Base.CarBattery1"] = "50AhBattery", ["Base.CarBattery2"] = "100AhBattery", ["Base.CarBattery3"] = "75AhBattery" }
RecipeDef.carBatteries = { ["Base.CarBattery1"] = { ah = 50, degrade = 10 }, ["Base.CarBattery2"] = { ah = 100, degrade = 6 }, ["Base.CarBattery3"] = { ah = 75, degrade = 8 } }
function Recipe.GetItemTypes.wireCarBattery(scriptItems)
	local manager = getScriptManager()
	for type,_ in pairs(RecipeDef.carBatteries) do
		scriptItems:add(manager:getItem(type))
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
			local qualityMod = math.min(12, ZombRand(8,12) + skillMod / 3) / 10
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

--todo result condition formula (average vs mix vs 100), maxCapacity formula (sum of max vs sum of current)
function Recipe.OnCreate.ISA_createDiyBattery(items, result, player)
	--local addUpDelta = 0
	local sourceItems = 0
	local resultCondition = 0
	local resultCapacity = 0
	for i=0, items:size()-1 do
		local item = items:get(i)
		local maxCapacity = item:getModData().ISA_maxCapacity or isa.maxBatteryCapacity[item:getType()]
		if maxCapacity then
			--addUpDelta = addUpDelta + item:getUsedDelta()
			sourceItems = sourceItems + 1
			resultCapacity = resultCapacity + maxCapacity
			resultCondition = resultCondition + item:getCondition()
		end
	end

	local resultData = result:getModData()
	resultData.ISA_maxCapacity = roundCapacity(resultCapacity * SandboxVars.ISA.DIYBatteryCapacity / 200)

	result:setUsedDelta(0)
	--result:setUsedDelta(addUpDelta / tick)
	result:setCondition(math.floor(resultCondition / sourceItems))
end

--function Recipe.OnCreate.SolarModConvertBatteryDIY(items, result, player)
--	local addUpDelta = 0
--	local addUpCond = 0
--	local tick = 0
--	for i=0, items:size()-1 do
--		if(items:get(i):getType() == "50AhBattery" or items:get(i):getType() == "75AhBattery" or items:get(i):getType() == "100AhBattery") then
--			local item = items:get(i)
--			addUpDelta = addUpDelta + item:getUsedDelta()
--			addUpCond = addUpCond + item:getCondition()
--			tick = tick + 1
--		end
--	end
--	result:setUsedDelta(addUpDelta / tick)
--	result:setCondition(addUpCond / tick)
--end

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