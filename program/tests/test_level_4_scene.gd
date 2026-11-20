extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING LEVEL 4 DRAG & DROP SCENE ---")
	
	var scene_path = "res://scenes/levels/level_4_algoritma.tscn"
	assert(FileAccess.file_exists(scene_path), "Level 4 scene file should exist")
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
	assert(instance.level_completed == false, "Level should not be completed initially")
	assert(instance.btn_next.visible == false, "Next button should be hidden initially")
	assert(instance.slot_cards == ["", "", "", ""], "All 4 slots must be empty initially")
	assert(instance.card_evap.is_placed == false, "Evap card must be in tray")
	assert(instance.card_kond.is_placed == false, "Kond card must be in tray")
	assert(instance.card_pres.is_placed == false, "Pres card must be in tray")
	assert(instance.card_infi.is_placed == false, "Infi card must be in tray")
	print("TEST PASS: Initial state verified.")
	
	# Test arbitrary slot placement (student drags Evaporasi directly into Slot 2)
	instance.place_card_in_slot(2, "Evaporasi")
	assert(instance.slot_cards[2] == "Evaporasi", "Slot 2 must contain Evaporasi")
	assert(instance.slot_cards[0] == "", "Slot 0 must still be empty")
	assert(instance.card_evap.is_placed == true, "Evap card must be marked placed")
	print("TEST PASS: Arbitrary slot placement verified (student chooses target slot).")
	
	# Test incomplete check guard
	instance._on_btn_check_pressed()
	assert(instance.level_completed == false, "Cannot complete with only 1 card placed")
	assert(instance.lbl_feedback.text.contains("kosong"), "Feedback must prompt about empty slot")
	print("TEST PASS: Incomplete slots check guard verified.")
	
	# Test removing card from slot (click on slot 2)
	instance.on_slot_clicked(2)
	assert(instance.slot_cards[2] == "", "Slot 2 must be emptied on click")
	assert(instance.card_evap.is_placed == false, "Evap card must return to tray")
	print("TEST PASS: Card removal from slot verified.")
	
	# Test wrong order penalty: Infiltrasi (slot 0) -> Evaporasi (slot 1) -> Presipitasi (slot 2) -> Kondensasi (slot 3)
	instance.place_card_in_slot(0, "Infiltrasi")
	instance.place_card_in_slot(1, "Evaporasi")
	instance.place_card_in_slot(2, "Presipitasi")
	instance.place_card_in_slot(3, "Kondensasi")
	
	instance._on_btn_check_pressed()
	assert(instance.wrong_attempts == 1, "Wrong attempts must be tracked")
	assert(instance.level_completed == false, "Level must not be completed on wrong order")
	print("TEST PASS: Wrong order detection and penalty verified.")
	
	# Test reset button
	instance._on_btn_reset_pressed()
	assert(instance.slot_cards == ["", "", "", ""], "All slots must be empty after reset")
	assert(instance.card_evap.is_placed == false, "Cards must be restored to tray after reset")
	print("TEST PASS: Reset button functionality verified.")
	
	# Test drag & drop from tray simulation via on_slot_dropped:
	# Correct order: Evaporasi (slot 0) -> Kondensasi (slot 1) -> Presipitasi (slot 2) -> Infiltrasi (slot 3)
	instance.on_slot_dropped(0, {"card_name": "Evaporasi", "from_slot": -1})
	instance.on_slot_dropped(1, {"card_name": "Kondensasi", "from_slot": -1})
	instance.on_slot_dropped(2, {"card_name": "Presipitasi", "from_slot": -1})
	instance.on_slot_dropped(3, {"card_name": "Infiltrasi", "from_slot": -1})
	
	var initial_score = Global.score
	instance._on_btn_check_pressed()
	assert(instance.level_completed == true, "Level must complete on correct sequence")
	assert(instance.btn_next.visible == true, "Next button must be visible upon victory")
	assert(Global.score > initial_score, "Score must increase upon victory")
	assert(Global.ct_algorithm >= 60, "CT algorithm score must be recorded")
	print("TEST PASS: Correct sequence victory & CT algorithm scoring verified.")
	
	# Verify textures placed in all 4 slots
	assert(instance.slot1.get_node("CardPlaced").texture != null, "Slot 1 placed card texture must be assigned")
	assert(instance.slot2.get_node("CardPlaced").texture != null, "Slot 2 placed card texture must be assigned")
	assert(instance.slot3.get_node("CardPlaced").texture != null, "Slot 3 placed card texture must be assigned")
	assert(instance.slot4.get_node("CardPlaced").texture != null, "Slot 4 placed card texture must be assigned")
	print("TEST PASS: All placed card textures verified.")
	
	print("=== ALL LEVEL 4 DRAG & DROP TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
