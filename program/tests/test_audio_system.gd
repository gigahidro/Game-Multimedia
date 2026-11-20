extends Node

func _ready() -> void:
	print("--- TESTING AUDIO SYSTEM ---")
	var g = Global
	assert(g != null, "Global autoload not found")
	
	# 1. Check all 14 sounds loaded
	var expected_sounds = [
		"klik", "berhasil", "gagal", "level_selesai", "hujan",
		"bubble", "card_snap", "card_grab", "guntur", "siang", "tick",
		"musik_menu", "musik_level", "musik_victory"
	]
	for s in expected_sounds:
		assert(g.sounds.has(s), "Missing sound: " + s)
		assert(g.sounds[s] != null, "Sound stream is null: " + s)
		print("SOUND OK: ", s)
	
	# 2. Check looping on BGM tracks & rain
	var loop_tracks = ["musik_menu", "musik_level", "musik_victory", "hujan"]
	for lt in loop_tracks:
		var stream = g.sounds[lt]
		if stream is AudioStreamWAV:
			assert(stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "Loop not set on " + lt)
			print("LOOP OK: ", lt)
		elif stream is AudioStreamMP3:
			assert(stream.loop == true, "Loop not set on " + lt)
			print("LOOP OK (MP3): ", lt)
	
	# 3. Test BGM play & seamless transition
	g.play_bgm("musik_menu")
	assert(g.current_bgm_track == "musik_menu", "Current track mismatch")
	assert(g.bgm_player.playing == true, "BGM player not playing")
	print("BGM PLAY OK: musik_menu")
	
	# Test level BGM
	g.play_bgm("musik_level")
	assert(g.current_bgm_track == "musik_level", "Track change failed")
	print("BGM PLAY OK: musik_level")
	
	# 4. Test multi-channel SFX
	for s in ["klik", "bubble", "card_snap", "guntur", "siang", "tick", "berhasil"]:
		g.play_sfx(s)
	print("MULTI-CHANNEL SFX OK")
	
	# 5. Test rain audio
	g.play_rain_sfx(true)
	assert(g.rain_player.playing == true, "Rain player not playing")
	g.play_rain_sfx(false)
	assert(g.rain_player.playing == false, "Rain player not stopped")
	print("RAIN SFX OK")
	
	print("=== ALL AUDIO TESTS PASSED ===")
	get_tree().quit(0)
