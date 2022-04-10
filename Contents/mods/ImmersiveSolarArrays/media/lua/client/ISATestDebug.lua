zx = zx or {}

function zx.printData(index)
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

function zx.spawnSpriteNearMe(x,y,z,n)
	local player = getPlayer()
	zx.x = math.floor(player:getX())
	zx.y = math.floor(player:getY())
	zx.z = math.floor(player:getZ())
	local square = getSquare(zx.x+x, zx.y+y, zx.z+z)
	local sprite = "solarmod_tileset_01_"..n
	if square then ISAWorldSpawns.Place(square,sprite) else print("no square") end
end

zx.testthis = function()
	--local index = 2
	--local lua = SPowerbankSystem.instance:getLuaObjectByIndex(index)
	--local isopb = lua:getIsoObject()

	--ModData.get("ISAWorldSpawns")[4085 .. "," .. 11290 .. "," .. 0] = "solarmod_tileset_01_36"
	local square = getSquare(zx.x, zx.y, zx.z+1)
	ISAWorldSpawns.Place(square,"solarmod_tileset_01_36")

	--zx.printData(index)
end

zx.testthat = function()
	local player = getPlayer()
	zx.x = math.floor(player:getX())
	zx.y = math.floor(player:getY())
	zx.z = math.floor(player:getZ())
	--print(zx.x,zx.y,zx.z)
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
