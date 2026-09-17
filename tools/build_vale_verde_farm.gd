extends SceneTree

# Constrói a cena do sítio da família (prefácio, seção 8.1 do design doc):
# casa média, caminho até um galpãozinho, 4 campos plantáveis (2x2, cada um
# 3x a área da casa) com caminho em cruz entre eles, curral+pasto um pouco
# acima dos campos, e terrenos reservados pro celeiro do prefácio e pra casa
# que o personagem constrói depois (seção 8.1: "terreno cedido pelo pai").
# Pressupõe TileSet já construído (tools/build_tileset.gd). Rodar:
#   godot --headless -s tools/build_vale_verde_farm.gd

const TILE_SET_PATH := "res://assets/tilesets/iso_tileset.tres"
const SCENE_PATH := "res://scenes/ValeVerde_SitioDaFamilia.tscn"

# Índices do atlas — ver legenda em tools/gen_placeholder_atlas.gd
const T_GRASS := Vector2i(0, 0)
const T_PATH := Vector2i(2, 0)
const T_FIELD := Vector2i(3, 0)
const T_BUILDING := Vector2i(4, 0)
const T_PASTURE := Vector2i(5, 0)
const T_FENCE := Vector2i(6, 0)
const T_RESERVED := Vector2i(7, 0)

# Bounding box do sítio inteiro (com margem de grama em volta do conteúdo,
# que ocupa x:1-14, y:0-21)
const MIN_X := -2
const MAX_X := 16
const MIN_Y := -2
const MAX_Y := 23

var layer: TileMapLayer
var labels := []  # [ [Vector2i centro, String texto], ... ]

func _initialize():
	var tile_set: TileSet = load(TILE_SET_PATH)

	var root := Node2D.new()
	root.name = "ValeVerdeSitioDaFamilia"

	layer = TileMapLayer.new()
	layer.name = "Ground"
	layer.tile_set = tile_set
	layer.y_sort_enabled = true
	root.add_child(layer)
	layer.owner = root

	_paint_layout()
	_add_labels(root)

	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = layer.map_to_local(Vector2i((MIN_X + MAX_X) / 2, (MIN_Y + MAX_Y) / 2))
	camera.zoom = Vector2(0.45, 0.45)
	root.add_child(camera)
	camera.owner = root
	# Lembrete: adicionar `current = true` manualmente no .tscn gerado
	# (ver nota em tools/build_iso_assets.gd).

	var packed := PackedScene.new()
	var pack_result := packed.pack(root)
	if pack_result != OK:
		push_error("Falha ao empacotar cena (erro %d)" % pack_result)
		quit()
		return

	var err := ResourceSaver.save(packed, SCENE_PATH)
	if err != OK:
		push_error("Falha ao salvar cena (erro %d)" % err)
	else:
		print("Cena salva em ", SCENE_PATH)
	quit()

func _paint_layout() -> void:
	# fundo: grama em todo o sítio
	_fill_rect(MIN_X, MIN_Y, MAX_X, MAX_Y, T_GRASS)

	# casa média (pais)
	_fill_rect(6, 0, 9, 2, T_BUILDING)
	labels.append([Vector2i(7, 1), "Casa (pais)"])

	# terreno reservado — casa do personagem (terreno cedido pelo pai, seção 8.1)
	_fill_rect(2, 0, 5, 2, T_RESERVED)
	labels.append([Vector2i(3, 1), "Reservado:\ncasa do personagem"])

	# galpãozinho + caminho até a casa
	_fill_rect(11, 0, 12, 1, T_BUILDING)
	labels.append([Vector2i(11, 0), "Galpão"])
	_fill_rect(10, 1, 10, 1, T_PATH)

	# terreno reservado — celeiro do prefácio
	_fill_rect(11, 3, 14, 6, T_RESERVED)
	labels.append([Vector2i(12, 4), "Reservado:\nceleiro do prefácio"])

	# curral + pasto, um pouco acima dos campos
	_fill_rect(1, 4, 6, 7, T_PASTURE)
	_fill_rect(1, 4, 2, 5, T_FENCE)
	labels.append([Vector2i(4, 5), "Pasto"])
	labels.append([Vector2i(1, 4), "Curral"])

	# caminho principal da casa até o cruzamento dos campos
	_fill_rect(7, 3, 8, 7, T_PATH)

	# caminho em cruz entre os 4 campos
	_fill_rect(7, 8, 8, 21, T_PATH)
	_fill_rect(1, 14, 14, 15, T_PATH)

	# os 4 campos plantáveis (cada um 6x6 = 3x a área da casa, 4x3=12)
	_fill_rect(1, 8, 6, 13, T_FIELD)
	labels.append([Vector2i(3, 10), "Campo 1"])
	_fill_rect(9, 8, 14, 13, T_FIELD)
	labels.append([Vector2i(11, 10), "Campo 2"])
	_fill_rect(1, 16, 6, 21, T_FIELD)
	labels.append([Vector2i(3, 18), "Campo 3"])
	_fill_rect(9, 16, 14, 21, T_FIELD)
	labels.append([Vector2i(11, 18), "Campo 4"])

func _fill_rect(x0: int, y0: int, x1: int, y1: int, atlas_coord: Vector2i) -> void:
	for x in range(x0, x1 + 1):
		for y in range(y0, y1 + 1):
			layer.set_cell(Vector2i(x, y), 0, atlas_coord)

func _add_labels(root: Node2D) -> void:
	for entry in labels:
		var coord: Vector2i = entry[0]
		var text: String = entry[1]
		var label := Label.new()
		label.text = text
		label.position = layer.map_to_local(coord) - Vector2(0, 40)
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		label.add_theme_constant_override("outline_size", 5)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		root.add_child(label)
		label.owner = root
