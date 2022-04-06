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
	local index = 2
	local lua = SPowerbankSystem.instance:getLuaObjectByIndex(index)
	--local isopb = lua:getIsoObject()


	printData(index)

end

zx.testthat = function()

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
