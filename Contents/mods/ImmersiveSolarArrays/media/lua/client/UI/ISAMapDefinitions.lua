require 'Maps/ISMapDefinitions'

local LootMaps = LootMaps
local MapUtils = MapUtils

--local MINZ = 0
--local MAXZ = 24
--local function replaceWaterStyle(mapAPI)
--    if not WATER_TEXTURE then return end
--    local styleAPI = mapAPI:getStyleAPI()
--    local layer = styleAPI:getLayerByName("water")
--    if not layer then return end
--    layer:setMinZoom(MINZ)
--    layer:setFilter("water", "river")
--    layer:removeAllFill()
--    layer:removeAllTexture()
--    layer:addFill(MINZ, 59, 141, 149, 255)
--    layer:addFill(MAXZ, 59, 141, 149, 255)
--end

local function addMapInit(name,x1,y1,x2,y2)
    LootMaps.Init[name] = function(mapUI)
        local mapAPI = mapUI.javaObject:getAPIv1()
        MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
        --MapUtils.initDefaultMapData(mapUI) --all Maps
        MapUtils.initDefaultStyleV1(mapUI)
        mapAPI:setBoundsInSquares(x1,y1,x2,y2)
        MapUtils.overlayPaper(mapUI)
    end
end
addMapInit("ISA_Stash_RiversideW1",5400, 5820, 5649, 6119)
addMapInit("ISA_Stash_RosewoodE1",8000, 12100, 8399, 12349)
addMapInit("ISA_Stash_Louisville1",13030, 2860, 13439, 3139)
