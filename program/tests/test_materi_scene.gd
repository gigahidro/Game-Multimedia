extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING MATERI SCENE ---")
	
	var scene_path = "res://scenes/materi.tscn"
	assert(FileAccess.file_exists(scene_path), "Scene file should exist")
	print("TEST PASS: Scene file exists.")
	
	var packed = load(scene_path) as PackedScene
	assert(packed != null, "Scene must be a valid PackedScene")
	print("TEST PASS: Scene loaded as PackedScene.")
	
	var instance = packed.instantiate()
	assert(instance != null, "Scene must instantiate successfully")
	print("TEST PASS: Scene instantiated.")
	
	add_child(instance)
	print("TEST PASS: Scene added to tree and _ready() ran.")
	
	# Verify initial state (slide 0)
	assert(instance.current_slide == 0, "Initial slide should be 0")
	assert(instance.btn_back.visible == false, "Back button should be hidden on slide 0")
	assert(instance.btn_next.visible == true, "Next button should be visible on slide 0")
	assert(instance.btn_close.visible == false, "Close button should be hidden on slide 0")
	assert(instance.btn_home.visible == true, "Home button should be visible")
	print("TEST PASS: Slide 0 initial state verified.")
	
	# Advance to slide 1
	instance._on_btn_next_pressed()
	assert(instance.current_slide == 1, "Slide should be 1")
	assert(instance.btn_back.visible == true, "Back button visible on slide 1")
	assert(instance.btn_next.visible == true, "Next button visible on slide 1")
	assert(instance.btn_close.visible == false, "Close button hidden on slide 1")
	print("TEST PASS: Slide 1 state verified.")
	
	# Advance to slide 2
	instance._on_btn_next_pressed()
	assert(instance.current_slide == 2, "Slide should be 2")
	assert(instance.btn_back.visible == true, "Back button visible on slide 2")
	assert(instance.btn_next.visible == true, "Next button visible on slide 2")
	assert(instance.btn_close.visible == false, "Close button hidden on slide 2")
	print("TEST PASS: Slide 2 state verified.")
	
	# Advance to slide 3 (final slide)
	instance._on_btn_next_pressed()
	assert(instance.current_slide == 3, "Slide should be 3 (last)")
	assert(instance.btn_back.visible == true, "Back button visible on slide 3")
	assert(instance.btn_next.visible == false, "Next button HIDDEN on slide 3")
	assert(instance.btn_close.visible == true, "Close button VISIBLE on slide 3")
	print("TEST PASS: Slide 3 (last slide) Close button replaced Next button successfully.")
	
	# Back to slide 2
	instance._on_btn_back_pressed()
	assert(instance.current_slide == 2, "Slide should be 2 after back")
	assert(instance.btn_next.visible == true, "Next button visible again")
	assert(instance.btn_close.visible == false, "Close button hidden again")
	print("TEST PASS: Slide back navigation verified.")
	
	# Verify sound toggling
	instance._on_btn_sound_pressed()
	assert(instance.btn_sound.visible == false, "Sound button should hide when muted")
	assert(instance.btn_sound_x.visible == true, "Sound X button should show when muted")
	instance._on_btn_sound_x_pressed()
	assert(instance.btn_sound.visible == true, "Sound button should show when unmuted")
	assert(instance.btn_sound_x.visible == false, "Sound X button should hide when unmuted")
	print("TEST PASS: Sound toggle verified.")
	
	print("=== ALL MATERI TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
