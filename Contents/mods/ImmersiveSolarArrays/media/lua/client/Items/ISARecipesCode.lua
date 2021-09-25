function SolarModConvertBattery(items, result, player)
--this function makes sure charge and condition remain the same when converting a car battery for solar use

for i=0, items:size()-1 do
            if(items:get(i):getType() == "CarBattery1" or items:get(i):getType() == "CarBattery2" or items:get(i):getType() == "CarBattery3") then
			local item = items:get(i)
			result:setUsedDelta(item:getUsedDelta());
            result:setCondition(item:getCondition());
			end
end
 player:getXp():AddXP(Perks.Electricity, 1);
end

function SolarModConvertBatteryReverse(items, result, player)
--this function makes sure charge and condition remain the same when converting a battery back for car use

for i=0, items:size()-1 do
            if(items:get(i):getType() == "50AhBattery" or items:get(i):getType() == "75AhBattery" or items:get(i):getType() == "100AhBattery") then
			local item = items:get(i)
			result:setUsedDelta(item:getUsedDelta());
            result:setCondition(item:getCondition() - (25 - (player:getPerkLevel(Perks.Electricity)*2)));	--make it worse to prevent misuse
			end
end
end

function OnCanPerform.ISAElectricalIntermediate(recipe, playerObj)
return playerObj:getPerkLevel(Perks.Electricity) >= 3
end

function OnCanPerform.ISAElectricalAdvanced(recipe, playerObj)
return playerObj:getPerkLevel(Perks.Electricity) >= 5
end