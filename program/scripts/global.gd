extends Node

signal score_changed(new_score: int)

var current_level: int = 1
var max_unlocked_level: int = 1
var score: int = 0
var lives: int = 3 # Dipertahankan untuk kompatibilitas akses properti lama

var ct_decomposition: int = 0
var ct_pattern: int = 0
var ct_abstraction: int = 0
var ct_algorithm: int = 0

# Menyimpan path scene pemanggil sebelum membuka halaman materi
var previous_scene: String = "res://scenes/home.tscn"

var sfx_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var next_sfx_idx: int = 0
const MAX_SFX_PLAYERS: int = 6

var bgm_player: AudioStreamPlayer
var rain_player: AudioStreamPlayer

var sounds: Dictionary = {}
var current_bgm_track: String = ""

func _ready() -> void:
	for i in range(MAX_SFX_PLAYERS):
		var p = AudioStreamPlayer.new()
		p.name = "GlobalSFX_" + str(i)
		p.bus = "Master"
		add_child(p)
		sfx_players.append(p)
	sfx_player = sfx_players[0]

	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "GlobalBGM"
	bgm_player.bus = "Master"
	bgm_player.volume_db = -4.0
	add_child(bgm_player)

	rain_player = AudioStreamPlayer.new()
	rain_player.name = "GlobalRainSFX"
	rain_player.bus = "Master"
	rain_player.volume_db = -3.0
	add_child(rain_player)

	# Sound Effects
	_load_sound("klik", "res://assets/sounds/sfx_klik.wav")
	_load_sound("berhasil", "res://assets/sounds/sfx_berhasil.wav")
	_load_sound("gagal", "res://assets/sounds/sfx_gagal.wav")
	_load_sound("level_selesai", "res://assets/sounds/sfx_level_selesai.wav")
	if ResourceLoader.exists("res://assets/sounds/hujan_sound_baru.mp3"):
		_load_sound("hujan", "res://assets/sounds/hujan_sound_baru.mp3", true)
	else:
		_load_sound("hujan", "res://assets/sounds/sfx_hujan.wav", true)
	_load_sound("bubble", "res://assets/sounds/sfx_bubble.wav")
	_load_sound("card_snap", "res://assets/sounds/sfx_card_snap.wav")
	_load_sound("card_grab", "res://assets/sounds/sfx_card_grab.wav")
	_load_sound("guntur", "res://assets/sounds/sfx_guntur.wav")
	_load_sound("siang", "res://assets/sounds/sfx_siang.wav")
	_load_sound("tick", "res://assets/sounds/sfx_tick.wav")

	# Background Music (Looping enabled)
	if ResourceLoader.exists("res://assets/sounds/musik_utama.mp3"):
		_load_sound("musik_menu", "res://assets/sounds/musik_utama.mp3", true)
	else:
		_load_sound("musik_menu", "res://assets/sounds/musik_menu.wav", true)

	if ResourceLoader.exists("res://assets/sounds/musik_level.mp3"):
		_load_sound("musik_level", "res://assets/sounds/musik_level.mp3", true)
	else:
		_load_sound("musik_level", "res://assets/sounds/musik_level.wav", true)

	_load_sound("musik_victory", "res://assets/sounds/musik_victory.wav", true)

func _load_sound(sound_key: String, path: String, loop: bool = false) -> void:
	if ResourceLoader.exists(path):
		var res = load(path)
		if res is AudioStreamWAV and loop:
			res.loop_mode = AudioStreamWAV.LOOP_FORWARD
		elif res is AudioStreamMP3 and loop:
			res.loop = true
		if res is AudioStream:
			sounds[sound_key] = res

func play_sfx(sound_name: String) -> void:
	if sounds.has(sound_name):
		var target_player: AudioStreamPlayer = null
		# Cari player yang sedang tidak memutar audio
		for p in sfx_players:
			if not p.playing:
				target_player = p
				break
		# Jika semua sedang berbunyi, gunakan round-robin
		if target_player == null:
			target_player = sfx_players[next_sfx_idx]
			next_sfx_idx = (next_sfx_idx + 1) % MAX_SFX_PLAYERS
		target_player.stream = sounds[sound_name]
		target_player.play()

func play_rain_sfx(play: bool = true) -> void:
	if play:
		if sounds.has("hujan") and not rain_player.playing:
			rain_player.stream = sounds["hujan"]
			rain_player.play()
	else:
		rain_player.stop()

func play_bgm(bgm_name: String) -> void:
	if current_bgm_track == bgm_name and bgm_player.playing:
		return
	if sounds.has(bgm_name):
		current_bgm_track = bgm_name
		bgm_player.stream = sounds[bgm_name]
		bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()
	current_bgm_track = ""

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11 or (event.keycode == KEY_ENTER and event.alt_pressed):
			toggle_fullscreen()

func toggle_fullscreen() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func reset_game() -> void:
	current_level = 1
	score = 0
	ct_decomposition = 0
	ct_pattern = 0
	ct_abstraction = 0
	ct_algorithm = 0
	score_changed.emit(score)

func take_damage() -> bool:
	play_sfx("gagal")
	return false

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func complete_level(level_idx: int, ct_points: int) -> void:
	play_sfx("level_selesai")
	match level_idx:
		1:
			ct_decomposition = ct_points
			max_unlocked_level = max(max_unlocked_level, 2)
			get_tree().change_scene_to_file("res://scenes/levels/level_2_kondensasi.tscn")
		2:
			ct_pattern = ct_points
			max_unlocked_level = max(max_unlocked_level, 3)
			get_tree().change_scene_to_file("res://scenes/levels/level_3_presipitasi.tscn")
		3:
			ct_abstraction = ct_points
			max_unlocked_level = max(max_unlocked_level, 4)
			get_tree().change_scene_to_file("res://scenes/levels/level_4_algoritma.tscn")
		4:
			ct_algorithm = ct_points
			get_tree().change_scene_to_file("res://scenes/ui/victory.tscn")
