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
					if InitialScan == true and backupgenerator == 0 then
						powerconsumption = powerconsumption + ConsumptionScan(mysquare)
						if ISAScan.squareHasPanel(mysquare) then
							numberofpanels = numberofpanels + 1
						end
					end
					if InitialScan == false and backupgenerator == 0 then
						powerconsumption = powerconsumption + ConsumptionScan(mysquare)
					end
				end
				
				--if IsBank == false and backupgenerator == 0 then
				--scan coming from solar panel
				--		if ISMoveableSpriteProps:findOnSquare(mysquare, "solarmod_tileset_01_0") then
				--			local scan = solarscan(mysquare, true, true, false, 0)
				--			changePanelData(mysquare, scan)
				--		end
				--end
				if LimitedScan == true and backupgenerator == 0 then
					if ISAScan.squareHasPanel(mysquare) then
						numberofpanels = numberofpanels + 1
					end
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
				if IsBank == true and backupgenerator == 0 then
					--scan coming from power bank
					if InitialScan == true then
						return powerconsumption, numberofpanels
					end
					if InitialScan == false and LimitedScan == false then
			
					return powerconsumption

					end
				end
				if LimitedScan == true and backupgenerator == 0 then
					return numberofpanels
				end
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
									powerconsumption = powerconsumption + 0.017
									--print("found tv")
								end
							end					
						end 
						if instanceof(myObject, "IsoRadio") then
							if myObject:getDeviceData() ~= nil then
								if myObject:getDeviceData():getIsTurnedOn() then
									powerconsumption = powerconsumption + 0.005
									--print("found radio")
								end
							end					
						end 
						
						--print("is this running3")
					if instanceof(myObject, "IsoStove") and myObject:Activated() then
						powerconsumption = powerconsumption + 0.13
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
