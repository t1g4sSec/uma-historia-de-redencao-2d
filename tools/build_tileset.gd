extends SceneTree

# (Re)constrói o TileSet isométrico de referência do projeto a partir do
# atlas placeholder — roda depois de qualquer mudança em gen_placeholder_atlas.gd.
# Sempre lê a largura do atlas pra registrar todas as colunas/tiles existentes,
# então só ADICIONE colunas novas no atlas, nunca reordene as existentes.
# Rodar (com o atlas já importado — `godot --headless --import` antes):
#   godot --headless -s tools/build_tileset.gd

const ATLAS_PATH := "res://assets/tilesets/placeholder_iso_tiles.png"
const TILE_SET_PATH := "res://assets/tilesets/iso_tileset.tres"
const TILE_SIZE := Vector2i(128, 64)

func _initialize():
	var texture: Texture2D = load(ATLAS_PATH)
	var tile_count := int(texture.get_width() / TILE_SIZE.x)

	var atlas := TileSetAtlasSource.new()
	atlas.texture = texture
	atlas.texture_region_size = TILE_SIZE
	for i in range(tile_count):
		atlas.create_tile(Vector2i(i, 0))

	var tile_set := TileSet.new()
	tile_set.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	tile_set.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_DOWN
	tile_set.tile_size = TILE_SIZE
	tile_set.add_source(atlas, 0)

	var err := ResourceSaver.save(tile_set, TILE_SET_PATH)
	if err != OK:
		push_error("Falha ao salvar tileset (erro %d)" % err)
	else:
		print("TileSet salvo em %s com %d tiles" % [TILE_SET_PATH, tile_count])
	quit()
