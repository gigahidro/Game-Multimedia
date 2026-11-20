extends CanvasLayer

@onready var btn_sound: TextureButton = $TopRightControls/BtnSoundOrange
@onready var btn_sound_x: TextureButton = $TopRightControls/BtnSoundXOrange
@onready var btn_home: TextureButton = $BottomLeftControls/BtnHome
@onready var btn_materi: TextureButton = $BottomLeftControls/BtnMateri

var is_muted: bool = false
var tweens: Dictionary = {}

func _ready() -> void:
	is_muted = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	_update_sound_buttons()
	
	for btn in [btn_sound, btn_sound_x, btn_home, btn_materi]:
		if btn:
			_setup_button_animations(btn)

func update_hud(_immediate: bool = false) -> void:
	pass

func set_pillar(_text: String) -> void:
	# Keterangan pilar CT dihilangkan dari tampilan bermain (hanya dievaluasi di akhir)
	pass

func set_help_instruction(_text: String) -> void:
	pass

func _update_sound_buttons() -> void:
	if btn_sound and btn_sound_x:
		btn_sound.visible = !is_muted
		btn_sound_x.visible = is_muted

func _setup_button_animations(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: TextureButton) -> void:
	_tween_btn(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _on_unhover(btn: TextureButton) -> void:
	_tween_btn(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: TextureButton) -> void:
	Global.play_sfx("klik")
	_tween_btn(btn, Vector2(0.93, 0.93), Color(0.85, 0.85, 0.85, 1.0))

func _on_release(btn: TextureButton) -> void:
	_tween_btn(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _tween_btn(btn: TextureButton, target_scale: Vector2, target_color: Color) -> void:
	if tweens.has(btn) and tweens[btn] and tweens[btn].is_running():
		tweens[btn].kill()
	btn.pivot_offset = btn.size / 2
	var t = create_tween().set_parallel(true)
	t.tween_property(btn, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
	t.tween_property(btn, "modulate", target_color, 0.1).set_trans(Tween.TRANS_SINE)
	tweens[btn] = t

func _on_btn_sound_orange_pressed() -> void:
	is_muted = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	_update_sound_buttons()

func _on_btn_sound_x_orange_pressed() -> void:
	is_muted = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	_update_sound_buttons()

func _on_btn_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn")

func _on_btn_materi_pressed() -> void:
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.scene_file_path != "":
		Global.previous_scene = current_scene.scene_file_path
	else:
		Global.previous_scene = "res://scenes/levels/level_" + str(Global.current_level) + "_evaporasi.tscn"
	get_tree().change_scene_to_file("res://scenes/materi.tscn")
