extends Control

@onready var bg_texture: TextureRect = $Background
@onready var btn_home: TextureButton = $BtnHome
@onready var btn_back: TextureButton = $BtnBack
@onready var btn_next: TextureButton = $BtnNext
@onready var btn_close: TextureButton = $BtnClose
@onready var btn_sound: TextureButton = $BtnSoundOrange
@onready var btn_sound_x: TextureButton = $BtnSoundXOrange

const TEX_HOME = preload("res://assets/sprites/button/button_home.png")
const TEX_CLOSE = preload("res://assets/sprites/button/button_close.png")

const SLIDES: Array[Texture2D] = [
	preload("res://assets/sprites/background/bg_materi_evaporasi&transpirasi.png"),
	preload("res://assets/sprites/background/bg_materi_kondensasi.png"),
	preload("res://assets/sprites/background/bg_materi_presipitasi.png"),
	preload("res://assets/sprites/background/bg_materi_infiltrasi&run-off.png"),
]

var current_slide: int = 0
var is_muted: bool = false
var tweens: Dictionary = {}
var opened_from_level: bool = false

func _ready() -> void:
	is_muted = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	_update_sound_buttons()
	
	# Deteksi apakah materi dibuka dari level atau dari home
	opened_from_level = Global.previous_scene != "res://scenes/home.tscn" and Global.previous_scene != "res://scenes/main_menu.tscn"
	if not opened_from_level:
		Global.play_bgm("musik_menu")
	_update_nav_button_style()
	_update_slide()
	
	for btn in [btn_home, btn_back, btn_next, btn_close, btn_sound, btn_sound_x]:
		_setup_button_animations(btn)

func _update_nav_button_style() -> void:
	if opened_from_level:
		# Jika dibuka dari level, ganti icon tombol kiri bawah menjadi Close
		btn_home.texture_normal = TEX_CLOSE
		btn_home.texture_pressed = TEX_CLOSE
		btn_home.texture_hover = TEX_CLOSE
	else:
		# Jika dibuka dari home, tetap Button Home
		btn_home.texture_normal = TEX_HOME
		btn_home.texture_pressed = TEX_HOME
		btn_home.texture_hover = TEX_HOME

func _setup_button_animations(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _on_unhover(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(0.93, 0.93), Color(0.85, 0.85, 0.85, 1.0))

func _on_release(btn: TextureButton) -> void:
	_tween_button(btn, Vector2(1.06, 1.06), Color(1.12, 1.12, 1.12, 1.0))

func _tween_button(btn: TextureButton, target_scale: Vector2, target_color: Color) -> void:
	if tweens.has(btn) and tweens[btn] and tweens[btn].is_running():
		tweens[btn].kill()
	btn.pivot_offset = btn.size / 2
	var t = create_tween().set_parallel(true)
	t.tween_property(btn, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
	t.tween_property(btn, "modulate", target_color, 0.1).set_trans(Tween.TRANS_SINE)
	tweens[btn] = t

func _update_slide() -> void:
	bg_texture.texture = SLIDES[current_slide]
	btn_back.visible = (current_slide > 0)
	var is_last = (current_slide == SLIDES.size() - 1)
	btn_next.visible = !is_last
	btn_close.visible = is_last

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

func _on_btn_back_pressed() -> void:
	Global.play_sfx("klik")
	if current_slide > 0:
		current_slide -= 1
		_update_slide()

func _on_btn_next_pressed() -> void:
	Global.play_sfx("klik")
	if current_slide < SLIDES.size() - 1:
		current_slide += 1
		_update_slide()

func _return_to_previous_scene() -> void:
	Global.play_sfx("klik")
	var target = Global.previous_scene
	if target == "":
		target = "res://scenes/home.tscn"
	get_tree().change_scene_to_file(target)

func _on_btn_close_pressed() -> void:
	_return_to_previous_scene()

func _on_btn_home_pressed() -> void:
	_return_to_previous_scene()
