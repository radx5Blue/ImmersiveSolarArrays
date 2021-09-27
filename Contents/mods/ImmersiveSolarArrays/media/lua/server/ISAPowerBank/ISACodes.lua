globalTest = false

function clearFile()
	
	 player = getPlayer()
				local t = {}
	
	            t.main = {}
                t.main.S = ""
                t.main.a = ""
                t.main.b = ""
                t.main.c = ""

                bcUtils.writeINI(
                    "Solar Gen" ..
                        getFileSeparator() .. player:getUsername() .. getFileSeparator() .. "SolarGen" .. ".ini",
                    t
                )
				
				--print("Solar Deleted")
	
	
	
end

function SolarModPlaceSolar(items, result, player)
    local t = {}

    if (player:isOutside()) then
        for i = 0, items:size() - 1 do
            if (items:get(i):getType() == "SolarModSolarPanels") then
                local NewGenerator = IsoGenerator.new(nil, player:getCell(), player:getCurrentSquare())
                NewGenerator:setConnected(true)
                NewGenerator:setFuel(100)
                NewGenerator:setCondition(100)
                NewGenerator:setActivated(true)
                NewGenerator:setSurroundingElectricity()
                NewGenerator:remove()
                player:getCurrentSquare():AddWorldInventoryItem("ISA.SolarModSolarPanels2", 0.5, 0.5, 0)

                t.main = {}
                t.main.S = "SolarGen"
                t.main.a = player:getX()
                t.main.b = player:getY()
                t.main.c = player:getZ()

                bcUtils.writeINI(
                    "Solar Gen" ..
                        getFileSeparator() .. player:getUsername() .. getFileSeparator() .. "SolarGen" .. ".ini",
                    t
                )
                globalTest = true

                break
            end
        end
    else
        player:Say("Need to place outside")
        player:getInventory():AddItem("ISA.SolarModSolarPanels")
    end
end

function SolarModRemoveSolar(items, result, player)

            local t =
                bcUtils.readINI(
                "Solar Gen" .. getFileSeparator() .. player:getUsername() .. getFileSeparator() .. "SolarGen" .. ".ini"
            )

            player = getPlayer()

            x = tonumber(t.main.a)
            y = tonumber(t.main.b)
            z = tonumber(t.main.c)

            local square = getWorld():getCell():getGridSquare(x, y, z)

            local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)

            --NewGenerator:setConnected(false)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:setActivated(false)
            NewGenerator:remove()
			
			
			--print("Before Clear")
			clearFile();
			globalTest = false


           
       
end

local function reloadSolar()
    player = getPlayer()

	

    t =
        bcUtils.readINI(
        "Solar Gen" .. getFileSeparator() .. player:getUsername() .. getFileSeparator() .. "SolarGen" .. ".ini"
    )
	
		if bcUtils.tableIsEmpty(t) == true then return end
	

    if globalTest == true or t.main.S == "SolarGen" then
        x = tonumber(t.main.a)
        y = tonumber(t.main.b)
        z = tonumber(t.main.c)

        if x ~= nil then
            local square = getWorld():getCell():getGridSquare(x, y, z)
            local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()
            globalTest = true
        end
    end
end

function SolarCheck()
    if globalTest == true then
        player = getPlayer()

        local t =
            bcUtils.readINI(
            "Solar Gen" .. getFileSeparator() .. player:getUsername() .. getFileSeparator() .. "SolarGen" .. ".ini"
        )
		
		if bcUtils.tableIsEmpty(t) == true then return end

        x = tonumber(t.main.a)
        y = tonumber(t.main.b)
        z = tonumber(t.main.c)

        check = 0

        local square = getWorld():getCell():getGridSquare(x, y, z)

        if (square ~= nil and check == 0) then
            local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
            NewGenerator:setConnected(false)
            NewGenerator:setFuel(0)
            NewGenerator:setCondition(0)
            NewGenerator:setActivated(false)
            NewGenerator:remove()

            local NewGenerator = IsoGenerator.new(nil, player:getCell(), square)
            NewGenerator:setConnected(true)
            NewGenerator:setFuel(100)
            NewGenerator:setCondition(100)
            NewGenerator:setActivated(true)
            NewGenerator:setSurroundingElectricity()
            NewGenerator:remove()

            check = 1
        elseif square == nil then
            check = 0
        end
    end
end

--And then add it to the OnGameStart event
Events.OnGameStart.Add(reloadSolar)

--And then add it to the OnTick event
Events.OnTick.Add(SolarCheck)
