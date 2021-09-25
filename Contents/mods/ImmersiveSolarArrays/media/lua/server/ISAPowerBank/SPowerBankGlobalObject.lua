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

function SPowerBankGlobalObject:fromModData(modData)
    self.exterior = modData["exterior"];
    self.powerGenerated = modData["powerGenerated"];
    self.powerConsumption = modData["powerConsumption"];
    self.powerAmount = modData["powerAmount"];
    self.powerMax  = modData["powerMax"];
    self.hasBackUp = modData["hasBackUp"];
end

function SPowerBankGlobalObject:toModData(modData)
    modData["exterior"] = self.exterior;
    modData["powerGenerated"] = self.powerGenerated;
    modData["powerConsumption"] = self.powerConsumption;
    modData["powerAmount"] = self.powerAmount;
    modData["powerMax"] = self.powerMax;
    modData["hasBackUp"] = self.hasBackUp;
end

-- PowerBank = {};

-- --Lists of powerbanks in the world
-- PowerBank.listOfBanks = {};


-- function SPowerBankGlobalObject:initNew()
	-- self.exterior = false
	-- self.powerGenerated = 0
	-- self.powerConsumption = 0	
	-- self.powerAmount = 0
	-- self.powerMax = 0	
	-- self.hasBackUp = false
-- end

--grabbing specific mod data:
--local switchState = getPlayer():getModData().switch
--  or              getPlayer():getModData()["switch"]

-- setting mod data:
--getPlayer():getModData().switch = false -- or true
--getPlayer():setModData()
-- or maybe getPlayer():transmitModData()
-- unsure on which would be correct, ideally trial and error
-- as it's just how i'd try it for now after seeing the uses in the base lua file for a bit