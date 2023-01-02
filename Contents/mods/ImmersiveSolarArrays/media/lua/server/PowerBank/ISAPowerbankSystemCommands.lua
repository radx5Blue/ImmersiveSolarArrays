if isClient() then return end

--local isa = require "ISAUtilities"
local PbSystem = require "Powerbank/ISAPowerbankSystem_server"

local Commands = {}

local function noise(message) return PbSystem.instance:noise(message) end

local function getPowerbank(args)
    return PbSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
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
        local x,y,z = args.panel.x,args.panel.y,args.panel.z
        local square = getSquare(x,y,z)
        if square and self.luaSystem:getValidPanelOnSquare(square) then
            --for _,panel in ipairs(pb.panels) do
            --    if x == panel.x and y == panel.y and z == panel.z then return end
            --end

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
            pb.charge = pb.charge - args[4]
            pb.maxcapacity = pb.maxcapacity - args[4]
        elseif args[2] == "put" then
            pb.batteries = pb.batteries + 1
            pb.charge = pb.charge + args[4]
            pb.maxcapacity = pb.maxcapacity + args[4]
        end
        pb:updateGenerator()
        pb:updateSprite()
        pb:saveData(true)
    end
end

function Commands.plugGenerator(player,args)
    local square = getSquare(args.gen.x,args.gen.y,args.gen.z)
    local generator = square and PbSystem.instance:getValidBackupOnSquare(square)
    for _,i in ipairs(args.pbList) do
        local pb = getPowerbank(i)
        if pb then
            if args.plug and generator then
                noise("adding backup")
                pb:connectBackupGenerator(generator)
            else
                if pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
                    noise("removing backup")
                    pb.conGenerator = false
                end
            end
            pb:saveData(true)
        end
    end
end
--
--function Commands.plugGenerator(player,args)
--    local square = getSquare(args.gen.x,args.gen.y,args.gen.z)
--    local generator = square and square:getGenerator()
--    for _,i in ipairs(args.pbList) do
--        local pb = getPowerbank(i)
--        if pb then
--            if args.plug and generator and pb.luaSystem:isValidBackup(generator,square) then
--                noise("adding backup")
--                pb:connectBackupGenerator(generator)
--            else
--                if pb.conGenerator and pb.conGenerator.x == args.gen.x and pb.conGenerator.y == args.gen.y and pb.conGenerator.z == args.gen.z then
--                    noise("removing backup")
--                    pb.conGenerator = false
--                end
--            end
--            pb:saveData(true)
--        end
--    end
--end

function Commands.activateGenerator(player,args)
    local pb = getPowerbank(args.pb)
    if pb and pb.conGenerator then
        pb.conGenerator.ison = args.activate
        pb:saveData(true)
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

function Commands.countBatteries(player,args)
    local pb = getPowerbank(args)
    local isopb = pb and pb:getIsoObject()
    if isopb then
        pb:handleBatteries(isopb:getContainer())
        pb:updateSprite()
        pb:saveData(true)
    end
end

PbSystem.Commands = Commands
