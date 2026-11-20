extends Node

func _ready() -> void:
	print("--- TEST RUNNER: VERIFYING CUTE MODERN CT EVALUATION SCENE ---")
	
	# 1. Test Victory Scene
	var vic_scene = load("res://scenes/ui/victory.tscn")
	assert(vic_scene != null, "Victory scene failed to load")
	print("TEST PASS: Victory scene exists and loaded.")
	
	Global.score = 900
	Global.ct_decomposition = 90
	Global.ct_pattern = 80
	Global.ct_abstraction = 75
	Global.ct_algorithm = 88
	
	var vic_inst = vic_scene.instantiate()
	assert(vic_inst != null, "Victory instantiation failed")
	add_child(vic_inst)
	print("TEST PASS: Victory instantiated.")
	
	assert(vic_inst.get_node_or_null("Background") != null, "Victory background missing")
	assert(vic_inst.get_node_or_null("ConfettiParticles") == null, "ConfettiParticles (snow effect) must be removed")
	assert(vic_inst.get_node_or_null("HeaderGroup/PillTitle/LblTitle") != null, "Header title missing")
	assert(vic_inst.get_node_or_null("MainBoard") != null, "MainBoard container missing")
	assert(vic_inst.get_node_or_null("Buttons/BtnPlayAgain") != null, "BtnPlayAgain missing")
	assert(vic_inst.get_node_or_null("Buttons/BtnClose") != null, "BtnClose missing")
	
	# Verify 4 pillar cards and badges
	assert(vic_inst.lbl_badge_decomp.text == "Sangat Tinggi", "Decomp badge should be Sangat Tinggi for 90%")
	assert(vic_inst.lbl_badge_pattern.text == "Tinggi", "Pattern badge should be Tinggi for 80%")
	assert(vic_inst.lbl_badge_abstract.text == "Tinggi", "Abstract badge should be Tinggi for 75%")
	assert(vic_inst.lbl_badge_algo.text == "Sangat Tinggi", "Algo badge should be Sangat Tinggi for 88%")
	
	# Average: (90 + 80 + 75 + 88) / 4 = 83.25 -> Kategori TINGGI
	assert(vic_inst.lbl_avg_cat.text.contains("TINGGI"), "Overall category must be TINGGI")
	print("TEST PASS: Cute modern CT evaluation cards, badges, and average verified.")
	
	vic_inst.queue_free()
	
	print("=== ALL VICTORY AND EVALUATION TESTS PASSED SUCCESSFULLY ===")
	get_tree().quit(0)
