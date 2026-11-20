extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING LEVEL 2 SCENE ---")
	
	var scene_path = "res://scenes/levels/level_2_kondensasi.tscn"
	assert(FileAccess.file_exists(scene_path), "Level 2 scene file must exist")
	print("TEST PASS: Scene file exists.")
	
	var packed = load(scene_path) as PackedScene
	assert(packed != null, "Scene must be a valid PackedScene")
	print("TEST PASS: Scene loaded as PackedScene.")
	
	var instance = packed.instantiate()
	assert(instance != null, "Scene must instantiate successfully")
	print("TEST PASS: Scene instantiated.")
	
	add_child(instance)
	print("TEST PASS: Scene added to tree and _ready() ran.")
	
	# Initial assertions (Warm 35°C)
	assert(instance.slider_suhu.value == 35.0, "Initial temperature should be 35°C")
	assert(instance.btn_next.visible == false, "Next button should be hidden initially")
	assert(instance.vapor_nodes.size() == 16, "Should spawn 16 vapor particles")
	assert(instance.awan1.modulate.a <= 0.2, "Clouds should start faint")
	print("TEST PASS: Initial state (Warm) verified.")
	
	# Check knob icon at warm
	var warm_grabber = instance.slider_suhu.get_theme_icon("grabber")
	assert(warm_grabber == instance.TEX_KNOB_KUNING, "Knob should be yellow when warm")
	print("TEST PASS: Warm knob (yellow) verified.")
	
	# Move temperature higher (wrong pattern test)
	instance.slider_suhu.value = 38.0
	assert(instance.wrong_pattern_attempts == 1, "Must track wrong pattern attempt when heating up")
	print("TEST PASS: CT pattern error tracking verified.")
	
	# Move temperature down to cold (5°C)
	instance.slider_suhu.value = 5.0
	var cold_grabber = instance.slider_suhu.get_theme_icon("grabber")
	assert(cold_grabber == instance.TEX_KNOB_BIRU, "Knob should switch to blue when cold")
	print("TEST PASS: Cold knob (blue) verified.")
	
	# Simulate process delta under cold temperature
	instance._process(2.0)
	assert(instance.condensation_progress > 0.0, "Condensation should progress when cold")
	assert(instance.awan1.modulate.a > 0.15, "Clouds should become more visible")
	print("TEST PASS: Condensation progress & cloud formation verified.")
	
	# Complete level
	instance.condensation_progress = 100.0
	instance._on_condensation_completed()
	assert(instance.level_completed == true, "Level must be marked completed")
	assert(instance.btn_next.visible == true, "Next button must be visible upon completion")
	print("TEST PASS: Level completion verified.")
	
	# Verify card title and dynamic fill color
	var title_lbl = instance.get_node("UI/PanelSuhuCard/LblCardTitle") as Label
	assert(title_lbl != null and title_lbl.text == "Suhu Atmosfer", "Title must be Suhu Atmosfer")
	assert(instance.slider_fill_style != null, "Slider fill stylebox must be initialized")
	assert(instance.slider_fill_style.bg_color.b > 0.8, "Fill color should be blue when cold (5°C)")
	print("TEST PASS: Card title and dynamic fill color verified.")
	
	print("=== ALL LEVEL 2 TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
