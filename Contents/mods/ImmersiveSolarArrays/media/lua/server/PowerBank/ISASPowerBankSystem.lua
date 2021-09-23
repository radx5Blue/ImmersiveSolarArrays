if isClient() then return end

require "Map/SGlobalObjectSystem"

SPowerBankSystem = SGlobalObjectSystem:derive("SPowerBankSystem")

function SPowerBankSystem:new()
	local o = SGlobalObjectSystem.new(self, "powerbank")
	return o
end

function SPowerBankSystem:initSystem()
	SGlobalObjectSystem.initSystem(self)

	-- Specify GlobalObjectSystem fields that should be saved.
	self.system:setModDataKeys({})
	
	-- Specify GlobalObject fields that should be saved.
	self.system:setObjectModDataKeys({'exterior', 'powerGenerated', 'powerConsumption', 'powerAmount', 'powerMax', 'hasBackup'}) -- Might need more?

	self:convertOldModData() -- probably not needed
end

function SPowerBankSystem:newLuaObject(globalObject)
	return SPowerBankGlobalObject:new(self, globalObject) -- create obbject
end

function SPowerBankSystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "Power Bank" -- create object in world I think
end

function SPowerBankSystem:convertOldModData() -- probably not needed
	-- If the gos_xxx.bin file existed, don't touch GameTime modData in case mods are using it.
	if self.system:loadedWorldVersion() ~= -1 then return end
	
--	local modData = GameTime:getInstance():getModData()
end

-- function SRainBarrelSystem:checkRain()
	-- if not RainManager.isRaining() then return end
	-- for i=1,self:getLuaObjectCount() do
		-- local luaObject = self:getLuaObjectByIndex(i)
		-- if luaObject.waterAmount < luaObject.waterMax then
			-- local square = luaObject:getSquare()
			-- if square then
				-- luaObject.exterior = square:isOutside()
			-- end
			-- if luaObject.exterior then
				-- luaObject.waterAmount = math.min(luaObject.waterMax, luaObject.waterAmount + 1 * RainCollectorBarrel.waterScale)
				-- luaObject.taintedWater = true
				-- local isoObject = luaObject:getIsoObject()
				-- if isoObject then -- object might have been destroyed
					-- self:noise('added rain to barrel at '..luaObject.x..","..luaObject.y..","..luaObject.z..' waterAmount='..luaObject.waterAmount)
					-- isoObject:setTaintedWater(true)
					-- isoObject:setWaterAmount(luaObject.waterAmount)
					-- isoObject:transmitModData()
				-- end
			-- end
		-- end
	-- end
-- end 

-- For rain ^ won't need whole block, maybe handy for later if we want rain to effect panels/bank
-- Also need for detecting I think

SGlobalObjectSystem.RegisterSystemClass(SPowerBankSystem)

local noise = function(msg)
	SPowerBankSystem.instance:noise(msg)
end

-- every 10 minutes we check if something? like solar panels or w/e
local function EveryTenMinutes()
	--SPowerBankSystem.instance:checkRain()
end

-- local function OnWaterAmountChange(object, prevAmount)
	-- if not object then return end
	-- local luaObject = SPowerBankSystem.instance:getLuaObjectAt(object:getX(), object:getY(), object:getZ())
	-- if luaObject then
		-- noise('waterAmount changed to '..object:getWaterAmount()..' tainted='..tostring(object:isTaintedWater())..' at '..luaObject.x..','..luaObject.y..','..luaObject.z)
		-- luaObject.waterAmount = object:getWaterAmount()
		-- luaObject.taintedWater = object:isTaintedWater()
		-- luaObject:changeSprite(object)
	-- end
-- end

-- not needed, but we will need to build something like this for power


-- every 10 minutes we check if it's raining, to fill our water barrel
Events.EveryTenMinutes.Add(EveryTenMinutes)

--Events.OnWaterAmountChange.Add(OnWaterAmountChange) -- add our custom event here onPowerChange
