require "Map/CGlobalObjectSystem"

CPowerbankSystem = CGlobalObjectSystem:derive("CPowerbankSystem")

function CPowerbankSystem:new()
    return CGlobalObjectSystem.new(self, "Powerbank")
end

function CPowerbankSystem:isValidIsoObject(isoObject)
    return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "solarmod_tileset_01_0"
end

function CPowerbankSystem:newLuaObject(globalObject)
    return CPowerbank:new(self, globalObject)
end

function CPowerbankSystem.canConnectPanelTo(square)
    local x = square:getX()
    local y = square:getY()
    local z = square:getZ()
    local options = {}
    for i=1, CPowerbankSystem.instance.system:getObjectCount() do
        local pb = CPowerbankSystem.instance.system:getObjectByIndex(i-1):getModData()
        if IsoUtils.DistanceToSquared(x, y, pb.x, pb.y) <= 400.0 and math.abs(z - pb.z) <= 3 then
            table.insert(options, {pb.x-x,pb.y-y, pb})
        end
    end
    return options
end

function CPowerbankSystem.onPlugGenerator(character,generator,plug)
    local gendata = generator:getModData()
    if plug then
        local isopb = ISAScan.findPowerbank(generator:getSquare(),3,0,10)
        if isopb then
            local pb = { x = isopb:getX(), y = isopb:getY(), z = isopb:getZ() }
            local gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }
            gendata["ISA_conGenerator"] = pb
            generator:transmitModData()
            CPowerbankSystem.instance:sendCommand(character,"plugGenerator",{ pb = pb, gen = gen, plug = plug })
        end
    else
        if gendata["ISA_conGenerator"] then
            local pbdata = gendata["ISA_conGenerator"]
            if CPowerbankSystem.instance:getLuaObjectAt(pbdata.x,pbdata.y,pbdata.z) then
                local gen = { x = generator:getX(), y = generator:getY(), z = generator:getZ() }
                CPowerbankSystem.instance:sendCommand(character,"plugGenerator",{ pb = pbdata, gen = gen, plug = plug })
            end
            gendata["ISA_conGenerator"] = nil
            generator:transmitModData()
        end
    end
end

function CPowerbankSystem.updateSprite(isoObject)
    --local pb = CPowerbankSystem.instance:getLuaObjectOnSquare(isoObject:getSquare())
    --pb:updateFromIsoObject()
    --pb:updateSprite()
    local overlay = isoObject:getModData().overlay
    isoObject:setOverlaySprite(overlay)
end

CGlobalObjectSystem.RegisterSystemClass(CPowerbankSystem)
