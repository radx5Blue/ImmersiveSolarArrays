zx = zx or {}


zx.testthis = function()
	local index = 1
	local lua = SPowerbankSystem.instance:getLuaObjectByIndex(index)
	local global = CPowerbankSystem.instance.system:getObjectByIndex(index-1)
	--CPowerbankSystem.instance.system:removeObject(global)
	--local global = SPowerbankSystem.instance.system:getObjectByIndex(0)
	--SPowerbankSystem.instance.system:removeObject(global)
	--local isopb = lua:getIsoObject()
	--local data = isopb:getModData()
	--lua:initNew()
	--lua:saveData()



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
Events.OnKeyPressed.Add(zx.keydebug)