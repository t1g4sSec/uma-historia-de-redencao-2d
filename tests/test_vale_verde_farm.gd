extends GutTest

# Trava o layout do sítio da família (prefácio, seção 8.1 do design doc)
# contra regressão acidental ao editar tools/build_vale_verde_farm.gd.

const SCENE_PATH := "res://scenes/ValeVerde_SitioDaFamilia.tscn"

var scene: Node2D
var layer: TileMapLayer

func before_each():
	scene = load(SCENE_PATH).instantiate()
	layer = scene.get_node("Ground")

func after_each():
	scene.free()

func test_house_tile_is_building():
	assert_eq(layer.get_cell_atlas_coords(Vector2i(7, 1)), Vector2i(4, 0), "casa deve ser piso de construção")

func test_field_tiles_are_field():
	assert_eq(layer.get_cell_atlas_coords(Vector2i(3, 10)), Vector2i(3, 0), "Campo 1")
	assert_eq(layer.get_cell_atlas_coords(Vector2i(11, 18)), Vector2i(3, 0), "Campo 4")

func test_cross_path_separates_the_four_fields():
	assert_eq(layer.get_cell_atlas_coords(Vector2i(7, 14)), Vector2i(2, 0), "cruzamento do caminho entre os campos")

func test_reserved_plots_are_marked():
	assert_eq(layer.get_cell_atlas_coords(Vector2i(3, 1)), Vector2i(7, 0), "reservado: casa do personagem")
	assert_eq(layer.get_cell_atlas_coords(Vector2i(12, 4)), Vector2i(7, 0), "reservado: celeiro do prefácio")

func test_corral_is_above_the_fields():
	assert_eq(layer.get_cell_atlas_coords(Vector2i(1, 4)), Vector2i(6, 0), "curral")
	assert_eq(layer.get_cell_atlas_coords(Vector2i(4, 5)), Vector2i(5, 0), "pasto")
