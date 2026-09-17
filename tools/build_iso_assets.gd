extends SceneTree

# Monta o TileSet isométrico (a partir do atlas placeholder) e uma cena de
# teste pra validar grid/câmera/projeção antes de qualquer província real.
# Rodar depois de gen_placeholder_atlas.gd + `godot --headless --import`:
#   godot --headless -s tools/build_iso_assets.gd

const ATLAS_PATH := "res://assets/tilesets/placeholder_iso_tiles.png"
const TILE_SET_PATH := "res://assets/tilesets/iso_tileset.tres"
const SCENE_PATH := "res://scenes/IsoTestMap.tscn"
const TILE_SIZE := Vector2i(128, 64)

func _initialize():
	_build_tileset()
	_build_scene()
	quit()

func _build_tileset():
	var texture: Texture2D = load(ATLAS_PATH)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = texture
	atlas.texture_region_size = TILE_SIZE
	for i in range(3):
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
		print("TileSet salvo em ", TILE_SET_PATH)

func _build_scene():
	var tile_set: TileSet = load(TILE_SET_PATH)

	var root := Node2D.new()
	root.name = "IsoTestMap"

	var layer := TileMapLayer.new()
	layer.name = "Ground"
	layer.tile_set = tile_set
	layer.y_sort_enabled = true
	root.add_child(layer)
	layer.owner = root

	# grid 6x6 de demonstração — grama com uma faixa de água na diagonal
	for x in range(6):
		for y in range(6):
			var source_tile := Vector2i(0, 0) # grama
			if x == y:
				source_tile = Vector2i(1, 0) # água
			layer.set_cell(Vector2i(x, y), 0, source_tile)

	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = layer.map_to_local(Vector2i(3, 3))
	camera.zoom = Vector2(1.2, 1.2)
	root.add_child(camera)
	camera.owner = root
	# Nota: setar `current` aqui falha fora da árvore de cena real
	# ("Invalid assignment of property..."). O SKILL/agent que rodar este
	# script deve adicionar `current = true` manualmente no nó Camera2D do
	# .tscn gerado (ou marcar "Make Current" no editor).

	var packed := PackedScene.new()
	var pack_result := packed.pack(root)
	if pack_result != OK:
		push_error("Falha ao empacotar cena (erro %d)" % pack_result)
		return

	var err := ResourceSaver.save(packed, SCENE_PATH)
	if err != OK:
		push_error("Falha ao salvar cena (erro %d)" % err)
	else:
		print("Cena salva em ", SCENE_PATH)
