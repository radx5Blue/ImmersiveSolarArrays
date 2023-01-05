if isClient() then return end
require "Distributions/ISAWorldSpawns"

local Maps = {}
--main map, mp and challenges list this map
Maps["Muldraugh, KY"] = {
    { x = 4722, y = 7997, z = 0, type = 'solarmod_tileset_01_7', overwrite = {} },
    { x = 4743, y = 7848, z = 0, type = 'solarmod_tileset_01_7', overwrite = {} },
    { x = 9656, y = 10156, z = 1, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 10254, y = 8762, z = 1, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 9670, y = 8775, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 12482, y = 8879, z = 0, type = 'solarmod_tileset_01_7', overwrite = {} },
    { x = 12477, y = 8918, z = 0, type = 'solarmod_tileset_01_6', overwrite = {} },
    { x = 12066, y = 7378, z = 1, type = 'solarmod_tileset_01_7', overwrite = {} },
    { x = 13631, y = 7220, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 9345, y = 10292, z = 1, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 9671, y = 8775, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 4253, y = 7228, z = 0, type = 'solarmod_tileset_01_6', overwrite = {} },
    { x = 7460, y = 7968, z = 0, type = 'solarmod_tileset_01_6', overwrite = {} },
    { x = 11612, y = 9295, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11588, y = 9292, z = 1, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 10390, y = 10060, z = 1, type = 'solarmod_tileset_01_9', overwrite = {} },
    { x = 10182, y = 6761, z = 1, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 10745, y = 9843, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 8540, y = 9037, z = 0, type = 'solarmod_tileset_01_6', overwrite = {} },
    { x = 8622, y = 8824, z = 1, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11619, y = 9961, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} }, --traincar
    { x = 11619, y = 9934, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} }, --traincar
    { x = 11642, y = 9762, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11644, y = 9754, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11642, y = 9744, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11735, y = 9763, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11735, y = 10045, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11735, y = 10054, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11735, y = 10060, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 11735, y = 10085, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} },
    { x = 5332, y = 10558, z = 0, type = 'solarmod_tileset_01_10', overwrite = {} }, --farmhouse
    { x = 6363, y = 5324, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --riverside hardware:
    { x = 11971, y = 6907, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --west point hardware:
    { x = 13917, y = 5786, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --dixie hardware:
    { x = 13916, y = 5804, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --The mall hardware:
    { x = 9185, y = 11828, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --Army quarter warehouse:
    { x = 8279, y = 10028, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse near rosewood:
    { x = 10698, y = 10450, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse in muldraugh:
    { x = 5878, y = 9861, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse in the countryside:
    { x = 12621, y = 4712, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse near valley station:
    { x = 5541, y = 12440, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --Secret military base:
    { x = 7648, y = 9331, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 6548, y = 8930, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 5878, y = 9852, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 10693, y = 10099, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, -- warehouse
    { x = 10623, y = 9890, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --electric furniture store
    { x = 10633, y = 9375, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --garage
    { x = 11618, y = 9935, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --railyard / traincar
    { x = 10672, y = 9819, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --self storage
    { x = 10752, y = 10344, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --storage
    { x = 10613, y = 9311, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 10018, y = 10913, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 10716, y = 10419, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 12828, y = 6432, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --Valley Station
    { x = 14318, y = 4947, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --farm
    { x = 13843, y = 4748, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --farm
    { x = 11133, y = 6861, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, -- farm
    { x = 11961, y = 6920, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --hardwarestore
    { x = 12148, y = 7099, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --warehouse
    { x = 12148, y = 7074, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --storage
    { x = 11835, y = 6916, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --hardware store
    { x = 11946, y = 6891, z = 1, type = 'solarmod_tileset_01_7', overwrite = {} }, --WP Town Hall
    { x = 11953, y = 6891, z = 1, type = 'solarmod_tileset_01_7', overwrite = {} }, --WP Town Hall
    { x = 9204, y = 11823, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, -- warehouse
    { x = 5541, y = 6068, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --self storage
    { x = 5577, y = 5875, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, -- factory
    { x = 5628, y = 5957, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --factory storage
    { x = 5704, y = 5717, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --farm
    { x = 7243, y = 8285, z = 0, type = 'solarmod_tileset_01_36', overwrite = { "NewEkron" } }, -- farm
    { x = 7248, y = 8313, z = 0, type = 'solarmod_tileset_01_36', overwrite = { "NewEkron" } }, -- 'farming' store
    { x = 7251, y = 8226, z = 0, type = 'solarmod_tileset_01_36', overwrite = { "NewEkron" } }, -- The mall electronics
    { x = 7308, y = 8248, z = 0, type = 'solarmod_tileset_01_36', overwrite = { "NewEkron" } }, -- general store
}
Maps.RavenCreek = {
    { x = 3042, y = 11350, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --army base, sledgehammer required
    { x = 3617, y = 11312, z = 1, type = 'solarmod_tileset_01_7', overwrite = {} },
    { x = 4129, y = 11265, z = 6, type = 'solarmod_tileset_01_9', overwrite = {} },
    { x = 3125, y = 11848, z = 6, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 3125, y = 11849, z = 6, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 3126, y = 11848, z = 6, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 3126, y = 11849, z = 6, type = 'solarmod_tileset_01_8', overwrite = {} },
    { x = 3339, y = 12227, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --port warehouse
    { x = 3479, y = 12684, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --port container / sledge
}
Maps["challengemaps/Kingsmouth"] = {
    { x = 30407, y = 30427, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --military base, warehouse
    { x = 30868, y = 30363, z = 1, type = 'solarmod_tileset_01_36', overwrite = {} }, --container, stairs
}
Maps["NewEkron"] = {
    { x = 7385, y = 8299, z = 0, type = 'solarmod_tileset_01_36', overwrite = {} }, --Electronics Store
}
ISAWorldSpawns.defs.mapLocations = Maps
