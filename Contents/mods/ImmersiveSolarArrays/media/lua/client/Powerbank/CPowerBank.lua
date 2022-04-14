require "Map/CGlobalObject"

CPowerbank = CGlobalObject:derive("CPowerbank")

function CPowerbank:new(luaSystem, globalObject)
    return CGlobalObject.new(self, luaSystem, globalObject)
end