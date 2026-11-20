extends Control

@onready var btn_sound = $BtnSound
@onready var btn_sound_x = $BtnSoundX
@onready var btn_play = $BtnPlay
@onready var btn_close = $BtnClose

var is_muted: bool = false
var tweens: Dictionary = {}

func _ready() -> void:
	Global.play_bgm("musik_menu")
	_update_sound_buttons()
	_setup_button_animations(btn_play)
	_setup_button_animations(btn_close)
	_setup_button_animations(btn_sound)
	_setup_button_animations(btn_sound_x)

func _setup_button_animations(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.08, 1.08), Color(1.15, 1.15, 1.15, 1.0))

func _on_unhover(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: TextureButton) -> void:
	Global.play_sfx("klik")
	_tween_button(btn, Vector2(0.92, 0.92), Color(0.85, 0.85, 0.85, 1.0))

func _on_release(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.08, 1.08), Color(1.15, 1.15, 1.15, 1.0))

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

func _on_btn_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home.tscn")

func _on_btn_close_pressed() -> void:
	get_tree().quit()

func _on_btn_sound_pressed() -> void:
	is_muted = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	_update_sound_buttons()
	_setup_button_animations(btn_sound_x)

func _on_btn_sound_x_pressed() -> void:
	is_muted = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	_update_sound_buttons()
	_setup_button_animations(btn_sound)
