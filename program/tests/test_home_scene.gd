extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING HOME SCENE ---")
	
	# 1. Check file exists
	var scene_path = "res://scenes/home.tscn"
	if not ResourceLoader.exists(scene_path):
		printerr("TEST FAIL: Scene file not found: ", scene_path)
		get_tree().quit(1)
		return
	print("TEST PASS: Scene file exists.")
	
	# 2. Check loading as PackedScene
	var scene = ResourceLoader.load(scene_path)
	if not (scene is PackedScene):
		printerr("TEST FAIL: Resource is not PackedScene: ", scene)
		get_tree().quit(1)
		return
	print("TEST PASS: Scene loaded as PackedScene.")
	
	# 3. Instantiate scene
	var home_instance = scene.instantiate()
	if home_instance == null:
		printerr("TEST FAIL: Instantiation failed.")
		get_tree().quit(1)
		return
	print("TEST PASS: Scene instantiated successfully.")
	
	# 4. Add to tree to trigger _ready()
	add_child(home_instance)
	print("TEST PASS: Scene added to tree and _ready() triggered.")
	
	# 5. Check node structure
	var required_nodes = [
		"Background",
		"ElementMenu",
		"LevelButtons",
		"LevelButtons/BtnLevel1",
		"LevelButtons/BtnLevel2",
		"LevelButtons/BtnLevel3",
		"LevelButtons/BtnLevel4",
		"BtnHome",
		"BtnMateri",
		"BtnSoundOrange",
		"BtnSoundXOrange"
	]
	
	for path in required_nodes:
		var node = home_instance.get_node_or_null(path)
		if node == null:
			printerr("TEST FAIL: Missing node: ", path)
			get_tree().quit(1)
			return
		print("TEST PASS: Found node ", path)
	
	# 6. Check script onready references
	if home_instance.btn_sound == null or home_instance.btn_sound_x == null:
		printerr("TEST FAIL: Sound buttons not assigned in script.")
		get_tree().quit(1)
		return
	if home_instance.btn_lvl1 == null or home_instance.btn_lvl4 == null:
		printerr("TEST FAIL: Level buttons not assigned in script.")
		get_tree().quit(1)
		return
	print("TEST PASS: Script @onready variables verified.")
	
	# 7. Check button signal connections
	assert(home_instance.get_node("BtnHome").pressed.is_connected(home_instance._on_btn_home_pressed))
	assert(home_instance.get_node("BtnMateri").pressed.is_connected(home_instance._on_btn_materi_pressed))
	assert(home_instance.get_node("BtnSoundOrange").pressed.is_connected(home_instance._on_btn_sound_pressed))
	assert(home_instance.get_node("BtnSoundXOrange").pressed.is_connected(home_instance._on_btn_sound_x_pressed))
	assert(home_instance.get_node("LevelButtons/BtnLevel1").pressed.is_connected(home_instance._on_btn_level1_pressed))
	assert(home_instance.get_node("LevelButtons/BtnLevel4").pressed.is_connected(home_instance._on_btn_level4_pressed))
	print("TEST PASS: All button signal connections verified.")
	
	# 8. Check button sound toggle behavior
	home_instance._on_btn_sound_pressed()
	assert(home_instance.is_muted == true)
	assert(home_instance.btn_sound.visible == false)
	assert(home_instance.btn_sound_x.visible == true)
	
	home_instance._on_btn_sound_x_pressed()
	assert(home_instance.is_muted == false)
	assert(home_instance.btn_sound.visible == true)
	assert(home_instance.btn_sound_x.visible == false)
	print("TEST PASS: Sound toggle behavior verified.")
	
	# 9. Check Level Locking Progression
	Global.max_unlocked_level = 1
	home_instance._update_level_locks()
	assert(home_instance._is_button_locked(home_instance.btn_lvl1) == false)
	assert(home_instance._is_button_locked(home_instance.btn_lvl2) == true)
	assert(home_instance._is_button_locked(home_instance.btn_lvl3) == true)
	assert(home_instance._is_button_locked(home_instance.btn_lvl4) == true)
	assert(home_instance.btn_lvl2.get_node("LockOverlay").visible == true)
	assert(home_instance.btn_lvl3.get_node("LockOverlay").visible == true)
	assert(home_instance.btn_lvl4.get_node("LockOverlay").visible == true)
	print("TEST PASS: Level locking at initial state verified (Only Level 1 unlocked).")
	
	# Test unlocking Level 2
	Global.max_unlocked_level = 2
	home_instance._update_level_locks()
	assert(home_instance._is_button_locked(home_instance.btn_lvl2) == false)
	assert(home_instance.btn_lvl2.get_node("LockOverlay").visible == false)
	assert(home_instance._is_button_locked(home_instance.btn_lvl3) == true)
	assert(home_instance.btn_lvl3.get_node("LockOverlay").visible == true)
	print("TEST PASS: Level 2 unlock progression verified.")
	
	Global.max_unlocked_level = 1
	home_instance._update_level_locks()
	
	print("=== ALL TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
