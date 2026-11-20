extends Node2D

@onready var hud = $HUD
@onready var awan1: TextureRect = $Clouds/Awan1
@onready var vapors_container: Node2D = $Vapors

@onready var slider_suhu: HSlider = $UI/PanelSuhuCard/SliderSuhu
@onready var lbl_suhu_val: Label = $UI/PanelSuhuCard/LblSuhuVal

@onready var progress_bar: ProgressBar = $UI/ProgressContainer/ProgressBar
@onready var lbl_status: Label = $UI/ProgressContainer/LblStatus
@onready var btn_next: TextureButton = $UI/BtnNext

const TEX_KNOB_KUNING = preload("res://assets/sprites/element/knop_kuning_pengatur_suhu.png")
const TEX_KNOB_BIRU = preload("res://assets/sprites/element/knop_biru_pengatur_suhu.png")
const TEX_UAP_SHEET = preload("res://assets/sprites/element/panah_uap.png")
const UAP_H_FRAMES: int = 5
const UAP_V_FRAMES: int = 2
const UAP_FPS: float = 12.0
const UAP_RISE_DISTANCE: float = 90.0
const UAP_CYCLE_TIME: float = 3.2

var condensation_progress: float = 0.0
var level_completed: bool = false
var wrong_pattern_attempts: int = 0
var slider_fill_style: StyleBoxFlat = null
var vapor_nodes: Array[AnimatedSprite2D] = []
var vapor_frames: SpriteFrames = null
var vapor_initial_pos: Array[Vector2] = []
var vapor_offsets: Array[float] = []
var time_elapsed: float = 0.0
var tweens: Dictionary = {}

func _ready() -> void:
	Global.play_bgm("musik_level")
	Global.current_level = 2
	hud.update_hud()
	hud.set_help_instruction("Udara di atmosfer atas sangat dingin. Geser suhu perlahan ke arah dingin dan amati di suhu berapa uap air mulai mengembun membentuk awan!")
	
	btn_next.visible = false
	progress_bar.value = 0.0
	
	awan1.modulate.a = 0.15
	
	var orig_fill = slider_suhu.get_theme_stylebox("grabber_area")
	if orig_fill is StyleBoxFlat:
		slider_fill_style = orig_fill.duplicate()
		slider_suhu.add_theme_stylebox_override("grabber_area", slider_fill_style)
		slider_suhu.add_theme_stylebox_override("grabber_area_highlight", slider_fill_style)
	
	_spawn_vapors()
	_update_knob_and_label(slider_suhu.value)
	_setup_button_animations(btn_next)

func _build_vapor_frames() -> SpriteFrames:
	# Potong sheet panah uap (5x2) jadi 10 frame animasi, dipakai bersama semua titik uap
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	frames.add_animation("uap")
	frames.set_animation_speed("uap", UAP_FPS)
	frames.set_animation_loop("uap", true)

	var tex_size := TEX_UAP_SHEET.get_size()
	for row in range(UAP_V_FRAMES):
		for col in range(UAP_H_FRAMES):
			var x0 := roundi(tex_size.x * col / UAP_H_FRAMES)
			var x1 := roundi(tex_size.x * (col + 1) / UAP_H_FRAMES)
			var y0 := roundi(tex_size.y * row / UAP_V_FRAMES)
			var y1 := roundi(tex_size.y * (row + 1) / UAP_V_FRAMES)
			var atlas := AtlasTexture.new()
			atlas.atlas = TEX_UAP_SHEET
			atlas.region = Rect2(x0, y0, x1 - x0, y1 - y0)
			frames.add_frame("uap", atlas)
	return frames

func _spawn_vapors() -> void:
	# Buat 16 titik uap tersebar di langit
	var spawn_points: Array[Vector2] = [
		Vector2(160, 380), Vector2(250, 470), Vector2(340, 360), Vector2(430, 480),
		Vector2(520, 370), Vector2(610, 490), Vector2(700, 360), Vector2(790, 480),
		Vector2(880, 370), Vector2(970, 490), Vector2(1060, 380), Vector2(1130, 460),
		Vector2(290, 560), Vector2(500, 570), Vector2(760, 560), Vector2(990, 570)
	]
	
	vapor_frames = _build_vapor_frames()
	for i in range(spawn_points.size()):
		var s := AnimatedSprite2D.new()
		s.sprite_frames = vapor_frames
		s.animation = "uap"
		s.position = spawn_points[i]
		s.scale = Vector2(0.45, 0.45)
		s.modulate = Color(1.0, 1.0, 1.0, 0.85)
		vapors_container.add_child(s)
		s.play("uap")
		s.set_frame_and_progress(i % (UAP_H_FRAMES * UAP_V_FRAMES), 0.0)
		vapor_nodes.append(s)
		vapor_initial_pos.append(spawn_points[i])
		vapor_offsets.append(float(i) * 0.7)

func _process(delta: float) -> void:
	if level_completed:
		return
	
	time_elapsed += delta
	var suhu = slider_suhu.value
	var is_cold = suhu <= 10.0
	
	if is_cold:
		# Semakin dingin (misal <= 0°C), kondensasi semakin cepat
		var speed = lerp(20.0, 40.0, clamp((10.0 - suhu) / 15.0, 0.0, 1.0))
		condensation_progress = min(100.0, condensation_progress + delta * speed)
		progress_bar.value = condensation_progress
		
		lbl_status.text = "Pola Dingin Ditemukan! Pada suhu dingin (" + str(int(suhu)) + "°C), uap air mengembun menjadi awan!"
		lbl_status.modulate = Color(0.3, 0.9, 1.0)
		
		# Awan menebal & membesar perlahan
		var cloud_alpha = lerp(0.15, 1.0, condensation_progress / 100.0)
		awan1.modulate.a = cloud_alpha
		var cloud_scale = lerp(1.0, 1.06, condensation_progress / 100.0)
		awan1.scale = Vector2(cloud_scale, cloud_scale)
		
		# Titik-titik uap tertarik masuk ke awan, lalu hilang begitu menyentuhnya
		var target1 = awan1.position + awan1.size / 2
		
		for i in range(vapor_nodes.size()):
			var v = vapor_nodes[i]
			if not is_instance_valid(v):
				continue
			var dist: float = v.position.distance_to(target1)
			v.position = v.position.move_toward(target1, delta * 220.0)
			v.modulate.a = clamp(dist / 160.0, 0.0, 1.0) * 0.85
			if dist <= 20.0:
				v.visible = false
		
		if condensation_progress >= 100.0:
			_on_condensation_completed()
	else:
		# Uap naik pelan lalu memudar, siklus per titik (mirip partikel Level 1)
		for i in range(vapor_nodes.size()):
			var v = vapor_nodes[i]
			if not is_instance_valid(v):
				continue
			var phase := fmod(time_elapsed / UAP_CYCLE_TIME + float(i) / float(vapor_nodes.size()), 1.0)
			var wobble = sin(time_elapsed * 2.0 + vapor_offsets[i]) * 8.0
			v.visible = true
			v.position.x = vapor_initial_pos[i].x + sin(time_elapsed * 1.3 + vapor_offsets[i]) * 6.0
			v.position.y = vapor_initial_pos[i].y - phase * UAP_RISE_DISTANCE + wobble
			v.modulate.a = 0.85 * sin(phase * PI)
		
		if suhu > 35.0 and not level_completed:
			lbl_status.text = "Polanya berlawanan: Suhu panas menguapkan air, bukan mengembunkannya!"
			lbl_status.modulate = Color(1.0, 0.4, 0.4)
		elif suhu > 25.0:
			lbl_status.text = "Suhu masih hangat (" + str(int(suhu)) + "°C). Amati: uap masih melayang bebas, belum mengembun."
			lbl_status.modulate = Color(1.0, 0.7, 0.2)
		else:
			lbl_status.text = "Mulai sejuk (" + str(int(suhu)) + "°C). Uap air mulai bergerak saling mendekat..."
			lbl_status.modulate = Color(0.7, 0.9, 1.0)

func _update_knob_and_label(val: float) -> void:
	# Ganti knop dan warna bar slider (biru saat dingin, kuning/oranye saat hangat)
	if val <= 15.0:
		slider_suhu.add_theme_icon_override("grabber", TEX_KNOB_BIRU)
		slider_suhu.add_theme_icon_override("grabber_highlight", TEX_KNOB_BIRU)
		if slider_fill_style:
			slider_fill_style.bg_color = Color(0.2, 0.65, 0.95, 1.0)
			slider_fill_style.border_color = Color(0.1, 0.4, 0.7, 1.0)
	else:
		slider_suhu.add_theme_icon_override("grabber", TEX_KNOB_KUNING)
		slider_suhu.add_theme_icon_override("grabber_highlight", TEX_KNOB_KUNING)
		if slider_fill_style:
			slider_fill_style.bg_color = Color(0.98, 0.62, 0.15, 1.0)
			slider_fill_style.border_color = Color(0.85, 0.45, 0.08, 1.0)
	
	var category = ""
	if val <= 0.0:
		category = " (Beku ❄️)"
	elif val <= 10.0:
		category = " (Dingin ❄️)"
	elif val <= 25.0:
		category = " (Sejuk)"
	else:
		category = " (Hangat ☀️)"
	
	lbl_suhu_val.text = str(int(val)) + " °C" + category

func _on_slider_suhu_value_changed(value: float) -> void:
	_update_knob_and_label(value)
	
	# Evaluasi CT: jika pemain malah menaikkan suhu lebih panas
	if value > 35.0 and not level_completed:
		wrong_pattern_attempts += 1
		Global.play_sfx("gagal")
		lbl_status.text = "Polanya berlawanan: Suhu panas menguapkan air, bukan mengembunkannya!"
		lbl_status.modulate = Color(1.0, 0.4, 0.4)

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

func _on_condensation_completed() -> void:
	level_completed = true
	Global.play_sfx("berhasil")
	lbl_status.text = "Pola Ditemukan! Suhu dingin mengembunkan uap air menjadi awan sempurna!"
	lbl_status.modulate = Color(0.2, 1.0, 0.5)
	
	# Sisa uap disembunyikan supaya tidak menggantung di awan
	for v in vapor_nodes:
		if is_instance_valid(v):
			v.visible = false
	
	# Hitung skor CT Pengenalan Pola
	var ct_points = 100
	if wrong_pattern_attempts > 0:
		ct_points = max(60, 100 - (wrong_pattern_attempts * 15))
	
	Global.add_score(250)
	Global.ct_pattern = ct_points
	hud.update_hud()
	
	btn_next.visible = true
	btn_next.modulate.a = 0.0
	var t = create_tween()
	t.tween_property(btn_next, "modulate:a", 1.0, 0.5)

func _on_btn_next_pressed() -> void:
	Global.play_sfx("klik")
	Global.complete_level(2, Global.ct_pattern)
