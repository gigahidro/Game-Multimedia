extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING LEVEL 1 SCENE ---")
	
	var scene_path = "res://scenes/levels/level_1_evaporasi.tscn"
	assert(FileAccess.file_exists(scene_path), "Level 1 scene file should exist")
	print("TEST PASS: Scene file exists.")
	
	var packed = load(scene_path) as PackedScene
	assert(packed != null, "Scene must be a valid PackedScene")
	print("TEST PASS: Scene loaded as PackedScene.")
	
	var instance = packed.instantiate()
	assert(instance != null, "Scene must instantiate successfully")
	print("TEST PASS: Scene instantiated.")
	
	add_child(instance)
	print("TEST PASS: Scene added to tree and _ready() ran.")
	
	# Initial assertions (Malam)
	assert(instance.is_daytime == false, "Must start as nighttime")
	assert(instance.bg_siang.modulate.a == 0.0, "Day background should be transparent")
	assert(instance.uap_laut.emitting == false, "Sea vapor must not emit at night")
	assert(instance.uap_pohon.emitting == false, "Tree vapor must not emit at night")
	assert(instance.btn_next.visible == false, "Next button should be hidden initially")
	print("TEST PASS: Initial night state verified.")
	
	# Setting slider value triggers signal 'value_changed' which calls _on_slider_suhu_value_changed
	instance.slider_suhu.value = 55.0
	print("DEBUG: wrong_order_count =", instance.wrong_order_count)
	assert(instance.wrong_order_count == 1, "Must track wrong decomposition order")
	print("TEST PASS: CT decomposition error tracking verified.")
	
	# Trigger transition to daytime
	instance._on_btn_transisi_siang_pressed()
	assert(instance.is_daytime == true, "Must become daytime")
	print("TEST PASS: Daytime transition state verified.")
	
	# Progress evaporation with delta
	instance._process(2.0)
	assert(instance.evaporation_progress > 0.0, "Evaporation should progress when hot and daytime")
	assert(instance.uap_laut.emitting == true, "Sea vapor should emit")
	assert(instance.uap_pohon.emitting == true, "Tree vapor should emit")
	print("TEST PASS: Vapor emission and progress verified.")
	
	# Complete level
	instance.evaporation_progress = 100.0
	instance._on_evaporation_completed()
	assert(instance.level_completed == true, "Level must be marked completed")
	assert(instance.btn_next.visible == true, "Next button must be visible upon completion")
	print("TEST PASS: Level completion verified.")
	
	# Verify card title and dynamic fill color
	var title_lbl = instance.get_node("UI/PanelSuhuCard/LblCardTitle") as Label
	assert(title_lbl != null and title_lbl.text == "Intensitas Matahari", "Title must be Intensitas Matahari")
	assert(instance.slider_fill_style != null, "Slider fill stylebox must be initialized")
	assert(instance.slider_fill_style.bg_color.r > 0.8, "Fill color should be orange/red when hot (55°C)")
	print("TEST PASS: Card title and dynamic fill color verified.")
	
	print("=== ALL LEVEL 1 TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
