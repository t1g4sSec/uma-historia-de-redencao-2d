extends SceneTree

# Monta a cena de teste genérica pra validar grid/câmera/projeção antes de
# qualquer província real. Pressupõe que o TileSet já existe (ver
# tools/build_tileset.gd). Rodar:
#   godot --headless -s tools/build_iso_assets.gd

const TILE_SET_PATH := "res://assets/tilesets/iso_tileset.tres"
const SCENE_PATH := "res://scenes/IsoTestMap.tscn"

func _initialize():
	_build_scene()
	quit()

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
