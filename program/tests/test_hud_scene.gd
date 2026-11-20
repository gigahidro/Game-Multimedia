extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING IMMERSIVE HUD SCENE (NO PILLAR/SCORE DISTRACTION) ---")
	
	var hud_scene = load("res://scenes/ui/hud.tscn")
	assert(hud_scene != null, "HUD scene failed to load")
	print("TEST PASS: Scene loaded as PackedScene.")
	
	var hud_inst = hud_scene.instantiate()
	assert(hud_inst != null, "HUD instance is null")
	add_child(hud_inst)
	print("TEST PASS: HUD instantiated and added to tree.")
	
	# Verify clean HUD nodes (no distracting CT labels or scores during gameplay)
	assert(hud_inst.get_node_or_null("TopLeftControls") == null, "TopLeftControls must be absent for clean immersion")
	assert(hud_inst.get_node_or_null("TopRightControls/BtnSoundOrange") != null, "BtnSoundOrange missing")
	assert(hud_inst.get_node_or_null("BottomLeftControls/BtnHome") != null, "BtnHome missing")
	assert(hud_inst.get_node_or_null("BottomLeftControls/BtnMateri") != null, "BtnMateri missing")
	print("TEST PASS: Clean immersion HUD verified (no CT jargon or score pressure).")
	
	# Test safe method calls
	hud_inst.set_pillar("Pilar CT: Dekomposisi")
	hud_inst.set_help_instruction("Test instruction")
	hud_inst.update_hud()
	print("TEST PASS: Safe no-op methods verified.")
	
	print("=== ALL IMMERSIVE HUD TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
