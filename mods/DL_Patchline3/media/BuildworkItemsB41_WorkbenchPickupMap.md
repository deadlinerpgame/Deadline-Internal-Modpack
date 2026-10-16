# BuildworkItemsB41 workbench pickup mapping

Use these tile-to-item mappings when adding pickup properties so dismantling/picking up a built bench returns its construction kit. Item identifiers are fully qualified. Workbench names come from `workbenches.json`; kit display names come from `knox_buildworks_kits.txt`.

## Kit inventory

| Workbench | Construction set item | Kit display name | Tile sprites |
|---|---|---|---|
| Brewing Station | `Base.BrewingStationConstructionSet` | Brewing Station Kit | `dl_workbenches_20`, `dl_workbenches_21` |
| Butchering Hook | `Base.ButcheringHookConstructionSet` | Butchering Hook Kit | `aerx_tools_15` |
| Clothing Bench | `Base.ClothingBenchConstructionSet` | Clothing Bench Kit | `Table_tiles_0`, `Table_tiles_1`, `Table_tiles_8`, `Table_tiles_9` |
| Anaerobic Digester | `Base.DigesterConstructionSet` | Anaerobic Digester Kit | `dl_workbenches_0`, `dl_workbenches_1`, `dl_workbenches_2`, `dl_workbenches_3` |
| Distiller | `Base.DistillerConstructionSet` | Distiller Kit | `dl_workbenches_12`, `dl_workbenches_13`, `dl_workbenches_14`, `dl_workbenches_15`, `dl_workbenches_16`, `dl_workbenches_17`, `dl_workbenches_18`, `dl_workbenches_19` |
| Drying Rack | `Base.DryingRackConstructionSet` | Drying Rack Kit | `aerx_tools_82`, `aerx_tools_83`, `aerx_tools_84`, `aerx_tools_85` |
| Advanced Forge | `Base.ForgeAdvancedConstructionSet` | Advanced Forge Kit | `aerx_tools_20`, `aerx_tools_26`, `aerx_tools_27`, `aerx_tools_33`, `aerx_tools_34` |
| Simple Forge | `Base.ForgeSimpleConstructionSet` | Simple Forge Kit | `aerx_tools_16`, `aerx_tools_18`, `aerx_tools_20`, `aerx_tools_21`, `aerx_tools_22` |
| Advanced Furnace | `Base.FurnaceAdvancedConstructionSet` | Advanced Furnace Kit | `aerx_tools_40`, `aerx_tools_41`, `aerx_tools_42`, `aerx_tools_43` |
| Simple Furnace | `Base.FurnaceSimpleConstructionSet` | Simple Furnace Kit | `aerx_tools_35`, `aerx_tools_37` |
| Hand Press | `Base.HandPressConstructionSet` | Hand Press Kit | `aerx_tools_86`, `aerx_tools_87` |
| Advanced Kiln | `Base.KilnAdvancedConstructionSet` | Advanced Kiln Kit | `aerx_tools_4`, `aerx_tools_5`, `aerx_tools_8`, `aerx_tools_9` |
| Simple Kiln | `Base.KilnSimpleConstructionSet` | Simple Kiln Kit | `aerx_tools_0`, `aerx_tools_2` |
| Paint Mixing Table | `Base.PaintMixingConstructionSet` | Paint Mixing Kit | `core_workbenches_0`, `core_workbenches_1`, `core_workbenches_2`, `core_workbenches_3`, `core_workbenches_4`, `core_workbenches_5`, `core_workbenches_6`, `core_workbenches_7` |
| Repair Bench | `Base.RepairBenchConstructionSet` | Repair Bench Kit | `fears_workbenches_10`, `fears_workbenches_11`, `fears_workbenches_2`, `fears_workbenches_3` |
| Sculpting Table | `Base.SculptingTableConstructionSet` | Sculpting Table Kit | `aerx_tools_88`, `aerx_tools_89` |
| Tailoring Table | `Base.TailorTableConstructionSet` | Tailoring Table Kit | `industry_tk_02_88`, `industry_tk_02_89`, `industry_tk_02_90`, `industry_tk_02_91`, `industry_tk_02_92`, `industry_tk_02_93`, `industry_tk_02_94`, `industry_tk_02_95` |
## Tile mappings

| Tile sprite | Built workbench | Return item | Readable source |
|---|---|---|---|
| `aerx_tools_0` | Simple Kiln | `Base.KilnSimpleConstructionSet` (Simple Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_15` | Butchering Hook | `Base.ButcheringHookConstructionSet` (Butchering Hook Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_16` | Simple Forge | `Base.ForgeSimpleConstructionSet` (Simple Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_18` | Simple Forge | `Base.ForgeSimpleConstructionSet` (Simple Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_2` | Simple Kiln | `Base.KilnSimpleConstructionSet` (Simple Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_20` | Advanced Forge | `Base.ForgeAdvancedConstructionSet` (Advanced Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_20` | Simple Forge | `Base.ForgeSimpleConstructionSet` (Simple Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_21` | Simple Forge | `Base.ForgeSimpleConstructionSet` (Simple Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_22` | Simple Forge | `Base.ForgeSimpleConstructionSet` (Simple Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_26` | Advanced Forge | `Base.ForgeAdvancedConstructionSet` (Advanced Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_27` | Advanced Forge | `Base.ForgeAdvancedConstructionSet` (Advanced Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_33` | Advanced Forge | `Base.ForgeAdvancedConstructionSet` (Advanced Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_34` | Advanced Forge | `Base.ForgeAdvancedConstructionSet` (Advanced Forge Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_35` | Simple Furnace | `Base.FurnaceSimpleConstructionSet` (Simple Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_37` | Simple Furnace | `Base.FurnaceSimpleConstructionSet` (Simple Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_4` | Advanced Kiln | `Base.KilnAdvancedConstructionSet` (Advanced Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_40` | Advanced Furnace | `Base.FurnaceAdvancedConstructionSet` (Advanced Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_41` | Advanced Furnace | `Base.FurnaceAdvancedConstructionSet` (Advanced Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_42` | Advanced Furnace | `Base.FurnaceAdvancedConstructionSet` (Advanced Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_43` | Advanced Furnace | `Base.FurnaceAdvancedConstructionSet` (Advanced Furnace Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_5` | Advanced Kiln | `Base.KilnAdvancedConstructionSet` (Advanced Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_8` | Advanced Kiln | `Base.KilnAdvancedConstructionSet` (Advanced Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_82` | Drying Rack | `Base.DryingRackConstructionSet` (Drying Rack Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_83` | Drying Rack | `Base.DryingRackConstructionSet` (Drying Rack Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_84` | Drying Rack | `Base.DryingRackConstructionSet` (Drying Rack Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_85` | Drying Rack | `Base.DryingRackConstructionSet` (Drying Rack Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_86` | Hand Press | `Base.HandPressConstructionSet` (Hand Press Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_87` | Hand Press | `Base.HandPressConstructionSet` (Hand Press Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_88` | Sculpting Table | `Base.SculptingTableConstructionSet` (Sculpting Table Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_89` | Sculpting Table | `Base.SculptingTableConstructionSet` (Sculpting Table Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `aerx_tools_9` | Advanced Kiln | `Base.KilnAdvancedConstructionSet` (Advanced Kiln Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `core_workbenches_0` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_1` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_2` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_3` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_4` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_5` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_6` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `core_workbenches_7` | Paint Mixing Table | `Base.PaintMixingConstructionSet` (Paint Mixing Kit) | No readable .tiles.txt definition located |
| `dl_workbenches_0` | Anaerobic Digester | `Base.DigesterConstructionSet` (Anaerobic Digester Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_1` | Anaerobic Digester | `Base.DigesterConstructionSet` (Anaerobic Digester Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_12` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_13` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_14` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_15` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_16` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_17` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_18` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_19` | Distiller | `Base.DistillerConstructionSet` (Distiller Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_2` | Anaerobic Digester | `Base.DigesterConstructionSet` (Anaerobic Digester Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_20` | Brewing Station | `Base.BrewingStationConstructionSet` (Brewing Station Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_21` | Brewing Station | `Base.BrewingStationConstructionSet` (Brewing Station Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `dl_workbenches_3` | Anaerobic Digester | `Base.DigesterConstructionSet` (Anaerobic Digester Kit) | DL_TilepackLine/media/deadline.tiles.txt (excluded; do not copy) |
| `fears_workbenches_10` | Repair Bench | `Base.RepairBenchConstructionSet` (Repair Bench Kit) | No readable .tiles.txt definition located |
| `fears_workbenches_11` | Repair Bench | `Base.RepairBenchConstructionSet` (Repair Bench Kit) | No readable .tiles.txt definition located |
| `fears_workbenches_2` | Repair Bench | `Base.RepairBenchConstructionSet` (Repair Bench Kit) | No readable .tiles.txt definition located |
| `fears_workbenches_3` | Repair Bench | `Base.RepairBenchConstructionSet` (Repair Bench Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_88` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_89` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_90` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_91` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_92` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_93` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_94` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `industry_tk_02_95` | Tailoring Table | `Base.TailorTableConstructionSet` (Tailoring Table Kit) | No readable .tiles.txt definition located |
| `Table_tiles_0` | Clothing Bench | `Base.ClothingBenchConstructionSet` (Clothing Bench Kit) | DL_TilepackLine/media/Tables_tiles.tiles.txt (tile index implied by coordinates; excluded from copy) |
| `Table_tiles_1` | Clothing Bench | `Base.ClothingBenchConstructionSet` (Clothing Bench Kit) | DL_TilepackLine/media/Tables_tiles.tiles.txt (tile index implied by coordinates; excluded from copy) |
| `Table_tiles_8` | Clothing Bench | `Base.ClothingBenchConstructionSet` (Clothing Bench Kit) | DL_TilepackLine/media/Tables_tiles.tiles.txt (tile index implied by coordinates; excluded from copy) |
| `Table_tiles_9` | Clothing Bench | `Base.ClothingBenchConstructionSet` (Clothing Bench Kit) | DL_TilepackLine/media/Tables_tiles.tiles.txt (tile index implied by coordinates; excluded from copy) |

## Definition source gaps

- No readable `.tiles.txt` definitions were located in the internal repo for these sprites: `core_workbenches_0`, `core_workbenches_1`, `core_workbenches_2`, `core_workbenches_3`, `core_workbenches_4`, `core_workbenches_5`, `core_workbenches_6`, `core_workbenches_7`, `fears_workbenches_10`, `fears_workbenches_11`, `fears_workbenches_2`, `fears_workbenches_3`, `industry_tk_02_88`, `industry_tk_02_89`, `industry_tk_02_90`, `industry_tk_02_91`, `industry_tk_02_92`, `industry_tk_02_93`, `industry_tk_02_94`, `industry_tk_02_95`. They are identified in the BuildworkItemsB41 geometry but still need their owning tile definition/source located before their tile properties can be patched.

## Shared sprite note

- `aerx_tools_20` is shared by the Simple Forge and Advanced Forge geometry in `workbenches.json`, so the same sprite maps to both construction set items. Verify which placed object context the pickup patch can inspect before assigning a single return item to this sprite.

## Source/copy notes

- All listed bench sprite IDs were found in the `workbenches.json` built geometry, and each has a kit input in that definition.
- The readable sprite definitions found for these workbenches are owned by `DL_TilepackLine` (notably `deadline.tiles.txt` and `Tables_tiles.tiles.txt`). No tile definitions from `DL_TilepackLine` were copied to `DL_Patchline3` per instruction; those sprite IDs are listed above for patching by reference.
- Among `.tiles` files outside `DL_TilepackLine`, only `BuildworkB41/media/knox_buildworks_pack.tiles` was found in the internal mod tree. It was copied unchanged to `DL_Patchline3/media/knox_buildworks_pack.patch.tiles`. It does not define the listed workbench sprite IDs, so no matching non-TilepackLine tile source was available for those benches.
- The copied `.tiles` file is the source file renamed as requested; its binary format was preserved. Tile property patch behavior still needs validation in the B41 game.

