if isClient() then return end
require "PowerBank/SPowerbankSystem"

local Commands = {}

local function noise(message) SPowerbankSystem.instance:noise(message) end

local function getPowerbank(args)
    return SPowerbankSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

function Commands.disconnectPanel(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        for i,panel in ipairs(pb.panels) do
            if panel.x == args.panel.x and panel.y == args.panel.y and panel.z == args.panel.z then
                table.remove(pb.panels,i)
                pb.npanels = pb.npanels - 1
                break
            end
        end
        pb:saveData(true)
    end
end

function Commands.connectPanel(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        local square = getSquare(args.panel.x,args.panel.y,args.panel.z)
        if square and square:isOutside() then
            table.insert(pb.panels,args.panel)
            pb.npanels = pb.npanels + 1
            pb:saveData(true)
        end
    end
end

function Commands.Battery(player,args)
    local pb = getPowerbank(args[1])
    if pb then
        noise("Transfering Battery")
        if args[2] == "take" then
            pb.batteries = pb.batteries - 1
            pb.charge = pb.charge - args[3] * args[4]
            pb.maxcapacity = pb.maxcapacity - args[4]
        elseif args[2] == "put" then
            pb.batteries = pb.batteries + 1
            pb.charge = pb.charge + args[3] * args[4]
            pb.maxcapacity = pb.maxcapacity + args[4]
        end
        pb:updateGenerator()
        pb:updateSprite()
        pb:saveData(true)
    end
end

function Commands.plugGenerator(player,args)
    local square = getSquare(args.gen.x,args.gen.y,args.gen.z)
    local generator = square and square:getGenerator()
    if not generator or ISAScan.findTypeOnSquare(square,"Powerbank") then print("ISA error: plug generator, no generator"); return end
    for _,i in ipairs(args.pbList) do
        local pb = getPowerbank(i)
        if pb then
            if args.plug then
                pb:connectBackupGenerator(generator)
            else
                if pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
                    pb.conGenerator = false
                end
            end
            pb:saveData(true)
        else
            print("ISA error: plug generator, no Lua Object")
        end
    end


    --local skill = player:getPerkLevel(Perks.Electricity)
    --local radius, level, distance = skill, skill > 5 and 1 or 0, math.pow(skill, 2)
    --local powerbanks = ISAScan.findPowerbanks(square, radius, level, distance)
    --for _,isopb in ipairs(powerbanks) do
    --    local pb = SPowerbankSystem.instance:getLuaObjectOnSquare(isopb:getSquare())
    --end
end

function Commands.activateGenerator(player,args)
    local pb = getPowerbank(args.pb)
    if pb and pb.conGenerator then
        --local square = getSquare(args.gen.x, args.gen.y, args.gen.z)
        --local powerbanks = ISAScan.findPowerbanks(square,3,0,10)
        --for _,isopb in ipairs(powerbanks) do
        --    local pb = SPowerbankSystem.instance:getLuaObjectOnSquare(isopb:getSquare())
        --    if not pb then print("ISA error: no Lua Object on square - activate generator"); return end
        --    if pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
                pb.conGenerator.ison = args.activate
        --    end
            pb:saveData(true)
        --end
    end
end

function Commands.activatePowerbank(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        pb.on = args.activate
        pb.switchchanged = true
        pb:updateDrain()
        pb:updateGenerator()
        pb:saveData(true)
    end
end

--temp fix, no charge change
function Commands.countBatteries(player,args)
    local pb = getPowerbank(args)
    local isopb = pb and pb:getIsoObject()
    if isopb then
        local inv = isopb:getContainer()
        pb:handleBatteries(inv)
        pb:updateSprite()
        pb:saveData(true)
    end
end

SPowerbankSystemCommands = Commands
