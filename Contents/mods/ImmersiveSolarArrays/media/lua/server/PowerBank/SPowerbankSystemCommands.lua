if isClient() then return end
require "PowerBank/SPowerbankSystem"

local Commands = {}

local function noise(message) SPowerbankSystem.instance:noise(message) end

local function getPowerbank(args)
    return SPowerbankSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

function Commands.removePanel(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        for i,panel in ipairs(pb.panels) do
            if panel.x == args.panel.x and panel.y == args.panel.y and panel.z == args.panel.z then
                table.remove(pb.panels,i)
                pb.npanels = pb.npanels - 1
                return
            end
        end
        pb:saveData(true)
    end
end

function Commands.addPanel(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        table.insert(pb.panels,args.panel)
        pb.npanels = pb.npanels + 1
        pb:saveData(true)
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
        pb:updateSprite()
        pb:saveData(true)
    end
end

function Commands.plugGenerator(player,args)
    local pb = getPowerbank(args.pb)
    if pb then
        if args.plug then
            pb.conGenerator = {}
            pb.conGenerator.x = args.gen.x
            pb.conGenerator.y = args.gen.y
            pb.conGenerator.z = args.gen.z
            pb.conGenerator.ison = false
        else
            if pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
                pb.conGenerator = nil
            end
        end
        --pb:saveData(true)
    end
end

function Commands.activateGenerator(player,args)
    local pb = getPowerbank(args.pb)
    if pb and pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
        pb.conGenerator.ison = args.activate
        --pb:saveData(true)
    else
        local square = getSquare(args.gen.x, args.gen.y, args.gen.z)
        local generator = square and square:getGenerator()
        if generator then
            local data = generator:getModData()["ISA_conGenerator"]
            data = nil
            generator:transmitModData()
        end
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

function Commands.reboot(player,args)
    SPowerbankSystem.instance.rebootSystem(args)
end

SPowerbankSystemCommands = Commands
