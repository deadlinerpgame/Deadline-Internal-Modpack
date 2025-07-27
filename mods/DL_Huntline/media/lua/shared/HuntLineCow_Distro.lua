require 'NPCs/ZombiesZoneDefinition'

HuntLineCow = HuntLineCow or {}

HuntLineCow.outfit0 = "AnimalCow"

Events.OnPostDistributionMerge.Add(function()
   local rate = 0.1
   table.insert(ZombiesZoneDefinition.Default,{name = HuntLineCow.outfit0, chance=rate, });

end)
