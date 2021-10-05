ISMoveableSpriteProps.originalPlaceMoveableFunction = ISMoveableSpriteProps.placeMoveable -- we save the original function so we can run it as well as our code
function ISMoveableSpriteProps:placeMoveable( _character, _square, _origSpriteName ) -- we override the original function so our code runs whenever this runs.
  -- depending on when you want to do something, either run the original now, or after your code. In this example original is ran first
  local res = self:originalPlaceMoveableFunction(_character, _square, _origSpriteName) -- you may have to actually pass the parameters directly instead of self. Unsure here as i didn't test it, but one of the two should work
  if res == nil and self.isMoveable then
    -- Your stuff here example below
    if _origSpriteName == "solarmod_tileset_01_0" then
      _character:Say("Cool, a battery bank! Is it shiny?")
	  solarscan(_square, false, true, true, 0)
	  
	  
	
	
	  

	  
	  
    end
	if _origSpriteName == "solarmod_tileset_01_6" or _origSpriteName == "solarmod_tileset_01_7" or _origSpriteName == "solarmod_tileset_01_8" or _origSpriteName == "solarmod_tileset_01_9" or _origSpriteName == "solarmod_tileset_01_10" then  
	   _character:Say("AAAAAA! Shiny solar panels")
	   solarscan(_square, false, false, false, 0)
	   
	end
	
  else
    return res
  end
end


ISMoveableSpriteProps.originalpickUpMoveableFunction = ISMoveableSpriteProps.pickUpMoveable

function ISMoveableSpriteProps:pickUpMoveable( _character, _square, _createItem, _forceAllow) -- we override the original function so our code runs whenever this runs.
  -- depending on when you want to do something, either run the original now, or after your code. In this example original is ran first
  local res = self:originalpickUpMoveableFunction( _character, _square, _createItem, _forceAllow ) -- you may have to actually pass the parameters directly instead of self. Unsure here as i didn't test it, but one of the two should work
	if res ~= nil and self.isMoveable then
	-- local item = self.spriteName;
    -- Your stuff here example below
	local _spriteName = self.spriteName
    if _spriteName == "solarmod_tileset_01_0" then
      _character:Say("oo, heavy")
		--TODO: battery bank data for the removed bank should be deleted here
		DisconnectPower(_square)

    end
	if _spriteName == "solarmod_tileset_01_6" or _spriteName == "solarmod_tileset_01_7" or _spriteName == "solarmod_tileset_01_8" or _spriteName == "solarmod_tileset_01_9" or _spriteName == "solarmod_tileset_01_10" then  
	   _character:Say("must not trip over, must not trip over")
	   solarscan(_square, false, false, false, 0)
	end
	
  else
    return res
  end
end

function solarscan(square, LimitedScan, IsBank, InitialScan, backupgenerator)
----print("running solar scan")
--square is the square of the solar panel, increment, limitedscan is if we should only scan for panels not do anything else, IsBank: false if scan is coming from solar panel, true if coming from a battery bank, initial scan true when object first placed
--backupgenerator is normally 0, 1 wehn turning on a generator and 2 when turning off one
local n = square:getX() - 20;
local n2 = square:getX() + 20;
local n3 = square:getY() - 20;
local n4 = square:getY() + 20;
local bottom = math.max(0, square:getZ() - 3);
local top = math.min(8, square:getZ() + 3);
local powerconsumption = 0;
local numberofpanels = 0;
for x = bottom, top do
	for j = n, n2 do
		for k = n3, n4 do
			if IsoUtils.DistanceToSquared(j + 0.5, k + 0.5, square:getX() + 0.5, square:getY() + 0.5) <= 400.0 then
			local mysquare = square:getCell():getGridSquare(j, k, x);
				if mysquare ~= nil then			
				if IsBank == true then
					--scan coming from power bank
					if InitialScan == true then
						powerconsumption = powerconsumption + ConsumptionScan(mysquare)
						numberofpanels = numberofpanels + PanelScan(mysquare)
					end
					if InitialScan == false then
						powerconsumption = powerconsumption + ConsumptionScan(mysquare)
					end
				end
				
				if IsBank == false then
				--scan coming from solar panel
						if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_0") then
							local scan = solarscan(mysquare, true, true, false, 0)
							addPanelData(mysquare, scan)
						end
				end
				if LimitedScan == true then
						numberofpanels = numberofpanels + PanelScan(mysquare)
					
				end
				if backupgenerator ~= 0 then
					if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_15") then
						if backupgenerator == 1 then
						--turn on generator in this square
							if mysquare:getObjects():size() ~= nil then
								for objs = 1, mysquare:getObjects():size() do
								local myObject = mysquare:getObjects():get(objs-1);
									if (myObject ~= nil) then
										if instanceof(myObject, "IsoGenerator") then
											myObject:setActivated(true)  
											powerconsumption = 0
										end 
									end
								end
							end
						--
						end
						if backupgenerator == 2 then
						--turn off generator in this square
							if mysquare:getObjects():size() ~= nil then
								for objs = 1, mysquare:getObjects():size() do
								local myObject = mysquare:getObjects():get(objs-1);
									if (myObject ~= nil) then
										if instanceof(myObject, "IsoGenerator") then
											myObject:setActivated(false)           
										end 
									end
								end
							end
						--
						end
					end
				
				end
			end


			end
		end
	end	
end
--------ALL power bank ACTION GO BELOW
				if IsBank == true then
					--scan coming from power bank
					if InitialScan == true then
						TurnOnPower(powerconsumption, numberofpanels, square, true)
					end
					if InitialScan == false and LimitedScan == false then
			
					return powerconsumption

					end
				end
				if LimitedScan == true then
					return numberofpanels
				end
end

function PanelScan(mysquare)
local numberofpanels = 0
					if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_8") then
				     --this is a flat solar panel, add to count
						numberofpanels = numberofpanels + 1
						--print("panel found")
					end
					if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_6") or ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_7") then
				     --this is a flat solar panel, add to count
						numberofpanels = numberofpanels + 1
						--print("panel found")
					end
					if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_9") or ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_10") then
				     --this is a flat solar panel, add to count
						numberofpanels = numberofpanels + 1
						--print("panel found")
					end
return numberofpanels
end

function ConsumptionScan(square)
--print("running consumption scan")
--calculates the power consumption of appliances within a square
	local powerconsumption = 0;
		if square:getObjects():size() ~= nil then
		--print("square has objects")
		for objs = 1, square:getObjects():size() do
			local myObject = square:getObjects():get(objs-1);
				if (myObject ~= nil) then
					--print("object not nil")
					if instanceof(myObject, "IsoWorldInventoryObject") == false then
						--print("is this running1")
						
						if instanceof(myObject, "IsoTelevision") then
							if myObject:getDeviceData() ~= nil then
								if myObject:getDeviceData():getIsTurnedOn() then
									powerconsumption = powerconsumption + 0.01
									--print("found tv")
								end
							end					
						end 
						if instanceof(myObject, "IsoRadio") then
							if myObject:getDeviceData() ~= nil then
								if myObject:getDeviceData():getIsTurnedOn() then
									powerconsumption = powerconsumption + 0.01
									--print("found radio")
								end
							end					
						end 
						
						--print("is this running3")
					if instanceof(myObject, "IsoStove") and myObject:getContainer() and myObject:getContainer():isPowered() then
						powerconsumption = powerconsumption + 0.09
					end
						--print("is this running4")
						for containerIndex = 1,myObject:getContainerCount() do
							--print("scanning containers")
							local container = myObject:getContainerByIndex(containerIndex-1)
							if container:getType() == "fridge" then
								powerconsumption = powerconsumption + 0.05
								--print("found fridge")
							end
							if container:getType() == "freezer" then
								powerconsumption = powerconsumption + 0.08
								--print("found freezer")
							end
								
						end		
						--print("is this running5")
						if instanceof(myObject, "IsoLightSwitch") and myObject:isActivated() then
						powerconsumption = powerconsumption + 0.002
						--print("found light")
					end
				end
			end
		end
	end
	return powerconsumption	* 920				
end




-- pass powerconsumption to power bank
--power consumption of a freezer is around 350 watts
--power production of a 1x1 meter solar panels is around 1000 watts, maybe 750 in the 90's
--this should mean you can run a freezer continuously with one solar panel, given enough batteries
--batteries ah-range: standard 50Ah, Sport: 75Ah, Heavy-Duty 100Ah, deep cycle 200Ah
--you'd need around 1800Ah for the freezer assuming mixed battery types, 
--which means you'd need an almost fully upgraded battery bank using heavy-duty batteries
