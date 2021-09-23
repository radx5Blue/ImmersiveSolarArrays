require "Map/CGlobalObject"

ISACPowerBankGlobalObject = CGlobalObject:derive("ISACPowerBankGlobalObject")

function ISACPowerBankGlobalObject:new(luaSystem, globalObject)
	local o = CGlobalObject.new(self, luaSystem, globalObject)
	return o
end

function ISACPowerBankGlobalObject:getObject()
	return self:getIsoObject()
end
