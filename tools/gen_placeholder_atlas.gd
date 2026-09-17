extends SceneTree

# Gera um atlas placeholder de tiles isométricos (diamantes coloridos),
# só pra validar grid/projeção antes da arte real (via /review-art) existir.
# Rodar: godot --headless -s tools/gen_placeholder_atlas.gd

const TILE_W := 128
const TILE_H := 64
const OUT_PATH := "res://assets/tilesets/placeholder_iso_tiles.png"

# Índice do atlas = coluna. Ordem é fixa — nunca reordenar, só adicionar no
# final, senão todo tile_map_data já salvo em cenas passa a apontar errado.
# 0 grama · 1 água · 2 caminho/pedra · 3 terra arável (campo) ·
# 4 piso de construção (casa/galpão) · 5 pasto · 6 cerca/curral · 7 reservado
const COLORS := [
	Color(0.35, 0.62, 0.28),
	Color(0.25, 0.45, 0.75),
	Color(0.55, 0.52, 0.48),
	Color(0.45, 0.32, 0.20),
	Color(0.80, 0.70, 0.50),
	Color(0.55, 0.60, 0.25),
	Color(0.35, 0.22, 0.12),
	Color(0.65, 0.60, 0.75),
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
