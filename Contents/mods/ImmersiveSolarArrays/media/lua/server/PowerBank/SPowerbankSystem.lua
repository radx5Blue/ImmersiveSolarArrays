if isClient() then return end

SPowerbankSystem = SGlobalObjectSystem:derive("SPowerbankSystem")

function SPowerbankSystem:new()
    local o = SGlobalObjectSystem.new(self, "powerbank")
    return o
end

function SPowerbankSystem:initSystem()
    SGlobalObjectSystem.initSystem(self)
    self.system:setModDataKeys({})
    self.system:setObjectModDataKeys({'on', 'batteries', 'charge', 'maxcapacity', 'drain', 'npanels', 'panels', 'overlay', "lastHour"})
    self:convertOldModData()
end

function SPowerbankSystem:convertOldModData()
    if self.system:loadedWorldVersion() ~= -1 then return end
    --todo
end

function SPowerbankSystem.isValidModData(modData)
    return modData.charge ~= nil
end

function SPowerbankSystem:newLuaObject(globalObject)
    return SPowerbank:new(self, globalObject)
end

function SPowerbankSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function SPowerbankSystem:getIsoObjectOnSquare(square)
    if square then
        for i=1,square:getSpecialObjects():size() do
            local isoObject = square:getSpecialObjects():get(i-1)
            if self:isValidIsoObject(isoObject) then
                return isoObject
            end
        end
    end
    return nil
end

function SPowerbankSystem:OnClientCommand(command, playerObj, args)
    SPowerbankSystemCommands[command](playerObj, args)
end

--todo client command, fixes, etc
function SPowerbankSystem.connectGenerator(args)
    local x = args.x
    local y = args.y
    local z = args.z
    for i=1,self.system:getObjectCount() do
        local idata = self.system:getObjectByIndex(i-1):getModData()
        if IsoUtils.DistanceToSquared(x,y,idata.x, idata.y) <= 10 and z == idata.z then
            idata.conGenerator = {}
            idata.conGenerator.x = x
            idata.conGenerator.y = y
            idata.conGenerator.z = z
            idata.conGenerator.ison = false
            return
        end
    end
end

function SPowerbankSystem.disconnectGenerator(args)
    for i=1,self.system:getObjectCount() do
        local luaObj = self.system:getObjectByIndex(i-1):getModData()
        if args.x == luaObj.conGenerator.x and args.y == luaObj.conGenerator.y and args.z == luaObj.conGenerator.z then
            luaObj.conGenerator = nil
        end
    end
end

function SPowerbankSystem.removePanel(xpanel)
    local data = xpanel:getModData()
    data.connectDelta = nil
    if not data["powerbank"] then return end
    local x = xpanel:getX()
    local y = xpanel:getY()
    local z = xpanel:getZ()

    local pb = self:getLuaObjectAt(data["powerbank"].x,data["powerbank"].y,data["powerbank"].z)

    for v,panel in ipairs(pb.panels) do
        if panel.x == x and panel.y == y and panel.z == z then
            table.remove(pb.panels,v)
            pb.npanels = pb.npanels - 1
            data["powerbank"] = nil
            return
        end
    end
end

function SPowerbankSystem:EveryDays()
    for i=1,self.system:getObjectCount() do
        local pb = self.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        if isopb then
            local inv = isopb:getContainer()
            pb:degradeBatteries(inv) -- x days passed
            pb:handleBatteries(inv)
        end
    end
end

function SPowerbankSystem:updateCharge(chargefreq)
    for i=1,self.system:getObjectCount() do
        --print("testing test 1",text)
        local pb = self.system:getObjectByIndex(i-1):getModData()
        local isopb = pb:getIsoObject()
        local drain
        if pb.switchchanged then pb.switchchanged = nil elseif not pb.on then drain = 0 end
        if pb.gen and pb.gen.ison then drain = 0 end
        --sandbox check,electricity on every day
        if drain ~= 0 then
            if isopb then pb:updateDrain() end
            drain = pb.drain
        end

        local dif = getModifiedSolarOutput(pb.npanels) - drain
        if chargefreq == 1 then dif = dif / 6 end
        local charge = pb.charge + dif
        if charge < 0 then charge = 0 elseif charge > pb.maxcapacity then charge = pb.maxcapacity end
        local chargemod = charge / pb.maxcapacity
        local newsprite = pb:getSprite(chargemod)

        local transmit = false
        if isopb then
            pb:chargeBatteries(isopb:getContainer(),chargemod)
            pb:updateGenerator()
            pb:updateConGenerator()

            if newsprite ~= pb.overlay then
                pb.overlay = newsprite
                isopb:setOverlaySprite(newsprite)
                --gen:setSprite(newsprite)
                isopb:sendObjectChange('sprite')
                transmit = true
            end
            if (pb.charge == 0 or charge == 0) and charge ~= pb.charge then
                isopb:sendObjectChange('charge')
                transmit = true
            end
        end
        pb.charge = charge
        pb:saveData(transmit)

        print("Isa Log charge: ",i," / "..tostring(math.floor(chargemod*100)).."%"," / ",math.floor(dif))
    end
end

SGlobalObjectSystem.RegisterSystemClass(SPowerbankSystem)

local function addEvents()
    if not SandboxVars.ISA.ChargeFreq then SandboxVars.ISA.ChargeFreq = 1 end
    if not SandboxVars.ISA.DrainCalc then SandboxVars.ISA.DrainCalc = 1 end

    Events.EveryDays.Add(function()SPowerbankSystem.instance:EveryDays() end)
    if SandboxVars.ISA.ChargeFreq == 1 then
        Events.EveryTenMinutes.Add(function()SPowerbankSystem.instance:updateCharge(1) end)
    else
        Events.EveryHours.Add(function()SPowerbankSystem.instance:updateCharge(2) end)
    end
end
Events.OnLoad.Add(addEvents)

print("ISATesting Loading Stack Trace")