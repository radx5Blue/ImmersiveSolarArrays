require "Moveables/ISMoveableDefinitions"
Events.OnGameBoot.Add(function()
    local defs = ISMoveableDefinitions:getInstance()
    --moveableDefinitions.reset();

    --addScrapDefinition( _material, _tools, _tools2, _perk, _baseActionTime, _sound, _isWav, _baseChance, _unusableItem )
    -- addScrapItem(_material, _returnItem, _maxAmount, _chancePerRoll, _isStaticSize)
    defs.addScrapDefinition( "BatteryBank",  {"Base.Screwdriver"}, {}, Perks.Electricity,  1000, "Dismantle", true)
    defs.addScrapItem( "BatteryBank", "ISA.ISAInverter", 1, 30, true )
    defs.addScrapItem( "BatteryBank", "Radio.ElectricWire", 3, 80, true )
    defs.addScrapItem( "BatteryBank", "Base.ElectronicsScrap", 6, 80, true )
    defs.addScrapItem( "BatteryBank", "Base.MetalBar", 4, 60, true )
    defs.addScrapItem( "BatteryBank", "Base.SmallSheetMetal", 60, 24, true )
end)