function HandleBatteries(container, powerpercentage)
--percentage from 0 to 1 to set battery charge
local capacity = 0
for i=1,container:getItems():size() do 
local item = container:getItems():get(i-1)
local type = item:getType()
			if type == "50AhBattery" then
			capacity = capacity + 50
			item:setUsedDelta(powerpercentage)
			end
			if type == "75AhBattery" then
			capacity = capacity + 75
			item:setUsedDelta(powerpercentage)
			end
			if type == "100AhBattery" then
			capacity = capacity + 100
			item:setUsedDelta(powerpercentage)
			end
			if type == "DeepCycleBattery" then
			capacity = capacity + 200
			item:setUsedDelta(powerpercentage)
			end
end
return capacity
end

function DegradeBatteries(container)
for i=1,container:getItems():size() do 
local item = container:getItems():get(i-1)
local type = item:getType()
			if type == "50AhBattery" then
			item:setCondition(item:getCondition() - ZombRand(9)+1)
			--breaks in 20 days
			end
			if type == "75AhBattery" then
			item:setCondition(item:getCondition() - ZombRand(8)+1)
			--breaks in 25 days
			end
			if type == "100AhBattery" then
			item:setCondition(item:getCondition() - ZombRand(6)+1)
			--breaks in 33 days 
			end
			if type == "DeepCycleBattery" then
			item:setCondition(item:getCondition() - (ZombRand(59)+1) / 1000 )
			--breaks in 9+ years
			end
end
end