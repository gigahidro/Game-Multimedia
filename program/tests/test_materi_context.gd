extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING MATERI RETURN BUTTON CONTEXT ---")
	
	var scene_path = "res://scenes/materi.tscn"
	var packed = load(scene_path) as PackedScene
	assert(packed != null, "Scene must exist and be valid")
	
	# Case 1: Opened from Home
	Global.previous_scene = "res://scenes/home.tscn"
	var inst_home = packed.instantiate()
	add_child(inst_home)
	assert(inst_home.opened_from_level == false, "Should be marked opened from home")
	assert(inst_home.btn_home.texture_normal == inst_home.TEX_HOME, "Should use button_home texture")
	print("TEST PASS: Home context verified.")
	inst_home.queue_free()
	
	# Case 2: Opened from Level 1
	Global.previous_scene = "res://scenes/levels/level_1_evaporasi.tscn"
	var inst_level = packed.instantiate()
	add_child(inst_level)
	assert(inst_level.opened_from_level == true, "Should be marked opened from level")
	assert(inst_level.btn_home.texture_normal == inst_level.TEX_CLOSE, "Should use button_close texture")
	print("TEST PASS: Level context (replaced with button_close) verified.")
	inst_level.queue_free()
	
	print("=== ALL MATERI CONTEXT TESTS PASSED ===")
	get_tree().quit(0)
