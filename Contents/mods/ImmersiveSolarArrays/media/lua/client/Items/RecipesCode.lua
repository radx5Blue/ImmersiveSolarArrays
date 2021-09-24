function SolarModConvertBattery(items, result, player)
--this function makes sure charge and condition remain the same when converting a car battery for solar use

local condition = 0;
local charge = 0;
for i=0, items:size()-1 do
            if(items:get(i):getType() == "Base.CarBattery1" or items:get(i):getType() == "Base.CarBattery2" or items:get(i):getType() == "Base.CarBattery3") then
			condition = items:get(i):getCondition();
			charge = items:get(i):getUsedDelta();
			end
end



result:get(0):setUsedDelta(charge);
result:get(0):setCondition(condition);
end

function SolarModConvertBatteryReverse(items, result, player)
--this function makes sure charge and condition remain the same when converting a battery back for car use

local condition = 0;
local charge = 0;
for i=0, items:size()-1 do
            if(items:get(i):getType() == "ISA.50AhBattery" or items:get(i):getType() == "ISA.75AhBattery" or items:get(i):getType() == "ISA.100AhBattery") then
			condition = items:get(i):getCondition() - 0.25; --make it worse 
			charge = items:get(i):getUsedDelta();
			end
end



result:get(0):setUsedDelta(charge);
result:get(0):setCondition(condition);
end