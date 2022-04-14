if isClient() then return end
require "PowerBank/SPowerbankSystem"

local Commands = {}
--local function noise(message) SPowerbankSystem.instance:noise(message) end

local function getPowerbank(args)
    return SPowerbankSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

--function Commands.connectGenerator(player,args)
--    SPowerbankSystem.instance.connectGenerator(args)
--end

function Commands.removePanel(player,args)
    local pb = getPowerbank(args.pb)
    for i,panel in ipairs(pb.panels) do
        if panel.x == args.panel.x and panel.y == args.panel.y and panel.z == args.panel.z then
            table.remove(pb.panels,i)
            pb.npanels = pb.npanels - 1
            return
        end
    end
end

function Commands.addPanel(player,args)
    local pb = getPowerbank(args.pb)
    table.insert(pb.panels,args.panel)
    pb.npanels = pb.npanels + 1
end

SPowerbankSystemCommands = Commands
