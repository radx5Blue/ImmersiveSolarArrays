-- These are the default options.
local OPTIONS = {
	LiteMode = false,
}

if ModOptions and ModOptions.getInstance then
  local settings = ModOptions:getInstance(OPTIONS, "ISA", "Immersive Solar Arrays")
  
  ModOptions:loadFile()
  
  
  local opt1 = settings:getData("LiteMode")

  function opt1:OnApplyInGame(val)
    print('Option is updated!', self.id, val)
	
	local liteModeOptions = {}
	
	liteModeOptions = ModData.get("PBLiteMode")
	
	if val == false then
	liteModeOptions[1] = 0
	OPTIONS.LiteMode = false
	end
	
	if val == true then
	liteModeOptions[1] = 1
	OPTIONS.LiteMode = true
	end
	
	print("liteModeOptions: ", liteModeOptions[1])

	
	
  end

end



Events.OnGameStart.Add(function()
  print("checkbox1 = ", OPTIONS.LiteMode)
  
   if ModData.exists("PBLiteMode") == true then
  
  	local liteModeOptions = {}
	
	liteModeOptions = ModData.get("PBLiteMode")
	
	if liteModeOptions[1] ~= nil then
	
	
	if OPTIONS.LiteMode == false then
	liteModeOptions[1] = 0
	OPTIONS.LiteMode = false
	end
	
	if OPTIONS.LiteMode == true then
	liteModeOptions[1] = 1
	OPTIONS.LiteMode = true
	end
	
end

end
  

end)