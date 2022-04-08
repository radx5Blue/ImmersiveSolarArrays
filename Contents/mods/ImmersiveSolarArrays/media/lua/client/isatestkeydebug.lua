zx = zx or {}

local function printData(index)
	local lua = SPowerbankSystem.instance:getLuaObjectByIndex(index)
	for i,v in pairs(lua) do
		print(i,"/",v)
	end
	print("Panel Data:")
	for i,v in ipairs(lua.panels) do
		print(v.x,v.y,v.z)
	end
	if lua.conGenerator then print("con Generator is on: ",lua.conGenerator.ison) end
end

zx.testthis = function()
	--local index = 2
	--local lua = SPowerbankSystem.instance:getLuaObjectByIndex(index)
	--local isopb = lua:getIsoObject()

	ModData.get("ISAWorldSpawns")[4085 .. "," .. 11290 .. "," .. 0] = "solarmod_tileset_01_36"

	--printData(index)
end

zx.testthat = function()
	--local square = getWorld():getCell():getOrCreateGridSquare(10254,8762,1)
	--local isoObject = IsoObject.new(square:getCell(), square, "solarmod_tileset_01_10")
	--print(isoObject)
	--square:getObjects():add(isoObject)
	--()
	--local player = getPlayer()
	--player:setX(4135)
	--player:setY(11313
	local def = getWorld():getMetaGrid():getBuildingAt(4135,11313)
	getWorld():getMetaGrid():getCellData(math.floor(4135/300),math.floor(11313/300)):addTrigger(def,1,0,"ISA")
end

function zx.keydebug(keynum)
	-- print(keynum)
	if keynum == 44 then
		print("test this!")
		return zx.testthis()
	elseif keynum == 45 then
		print("test that")
		return zx.testthat()
	end
end
--Events.OnKeyPressed.Add(zx.keydebug)
