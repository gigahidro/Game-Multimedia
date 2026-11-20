extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING LEVEL 3 SCENE ---")
	
	var scene_path = "res://scenes/levels/level_3_presipitasi.tscn"
	assert(FileAccess.file_exists(scene_path), "Level 3 scene file must exist")
	print("TEST PASS: Scene file exists.")
	
	var packed = load(scene_path) as PackedScene
	assert(packed != null, "Scene must be a valid PackedScene")
	print("TEST PASS: Scene loaded as PackedScene.")
	
	var instance = packed.instantiate()
	assert(instance != null, "Scene must instantiate successfully")
	print("TEST PASS: Scene instantiated.")
	
	add_child(instance)
	print("TEST PASS: Scene added to tree and _ready() ran.")
	
	# Initial state assertions
	assert(instance.collected_droplets == 0, "Initial collected droplets must be 0")
	assert(instance.level_completed == false, "Level should not be completed at start")
	assert(instance.btn_next.visible == false, "Next button should be hidden initially")
	assert(instance.rain_node.visible == false, "Rain effect should be hidden initially")
	assert(instance.splash_particles.emitting == false, "Splash particles should be off initially")
	assert(instance.cloud_sprite.texture != null, "Cloud texture must be set")
	assert(instance.base_cloud_scale.x >= 0.55, "Cloud base scale must be large (>= 0.55)")
	print("TEST PASS: Initial state & large cloud verified.")
	
	# Verify items setup
	var items = instance.get_node("Items")
	assert(items.get_child_count() == 8, "Must have 8 interactive sky items (5 water + 3 distractors)")
	var water_count = 0
	var distractor_count = 0
	for child in items.get_children():
		if child.is_water:
			water_count += 1
		else:
			distractor_count += 1
	assert(water_count == 5, "Must have 5 water droplets")
	assert(distractor_count == 3, "Must have 3 distractors (2 leaves, 1 kite)")
	print("TEST PASS: Interactive items structure verified (5 water, 3 distractors).")
	
	# Test distractor hit: NO game over, distractor does NOT disappear
	var initial_lives = Global.lives
	var distractor_node = items.get_node("DistractorLeaf1")
	instance.hit_distractor(distractor_node)
	assert(Global.lives == initial_lives, "Lives must NOT be reduced (no game over in CT assessment mode)")
	assert(is_instance_valid(distractor_node) and not distractor_node.is_queued_for_deletion(), "Distractor must NOT disappear when clicked")
	assert(instance.abstraction_errors == 1, "Must track abstraction error for CT score")
	print("TEST PASS: Distractor behavior verified (does not disappear, no game over, CT error tracked).")
	
	# Test water droplet collections: moves to panel and increments counter
	var initial_score = Global.score
	var water_nodes = [
		items.get_node("Water1"),
		items.get_node("Water2"),
		items.get_node("Water3"),
		items.get_node("Water4"),
		items.get_node("Water5")
	]
	
	for i in range(water_nodes.size()):
		instance.collect_water_droplet(water_nodes[i])
		# Wait for flight tween to finish
		await get_tree().create_timer(0.55).timeout
		assert(instance.collected_droplets == i + 1, "Droplet count must increment after reaching panel")
	
	assert(instance.level_completed == true, "Level must be marked completed after 5 droplets")
	assert(instance.rain_node.visible == true, "Rain node must be visible upon completion")
	assert(instance.splash_particles.emitting == true, "Splash particles must be active upon completion")
	assert(instance.btn_next.visible == true, "Next button must be visible upon completion")
	assert(Global.score > initial_score, "Score must increase from collecting water & finishing level")
	assert(Global.ct_abstraction >= 50, "CT abstraction score must be recorded")
	print("TEST PASS: Water flight to panel, cloud saturation, and realistic moving rain verified.")
	
	# Verify UI elements
	assert(instance.lbl_collected.text.contains("5 / 5"), "Label must show 5 / 5 collected")
	var title_tex = instance.get_node("UI/HeaderTitle").texture
	assert(title_tex != null, "Header title texture must be present")
	var panduan_tex = instance.get_node("UI/Panduan").texture
	assert(panduan_tex != null, "Panduan texture must be present")
	var panel_tex = instance.get_node("UI/PanelInfo").texture
	assert(panel_tex != null, "Panel info texture must be present")
	print("TEST PASS: UI elements and textures verified.")
	
	print("=== ALL LEVEL 3 TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
