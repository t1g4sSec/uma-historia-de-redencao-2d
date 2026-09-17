extends SceneTree

# Ferramenta de dev: carrega uma cena, espera alguns frames renderizarem e
# salva um screenshot. Precisa rodar SEM --headless (renderer dummy não
# desenha nada). Uso: godot --path . -s tools/screenshot_scene.gd -- <cena> <saida.png>

func _initialize():
	var args := OS.get_cmdline_user_args()
	var scene_path := "res://scenes/IsoTestMap.tscn" if args.size() < 1 else args[0]
	var out_path := "res://tools/_screenshot.png" if args.size() < 2 else args[1]
	var scene: Node = load(scene_path).instantiate()
	root.add_child(scene)
	_wait_and_capture(out_path)

func _wait_and_capture(out_path: String) -> void:
	for i in range(10):
		await process_frame
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(out_path)
	print("Screenshot salvo em ", out_path)
	quit()
