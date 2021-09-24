if isClient() then return end

require "Map/SGlobalObject"

SPowerBankGlobalObject = SGlobalObject:derive("SPowerBankGlobalObject")

function SPowerBankGlobalObject:new(luaSystem, globalObject)
	local o = SGlobalObject.new(self, luaSystem, globalObject)
	return o
end

function SPowerBankGlobalObject:initNew()
	self.exterior = false
	self.powerGenerated = 0
	self.powerConsumption = 0	
	self.powerAmount = 0
	self.powerMax = 0	
	self.hasBackUp = false
end


function SPowerBankGlobalObject:stateFromIsoObject(isoObject) -- getting info from client
	--self.exterior = isoObject:getSquare():isOutside()
	--self.taintedWater = isoObject:isTaintedWater()
	--self.waterAmount = isoObject:getWaterAmount()
	--self.waterMax = isoObject:getModData().waterMax
	
	self.exterior = isoObject:getSquare():isOutside() -- getting this from here https://projectzomboid.com/modding/zombie/iso/IsoObject.html
	self.powerGenerated = 0 -- will need to grab this info from our functions instead of isoObject
	self.powerConsumption = 0	-- will need to grab this info from our functions instead of isoObject
	self.powerAmount = 0 -- will need to grab this info from our functions instead of isoObject
	self.powerMax = 0	 -- will need to grab this info from our functions instead of isoObject
	self.hasBackUp = false -- will need to grab this info from our functions instead of isoObject

	-- Sanity check - will need to create our own
	-- if not self.waterMax then
		-- local spriteName = isoObject:getSprite() and isoObject:getSprite():getName()
		-- if spriteName == "carpentry_02_54" or spriteName == "carpentry_02_55" then
			-- self.waterMax = RainCollectorBarrel.smallWaterMax
		-- elseif spriteName == "carpentry_02_52" or spriteName == "carpentry_02_53" then
			-- self.waterMax = RainCollectorBarrel.largeWaterMax
		-- else
			-- self.waterMax = RainCollectorBarrel.smallWaterMax
		-- end
	-- end

	-- ISTakeWaterAction was fixed to consider storage capacity of water containers.
	-- Update old rainbarrels with 40/100 capacity to 160/400 capacity.
	--if self.waterMax == 40 then self.waterMax = RainCollectorBarrel.smallWaterMax end 
	--if self.waterMax == 100 then self.waterMax = RainCollectorBarrel.largeWaterMax end

	isoObject:getModData().powerMax = self.powerMax -- probably need others here like powerAmount
	self:changeSprite() -- maybe we can make a little power indicator on the object sprite when it is 25,50,75,100 full
	isoObject:transmitModData()
end

function SPowerBankGlobalObject:stateToIsoObject(isoObject) -- sending info to client
	-- Sanity check
	if not self.powerAmount then
		self.powerAmount = 0
	end
	
	spriteName = "solarmod_tileset_01_0"
	
	--if not self.waterMax then
	--	local spriteName = isoObject:getSprite() and isoObject:getSprite():getName()
		--if spriteName == "carpentry_02_54" or spriteName == "carpentry_02_55" then
		--	self.waterMax = RainCollectorBarrel.smallWaterMax
		--elseif spriteName == "carpentry_02_52" or spriteName == "carpentry_02_53" then
		--	self.waterMax = RainCollectorBarrel.largeWaterMax
		--else
		--	self.waterMax = RainCollectorBarrel.smallWaterMax
		--end
	--end

	-- ISTakeWaterAction was fixed to consider storage capacity of water containers.
	-- Update old rainbarrels with 40/100 capacity to 160/400 capacity.
	--if self.waterMax == 40 then self.waterMax = RainCollectorBarrel.smallWaterMax end
	--if self.waterMax == 100 then self.waterMax = RainCollectorBarrel.largeWaterMax end

	self.exterior = isoObject:getSquare():isOutside()

	--if not self.taintedWater then
	--	self.taintedWater = self.waterAmount > 0 and self.exterior
	--end
	--isoObject:setTaintedWater(self.taintedWater)

	--isoObject:setWaterAmount(self.waterAmount) -- FIXME? OnWaterAmountChanged happens here
	--isoObject:getModData().waterMax = self.waterMax
	self:changeSprite()
	isoObject:transmitModData()
end

function SPowerBankGlobalObject:changeSprite() -- changing sprite based on amount, this could work with power too I suppose, like it not enough battery power, the power turns off
	local isoObject = self:getIsoObject()
	if not isoObject then return end
	
	spriteName = "solarmod_tileset_01_0"
	
	-- local spriteName = nil
		-- if self.powerAmount >= self.powerMax * 1 then
			-- spriteName = "solarmod_tileset_01_14" -- need real name here
		-- elseif self.powerAmount >= self.powerMax * 0.75 then
			-- spriteName = "solarmod_tileset_01_13" -- need real name here
		-- elseif self.powerAmount >= self.powerMax * 0.50 then
			-- spriteName = "solarmod_tileset_01_12" -- need real name here
		-- elseif self.powerAmount >= self.powerMax * 0.25 then
			-- spriteName = "solarmod_tileset_01_11" -- need real name here
		-- elseif self.powerAmount == self.powerMax * 0 then
			-- spriteName = "solarmod_tileset_01_10" -- need real name here
		-- end

	if spriteName and (not isoObject:getSprite() or spriteName ~= isoObject:getSprite():getName()) then
		self:noise('sprite changed to '..spriteName..' at '..self.x..','..self.y..','..self.z)
		isoObject:setSprite(spriteName)
		isoObject:transmitUpdatedSpriteToClients()
	end
end

