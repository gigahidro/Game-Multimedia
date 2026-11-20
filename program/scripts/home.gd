extends Control

@onready var btn_sound = $BtnSoundOrange
@onready var btn_sound_x = $BtnSoundXOrange
@onready var btn_home = $BtnHome
@onready var btn_materi = $BtnMateri
@onready var btn_lvl1 = $LevelButtons/BtnLevel1
@onready var btn_lvl2 = $LevelButtons/BtnLevel2
@onready var btn_lvl3 = $LevelButtons/BtnLevel3
@onready var btn_lvl4 = $LevelButtons/BtnLevel4

var is_muted: bool = false
var tweens: Dictionary = {}

func _ready() -> void:
	Global.play_bgm("musik_menu")
	_update_sound_buttons()
	_update_level_locks()
	for btn in [btn_sound, btn_sound_x, btn_home, btn_materi, btn_lvl1, btn_lvl2, btn_lvl3, btn_lvl4]:
		_setup_button_animations(btn)

func _update_level_locks() -> void:
	var levels = [
		{"btn": btn_lvl1, "lvl": 1},
		{"btn": btn_lvl2, "lvl": 2},
		{"btn": btn_lvl3, "lvl": 3},
		{"btn": btn_lvl4, "lvl": 4}
	]
	for item in levels:
		var btn: TextureButton = item["btn"]
		var lvl: int = item["lvl"]
		var is_unlocked: bool = lvl <= Global.max_unlocked_level
		var lock = btn.get_node_or_null("LockOverlay")
		if lock:
			lock.visible = not is_unlocked
		
		if is_unlocked:
			btn.modulate = Color.WHITE
		else:
			btn.modulate = Color(0.55, 0.58, 0.65, 0.8)

func _is_button_locked(btn: TextureButton) -> bool:
	if btn == btn_lvl2 and Global.max_unlocked_level < 2:
		return true
	if btn == btn_lvl3 and Global.max_unlocked_level < 3:
		return true
	if btn == btn_lvl4 and Global.max_unlocked_level < 4:
		return true
	return false

func _setup_button_animations(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: TextureButton) -> void:
	if _is_button_locked(btn):
		return
	_tween_button(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _on_unhover(btn: TextureButton) -> void:
	if _is_button_locked(btn):
		btn.scale = Vector2.ONE
		btn.modulate = Color(0.55, 0.58, 0.65, 0.8)
		return
	_tween_button(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: TextureButton) -> void:
	if _is_button_locked(btn):
		return
	_tween_button(btn, Vector2(0.93, 0.93), Color(0.85, 0.85, 0.85, 1.0))

func _on_release(btn: TextureButton) -> void:
	if _is_button_locked(btn):
		return
	_tween_button(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _shake_button(btn: TextureButton) -> void:
	var orig_x = btn.position.x
	var t = create_tween()
	t.tween_property(btn, "position:x", orig_x - 8.0, 0.04)
	t.tween_property(btn, "position:x", orig_x + 8.0, 0.05)
	t.tween_property(btn, "position:x", orig_x - 5.0, 0.04)
	t.tween_property(btn, "position:x", orig_x + 5.0, 0.04)
	t.tween_property(btn, "position:x", orig_x, 0.04)

func _tween_button(btn: TextureButton, target_scale: Vector2, target_color: Color) -> void:
	if tweens.has(btn) and tweens[btn] and tweens[btn].is_running():
		tweens[btn].kill()
	btn.pivot_offset = btn.size / 2
	var t = create_tween().set_parallel(true)
	t.tween_property(btn, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
	t.tween_property(btn, "modulate", target_color, 0.1).set_trans(Tween.TRANS_SINE)
	tweens[btn] = t

func _update_sound_buttons() -> void:
	btn_sound.visible = !is_muted
	btn_sound_x.visible = is_muted

func _on_btn_sound_pressed() -> void:
	is_muted = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	_update_sound_buttons()

func _on_btn_sound_x_pressed() -> void:
	is_muted = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	_update_sound_buttons()

func _on_btn_home_pressed() -> void:
	Global.play_sfx("klik")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_btn_materi_pressed() -> void:
	Global.play_sfx("klik")
	Global.previous_scene = "res://scenes/home.tscn"
	get_tree().change_scene_to_file("res://scenes/materi.tscn")

func _on_btn_level1_pressed() -> void:
	Global.play_sfx("klik")
	Global.reset_game()
	Global.current_level = 1
	get_tree().change_scene_to_file("res://scenes/levels/level_1_evaporasi.tscn")

func _on_btn_level2_pressed() -> void:
	if Global.max_unlocked_level < 2:
		Global.play_sfx("gagal")
		_shake_button(btn_lvl2)
		return
	Global.play_sfx("klik")
	Global.current_level = 2
	get_tree().change_scene_to_file("res://scenes/levels/level_2_kondensasi.tscn")

func _on_btn_level3_pressed() -> void:
	if Global.max_unlocked_level < 3:
		Global.play_sfx("gagal")
		_shake_button(btn_lvl3)
		return
	Global.play_sfx("klik")
	Global.current_level = 3
	get_tree().change_scene_to_file("res://scenes/levels/level_3_presipitasi.tscn")

func _on_btn_level4_pressed() -> void:
	if Global.max_unlocked_level < 4:
		Global.play_sfx("gagal")
		_shake_button(btn_lvl4)
		return
	Global.play_sfx("klik")
	Global.current_level = 4
	get_tree().change_scene_to_file("res://scenes/levels/level_4_algoritma.tscn")
