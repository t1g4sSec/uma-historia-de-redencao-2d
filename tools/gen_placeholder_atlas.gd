extends SceneTree

# Gera um atlas placeholder de tiles isométricos (diamantes coloridos),
# só pra validar grid/projeção antes da arte real (via /review-art) existir.
# Rodar: godot --headless -s tools/gen_placeholder_atlas.gd

const TILE_W := 128
const TILE_H := 64
const OUT_PATH := "res://assets/tilesets/placeholder_iso_tiles.png"

# grama, água, pedra/caminho
const COLORS := [
	Color(0.35, 0.62, 0.28),
	Color(0.25, 0.45, 0.75),
	Color(0.55, 0.52, 0.48),
]

func _initialize():
	var cols = COLORS.size()
	var img := Image.create(TILE_W * cols, TILE_H, false, Image.FORMAT_RGBA8)
	for i in range(cols):
		_draw_diamond(img, i * TILE_W, 0, TILE_W, TILE_H, COLORS[i])
	var err := img.save_png(OUT_PATH)
	if err != OK:
		push_error("Falha ao salvar %s (erro %d)" % [OUT_PATH, err])
	else:
		print("Atlas placeholder salvo em ", OUT_PATH)
	quit()

func _draw_diamond(img: Image, ox: int, oy: int, w: int, h: int, color: Color) -> void:
	var hw := w / 2.0
	var hh := h / 2.0
	var border := color.darkened(0.35)
	for y in range(h):
		for x in range(w):
			var dx = abs((x + 0.5) - hw) / hw
			var dy = abs((y + 0.5) - hh) / hh
			var d = dx + dy
			if d <= 1.0:
				img.set_pixel(ox + x, oy + y, border if d > 0.92 else color)
