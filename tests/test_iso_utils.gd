extends GutTest

# Trava a convenção de tile isométrico (seção 12.1.1 do design doc: "mantenha
# proporção 2:1") pra nenhuma cena futura divergir do tile_set/IsoUtils.

func test_tileset_is_isometric_and_matches_convention():
	var tile_set: TileSet = load("res://assets/tilesets/iso_tileset.tres")
	assert_eq(tile_set.tile_shape, TileSet.TILE_SHAPE_ISOMETRIC, "tileset precisa ser isométrico")
	assert_eq(tile_set.tile_size, IsoUtils.TILE_SIZE, "tile_size do tileset precisa bater com IsoUtils.TILE_SIZE")

func test_map_to_world_and_back_round_trips():
	var layer := TileMapLayer.new()
	layer.tile_set = load("res://assets/tilesets/iso_tileset.tres")

	var coord := Vector2i(3, 2)
	var world_pos := IsoUtils.map_to_world(layer, coord)
	var back := IsoUtils.world_to_map(layer, world_pos)

	assert_eq(back, coord, "conversão mapa -> mundo -> mapa deve ser exata")
	layer.free()
