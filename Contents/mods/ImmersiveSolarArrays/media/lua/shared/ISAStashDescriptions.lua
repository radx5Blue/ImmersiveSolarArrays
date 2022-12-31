--if isClient then return end -- how much of this does a client actually need?

local isa = require "ISAUtilities"
local StashUtil = StashUtil

local Stash = { descriptions={} }

function Stash.newStash(obj,mod)
    setmetatable(obj,StashUtil)
    Stash.descriptions[obj] = mod
    return obj
end

local stashMap = Stash.newStash({
    name = "ISA_Stash_RiversideW1",
    type = "Map",
    item = "ISA.Stash_RiversideW1",
    customName = "Stash_AnnotedMap",
    buildingX = 4538,
    buildingY = 5727,
    barricades = 80,
    spawnOnlyOnZed = true,
    spawnTable = "ISASolarBoxCache",
    containers = {
        { containerType = "SolarBox", containerSprite = "solarmod_tileset_01_36", x = 4542, y = 5719, z = 0 }
    }
},
{
    knownOnStart = 90,
    rarity = 0.6,
    targets = {"inventoryfemale","inventorymale","Outfit_Foreman"}
})
stashMap:addStamp(nil, "Stash_ISA_Stash_RiversideW1_t1", 5497, 5962, 0, 0, 1)
stashMap:addStamp(nil, "Stash_ISA_Stash_RiversideW1_t2", 5410, 5845, 0, 0, 1)
stashMap:addStamp("Exclamation", nil, 5538, 5953, 0, 0, 0)
stashMap:addStamp("ArrowWest", nil, 5451, 5835, 0, 0, 0)
stashMap:addStamp("Question", nil, 5412, 5835, 0, 0, 0)
stashMap:addStamp("X", nil, 5415, 6106, 0, 0, 0)
stashMap:addStamp("X", nil, 5408, 6056, 0, 0, 0)
--stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,4542,5719,0)


local stashMap = Stash.newStash({
    name = "ISA_Stash_RosewoodE1",
    type = "Map",
    item = "ISA.Stash_RosewoodE1",
    customName = "Stash_AnnotedMap",
    buildingX = 9069,
    buildingY = 12425,
    barricades = 60,
    spawnOnlyOnZed = true,
    spawnTable = "ISASolarBoxCache",
    containers = {
        { containerType = "SolarBox", containerSprite = "solarmod_tileset_01_36", x = 9064, y = 12423, z = 1 }
    }
},
{
    knownOnStart = 90,
    rarity = 0.6,
    targets = {"inventoryfemale","inventorymale","Outfit_Inmate"}
})
stashMap:addStamp(nil, "Stash_ISA_Stash_RosewoodE1_t1", 8071, 12101, 0, 0, 0)
stashMap:addStamp("House", nil, 8116, 12227, 0, 0, 0)
stashMap:addStamp("Fish", nil, 8171, 12188, 0, 0, 0)
stashMap:addStamp("Lock", nil, 8245, 12233, 0, 0, 0)
stashMap:addStamp("Lock", nil, 8285, 12211, 0, 0, 0)
stashMap:addStamp(nil, "Stash_ISA_Stash_RosewoodE1_t2", 8208, 12313, 1, 0, 0)
stashMap:addStamp("Question", nil, 8388, 12300, 0, 0, 0)
stashMap:addStamp("Question", nil, 8388, 12320, 0, 0, 0)
stashMap:addStamp("Question", nil, 8388, 12340, 0, 0, 0)
--stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,9064,12423,1)

local stashMap = Stash.newStash({
    name = "ISA_Stash_Muldraugh1",
    type = "Map",
    item = "Base.MuldraughMap",
    customName = "Stash_AnnotedMap",
    buildingX = 10653,
    buildingY = 9715,
    zombies = 8,
    barricades = 40,
    spawnOnlyOnZed = false,
    spawnTable = "ISASolarBoxCache",
    containers = {
        { containerType = "SolarBox", containerSprite = "solarmod_tileset_01_36", x = 10655, y = 9720, z = 0 }
    }
},
{
    knownOnStart = 90,
})
stashMap:addStamp("Target", nil, 10653, 9717, 0, 0, 0)
stashMap:addStamp(nil, "Stash_ISA_Stash_Muldraugh1_t1", 10663, 9708, 0, 0, 0)
stashMap:addStamp("FaceDead", nil, 10701, 9355, 0, 0, 0)
stashMap:addStamp(nil, "Stash_ISA_Stash_Muldraugh1_t2", 10710, 9346, 0, 0, 0)
stashMap:addStamp("Cross", nil, 10726, 9327, 0, 0, 0)
--stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,10655,9720,0)

local stashMap = Stash.newStash({
    name = "ISA_Stash_Westpoint1",
    type = "Map",
    item = "Base.WestpointMap",
    customName = "Stash_AnnotedMap",
    buildingX = 11574,
    buildingY = 6768,
    barricades = 60,
    spawnOnlyOnZed = true,
    spawnTable = "ISASolarBoxCache",
    containers = {
        { containerType = "SolarBox", containerSprite = "solarmod_tileset_01_36", x = 11577, y = 6768, z = 1 }
    }
},
{
    knownOnStart = 90,
})
stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t1", 10912, 7330, 1, 0, 0)
stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t2", 11588, 7431, 0, 0, 0)
stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t3", 11554, 6890, 0, 0, 0)
stashMap:addStamp("Skull", nil, 11737, 7182, 0, 0, 0)
stashMap:addStamp("Skull", nil, 12106, 7182, 0, 0, 0)
stashMap:addStamp("Skull", nil, 12229, 6899, 0, 0, 0)
stashMap:addStamp("Skull", nil, 10838, 7048, 0, 0, 0)
--stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,11577,6768,1)

local stashMap = Stash.newStash({
    name = "ISA_Stash_Louisville1",
    type = "Map",
    item = "ISA.Stash_Louisville1",
    customName = "Stash_AnnotedMap",
    buildingX = 13133,
    buildingY = 2944,
    barricades = 60,
    spawnOnlyOnZed = true,
    traps = "1",
    spawnTable = "ISASolarBoxCache",
    containers = {
        { containerType = "SolarBox", containerSprite = "solarmod_tileset_01_36", x = 13135, y = 2940, z = 0 }
    }
},
{
    knownOnStart = false,
    rarity = 0.1,
    targets = {"inventoryfemale","inventorymale","Outfit_Survivalist","Outfit_Survivalist2","Outfit_Survivalist3","Outfit_Bandit"}
})
stashMap:addStamp("House", nil, 13133, 2946, 0, 0, 1)
stashMap:addStamp(nil, "Stash_ISA_Stash_Louisville1_t1", 13277, 3086, 0, 0, 0)
stashMap:addStamp("Skull", nil, 13039, 2999, 1, 0, 0)
stashMap:addStamp("Skull", nil, 13039, 2926, 1, 0, 0)
stashMap:addStamp("Skull", nil, 13316, 2999, 1, 0, 0)
stashMap:addStamp("Skull", nil, 13198, 3055, 1, 0, 0)
stashMap:addStamp("Skull", nil, 13417, 2898, 1, 0, 0)
stashMap:addStamp("DollarSign", nil, 13350, 3062, 1, 0, 0)
stashMap:addStamp("Circle", nil, 13349, 3043, 0, 0, 0)
stashMap:addStamp("Trap", nil, 13066, 2926, 0, 0, 0)
stashMap:addStamp("Trap", nil, 13064, 2997, 0, 0, 0)
stashMap:addStamp("Trap", nil, 13200, 3001, 0, 0, 0)
stashMap:addStamp("ArrowSouthEast", nil, 13193, 2929, 1, 0, 0)
stashMap:addStamp("ArrowSouthEast", nil, 13257, 3001, 1, 0, 0)
stashMap:addStamp("X", nil, 13317, 3000, 0, 0, 0)
stashMap:addStamp("X", nil, 13039, 2926, 0, 0, 0)
--stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,13135,2940,0)

function Stash.prepareBuildingStash()
    for stashMap,def in pairs(Stash.descriptions) do
        if def.knownOnStart and ZombRand(100) < def.knownOnStart then
            StashSystem.prepareBuildingStash(stashMap.name) --needs World to have currentCell
        end
    end
end

function Stash.insertItems()
    local table = table
    local StashDescriptions = StashDescriptions
    local all = SuburbsDistributions.all

    for stashMap,extraDef in pairs(Stash.descriptions) do
        table.insert(StashDescriptions,stashMap)
        if extraDef.rarity and extraDef.targets then
            isa.distributions.insertSimilarItems(all,extraDef.targets,{stashMap.item,extraDef.rarity})
        end
    end
    isa.distributions.doParse = true
    --isa.distributions.insertInto("items","suburbs",{all = outfitItems},nil,true)
end

function Stash.sandbox(newGame)
    local mode = SandboxVars.ISA.StashMode
    if mode == 1 then return end

    --local stashDef = {}
    --
    --local stashMap = StashUtil.newStash("ISA_Stash_RiversideW1", "Map", "ISA.Stash_RiversideW1", "Stash_AnnotedMap")
    --stashMap.buildingX = 4538
    --stashMap.buildingY = 5727
    --stashMap.barricades = 80
    --stashMap.spawnOnlyOnZed = true
    --stashMap:addStamp(nil, "Stash_ISA_Stash_RiversideW1_t1", 5497, 5962, 0, 0, 1)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_RiversideW1_t2", 5410, 5845, 0, 0, 1)
    --stashMap:addStamp("Exclamation", nil, 5538, 5953, 0, 0, 0)
    --stashMap:addStamp("ArrowWest", nil, 5451, 5835, 0, 0, 0)
    --stashMap:addStamp("Question", nil, 5412, 5835, 0, 0, 0)
    --stashMap:addStamp("X", nil, 5415, 6106, 0, 0, 0)
    --stashMap:addStamp("X", nil, 5408, 6056, 0, 0, 0)
    --stashMap.spawnTable = "ISASolarBoxCache"
    --stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,4542,5719,0)
    --stashDef[stashMap] = {
    --    knownOnStart = 90,
    --    rarity = 0.6,
    --    targets = {"inventoryfemale", "inventorymale","Outfit_Foreman"}
    --}
    --
    --local stashMap = StashUtil.newStash("ISA_Stash_RosewoodE1", "Map", "ISA.Stash_RosewoodE1", "Stash_AnnotedMap")
    --stashMap.buildingX = 9069
    --stashMap.buildingY = 12425
    --stashMap.barricades = 60
    --stashMap.spawnOnlyOnZed = true
    --stashMap:addStamp(nil, "Stash_ISA_Stash_RosewoodE1_t1", 8071, 12101, 0, 0, 0)
    --stashMap:addStamp("House", nil, 8116, 12227, 0, 0, 0)
    --stashMap:addStamp("Fish", nil, 8171, 12188, 0, 0, 0)
    --stashMap:addStamp("Lock", nil, 8245, 12233, 0, 0, 0)
    --stashMap:addStamp("Lock", nil, 8285, 12211, 0, 0, 0)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_RosewoodE1_t2", 8208, 12313, 1, 0, 0)
    --stashMap:addStamp("Question", nil, 8388, 12300, 0, 0, 0)
    --stashMap:addStamp("Question", nil, 8388, 12320, 0, 0, 0)
    --stashMap:addStamp("Question", nil, 8388, 12340, 0, 0, 0)
    --stashMap.spawnTable = "ISASolarBoxCache"
    --stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,9064,12423,1)
    --stashDef[stashMap] = {
    --    knownOnStart = 90,
    --    rarity = 0.6,
    --    targets = {"inventoryfemale", "inventorymale","Outfit_Inmate"}
    --}
    --
    --local stashMap = StashUtil.newStash("ISA_Stash_Muldraugh1", "Map", "Base.MuldraughMap", "Stash_AnnotedMap")
    --stashMap.buildingX = 10653
    --stashMap.buildingY = 9715
    --stashMap.zombies = 8
    --stashMap.barricades = 40
    --stashMap.spawnOnlyOnZed = false
    --stashMap:addStamp("Target", nil, 10653, 9717, 0, 0, 0)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Muldraugh1_t1", 10663, 9708, 0, 0, 0)
    --stashMap:addStamp("FaceDead", nil, 10701, 9355, 0, 0, 0)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Muldraugh1_t2", 10710, 9346, 0, 0, 0)
    --stashMap:addStamp("Cross", nil, 10726, 9327, 0, 0, 0)
    --stashMap.spawnTable = "ISASolarBoxCache"
    --stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,10655,9720,0)
    --stashDef[stashMap] = {
    --    knownOnStart = 90,
    --}
    --
    --local stashMap = StashUtil.newStash("ISA_Stash_Westpoint1", "Map", "Base.WestpointMap", "Stash_AnnotedMap")
    --stashMap.buildingX = 11574
    --stashMap.buildingY = 6768
    --stashMap.barricades = 60
    --stashMap.spawnOnlyOnZed = true
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t1", 10912, 7330, 1, 0, 0)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t2", 11588, 7431, 0, 0, 0)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Westpoint1_t3", 11554, 6890, 0, 0, 0)
    --stashMap:addStamp("Skull", nil, 11737, 7182, 0, 0, 0)
    --stashMap:addStamp("Skull", nil, 12106, 7182, 0, 0, 0)
    --stashMap:addStamp("Skull", nil, 12229, 6899, 0, 0, 0)
    --stashMap:addStamp("Skull", nil, 10838, 7048, 0, 0, 0)
    --stashMap.spawnTable = "ISASolarBoxCache"
    --stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,11577,6768,1)
    --stashDef[stashMap] = {
    --    knownOnStart = 90,
    --}
    --
    --local stashMap = StashUtil.newStash("ISA_Stash_Louisville1", "Map", "ISA.Stash_Louisville1", "Stash_AnnotedMap")
    --stashMap.buildingX = 13133
    --stashMap.buildingY = 2944
    --stashMap.barricades = 60
    --stashMap.spawnOnlyOnZed = true
    --stashMap.traps = "1"
    --stashMap:addStamp("House", nil, 13133, 2946, 0, 0, 1)
    --stashMap:addStamp(nil, "Stash_ISA_Stash_Louisville1_t1", 13277, 3086, 0, 0, 0)
    --stashMap:addStamp("Skull", nil, 13039, 2999, 1, 0, 0)
    --stashMap:addStamp("Skull", nil, 13039, 2926, 1, 0, 0)
    --stashMap:addStamp("Skull", nil, 13316, 2999, 1, 0, 0)
    --stashMap:addStamp("Skull", nil, 13198, 3055, 1, 0, 0)
    --stashMap:addStamp("Skull", nil, 13417, 2898, 1, 0, 0)
    --stashMap:addStamp("DollarSign", nil, 13350, 3062, 1, 0, 0)
    --stashMap:addStamp("Circle", nil, 13349, 3043, 0, 0, 0)
    --stashMap:addStamp("Trap", nil, 13066, 2926, 0, 0, 0)
    --stashMap:addStamp("Trap", nil, 13064, 2997, 0, 0, 0)
    --stashMap:addStamp("Trap", nil, 13200, 3001, 0, 0, 0)
    --stashMap:addStamp("ArrowSouthEast", nil, 13193, 2929, 1, 0, 0)
    --stashMap:addStamp("ArrowSouthEast", nil, 13257, 3001, 1, 0, 0)
    --stashMap:addStamp("X", nil, 13317, 3000, 0, 0, 0)
    --stashMap:addStamp("X", nil, 13039, 2926, 0, 0, 0)
    --stashMap.spawnTable = "ISASolarBoxCache"
    --stashMap:addContainer("SolarBox","solarmod_tileset_01_36",nil,nil,13135,2940,0)
    --stashDef[stashMap] = {
    --    knownOnStart = false,
    --    rarity = 0.1,
    --    targets = {"inventoryfemale","inventorymale","Outfit_Survivalist","Outfit_Survivalist2","Outfit_Survivalist3","Outfit_Bandit"}
    --}



    --if mode

    --addItems({"inventoryfemale", "inventorymale","Foreman"},
    --        {
    --            "ISA.Stash_RiversideW1",0.06,
    --        })

    --if not newGame and not ModData.exists("ISAWorldSpawns") then --new feature or newly added to save // need access to allStashes.add(var2)
    --    newGame = true
    --    queueFunction("OnLoadMapZones",function()
    --        for _,stash in ipairs(stashDef) do
    --            --...
    --        end
    --    end)
    --end

    --if not isClient() then
    --    if newGame and mode == 3 then
    --        for stashMap,def in pairs(stashDef) do
    --            if def.knownOnStart and ZombRand(100) < def.knownOnStart then
    --                def.known = true
    --                def.rarity = nil
    --            end
    --        end
    --        isa.queueFunction("OnTick",function()
    --            for stashMap,def in pairs(stashDef) do
    --                if def.known then
    --                    StashSystem.prepareBuildingStash(stashMap.name)
    --                end
    --            end
    --        end)
    --    end
    --end
    if not isClient() then
        if newGame and mode == 3 then
            isa.queueFunction("OnTick",Stash.prepareBuildingStash)
        end
    end

    Stash.insertItems()

    -----only know if visited house, hard to see if stash has been done
    --table.insert(isa.distributions.checkList,function()
    --    local metaGrid = getWorld():getMetaGrid()
    --    local function checkNeedItem(stashMap)
    --        local bDef = metaGrid:getBuildingAt(stashMap.buildingX,stashMap.buildingY)
    --        print("ISAtest not visited ",stashMap.name,bDef and not bDef:isHasBeenVisited())
    --
    --        return bDef and not bDef:isHasBeenVisited()
    --    end
    --
    --    local outfitItems = {}
    --    local doParse
    --    for stashMap,extraDef in pairs(stashDef) do
    --        if extraDef.rarity and extraDef.targets and checkNeedItem(stashMap) then
    --            for _,target in ipairs(extraDef.targets) do
    --                doParse = true
    --                outfitItems[target] = outfitItems[target] or {items={}}
    --                table.insert(outfitItems[target]["items"],stashMap.item)
    --                table.insert(outfitItems[target]["items"],extraDef.rarity)
    --            end
    --        end
    --    end
    --    if doParse then isa.distributions.insertInto("items","suburbs",{ all = outfitItems},nil,true) end
    --end)
end

Events.OnInitGlobalModData.Add(Stash.sandbox)

--debug
if not SandboxVars.ISA.StashMode then SandboxVars.ISA.StashMode = 1 end

--util.queueFunction("OnLoadMapZones",function()
--    SandboxVars.ISA.StashMode = 2
--    stashSandbox()
--    StashSystem.reinit()
--end)
--
--if getPlayer() then
--    SandboxVars.ISA.StashMode = 2
--    stashSandbox()
--end
--getWorld():getMetaGrid():getBuildingAt(stashMap.buildingX,stashMap.buildingY)

return Stash