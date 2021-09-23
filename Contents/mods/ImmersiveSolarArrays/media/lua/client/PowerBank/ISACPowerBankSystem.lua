require "Map/CGlobalObjectSystem"

ISACPowerBankSystem = CGlobalObjectSystem:derive("ISACPowerBankSystem")

function ISACPowerBankSystem:new()
	local o = CGlobalObjectSystem.new(self, "powerbank")
	return o
end

function ISACPowerBankSystem:isValidIsoObject(isoObject)
	return instanceof(isoObject, "IsoThumpable") and isoObject:getName() == "Power Bank"
end

function ISACPowerBankSystem:newLuaObject(globalObject)
	return ISACPowerBankGlobalObject:new(self, globalObject)
end

CGlobalObjectSystem.RegisterSystemClass(CRainBarrelSystem)


-- local function DoSpecialTooltip(tooltipUI, square) -- creates tooltip for amount of water in barrel
	-- local playerObj = getSpecificPlayer(0)
	-- if not playerObj or playerObj:getZ() ~= square:getZ() or
			-- playerObj:DistToSquared(square:getX() + 0.5, square:getY() + 0.5) > 2 * 2 then
		-- return
	-- end
	
	-- local barrel = CRainBarrelSystem.instance:getIsoObjectOnSquare(square)
	-- if not barrel or not barrel:getModData()["waterMax"] then return end

	-- local smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
	-- tooltipUI:setHeight(6 + smallFontHgt + 6 + smallFontHgt + 12)

	-- local textX = 12
	-- local textY = 6 + smallFontHgt + 6

	-- local barX = textX + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpanel_Remaining")) + 12
	-- local barWid = 80
	-- local barHgt = 4
	-- local barY = textY + (smallFontHgt - barHgt) / 2 + 2

	-- tooltipUI:setWidth(barX + barWid + 12)
	-- tooltipUI:DrawTextureScaledColor(nil, 0, 0, tooltipUI:getWidth(), tooltipUI:getHeight(), 0, 0, 0, 0.75)
	-- tooltipUI:DrawTextCentre(getText("ContextMenu_Rain_Collector_Barrel"), tooltipUI:getWidth() / 2, 6, 1, 1, 1, 1)
	-- tooltipUI:DrawText(getText("IGUI_invpanel_Remaining") .. ":", textX, textY, 1, 1, 1, 1)

	-- local f = barrel:getWaterAmount() / barrel:getModData()["waterMax"]
	-- local fg = { r=0.0, g=0.6, b=0.0, a=0.7 }
	-- if f < 0.0 then f = 0.0 end
	-- if f > 1.0 then f = 1.0 end
	-- local done = math.floor(barWid * f)
	-- if f > 0 then done = math.max(done, 1) end
	-- tooltipUI:DrawTextureScaledColor(nil, barX, barY, done, barHgt, fg.r, fg.g, fg.b, fg.a)
	-- local bg = {r=0.15, g=0.15, b=0.15, a=1.0}
	-- tooltipUI:DrawTextureScaledColor(nil, barX + done, barY, barWid - done, barHgt, bg.r, bg.g, bg.b, bg.a)
-- end

--Events.DoSpecialTooltip.Add(DoSpecialTooltip)
