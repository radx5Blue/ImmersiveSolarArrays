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



result:setUsedDelta(charge);
result:setCondition(condition);

--unsure whether to use get() here, will have to test.
end