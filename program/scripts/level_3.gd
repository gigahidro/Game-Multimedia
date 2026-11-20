extends Node2D

@onready var hud = $HUD
@onready var cloud = $Cloud
@onready var cloud_sprite: Sprite2D = $Cloud/Visual
@onready var rain_node: Node2D = $Cloud/Rain
@onready var splash_particles: CPUParticles2D = $Cloud/Rain/SplashParticles
@onready var rain_drops: CPUParticles2D = get_node_or_null("Cloud/Rain/RainDrops")
@onready var background: TextureRect = $Background
@onready var panel_info: TextureRect = $UI/PanelInfo
@onready var lbl_collected: Label = $UI/PanelInfo/LblCollected
@onready var lbl_status: Label = $UI/PanelInfo/LblStatus
@onready var progress_bar: ProgressBar = get_node_or_null("UI/PanelInfo/ProgressBar")
@onready var btn_next: TextureButton = $UI/BtnNext
@onready var items_container: Node2D = $Items

var collected_droplets: int = 0
const TARGET_DROPLETS: int = 5
var level_completed: bool = false
var abstraction_errors: int = 0
var tweens: Dictionary = {}
var base_cloud_scale: Vector2 = Vector2(0.58, 0.58)
var distractor_data: Array[Dictionary] = []

func _ready() -> void:
	Global.play_bgm("musik_level")
	Global.current_level = 3
	hud.update_hud()
	hud.set_help_instruction("Pilah fokus (Abstraksi): Awan hanya menyerap molekul air murni (H2O). Kumpulkan tetesan air dan abaikan noise/benda asing yang melayang di langit!")
	
	btn_next.visible = false
	if rain_node:
		rain_node.visible = false
		rain_node.modulate.a = 0.0
	if splash_particles:
		splash_particles.emitting = false
	
	if progress_bar:
		progress_bar.max_value = TARGET_DROPLETS
		progress_bar.value = 0.0
	
	lbl_status.text = "Kumpulkan tetesan air murni ke dalam awan. Abaikan elemen lain!"
	lbl_status.modulate = Color.WHITE
	lbl_status.set("theme_override_colors/font_color", Color(0.15, 0.3, 0.52, 1))
	
	_setup_button_animations(btn_next)
	_init_distractor_drift()
	_update_collected_ui()

func _init_distractor_drift() -> void:
	distractor_data.clear()
	var d_configs = [
		{"name": "DistractorLeaf1", "speed": 1.1, "amp_x": 35.0, "amp_y": 14.0, "rot_amp": 0.18, "phase": 0.0},
		{"name": "DistractorLeaf2", "speed": 0.85, "amp_x": 42.0, "amp_y": 16.0, "rot_amp": 0.14, "phase": 2.1},
		{"name": "DistractorKite", "speed": 0.65, "amp_x": 55.0, "amp_y": 20.0, "rot_amp": 0.09, "phase": 4.2}
	]
	for cfg in d_configs:
		var node = items_container.get_node_or_null(cfg["name"]) as Area2D
		if node:
			distractor_data.append({
				"node": node,
				"base_x": node.position.x,
				"base_y": node.position.y,
				"base_rot": node.rotation,
				"speed": cfg["speed"],
				"amp_x": cfg["amp_x"],
				"amp_y": cfg["amp_y"],
				"rot_amp": cfg["rot_amp"],
				"phase": cfg["phase"]
			})

func _process(_delta: float) -> void:
	if level_completed:
		return
	var time = Time.get_ticks_msec() / 1000.0
	for d in distractor_data:
		var node = d["node"]
		if is_instance_valid(node) and not node.is_being_collected:
			if "shake_tween" in node and node.shake_tween and node.shake_tween.is_running():
				continue
			var t_val = time * d["speed"] + d["phase"]
			var cur_x = d["base_x"] + sin(t_val) * d["amp_x"]
			var cur_y = d["base_y"] + cos(t_val * 0.8) * d["amp_y"]
			node.position.x = cur_x
			if "initial_x" in node:
				node.initial_x = cur_x
			if "initial_y" in node:
				node.initial_y = cur_y
			else:
				node.position.y = cur_y
			node.rotation = d["base_rot"] + sin(t_val * 1.2) * d["rot_amp"]

func _update_collected_ui() -> void:
	lbl_collected.text = "Uap Air: " + str(collected_droplets) + " / " + str(TARGET_DROPLETS)
	var ratio: float = float(collected_droplets) / float(TARGET_DROPLETS)
	
	if progress_bar:
		var bar_tween = create_tween()
		bar_tween.tween_property(progress_bar, "value", float(collected_droplets), 0.25).set_trans(Tween.TRANS_SINE)
	
	# Awan makin gelap, tebal, dan sedikit membesar seiring terisi air
	var brightness: float = lerp(1.15, 0.62, ratio)
	var alpha: float = lerp(0.72, 1.0, ratio)
	cloud_sprite.modulate = Color(brightness, brightness, brightness * 1.05, alpha)
	var scale_factor: float = lerp(0.95, 1.06, ratio)
	cloud_sprite.scale = base_cloud_scale * scale_factor

func collect_water_droplet(item_node: Node) -> void:
	if level_completed:
		return
	
	Global.play_sfx("bubble")
	
	# Tetesan air terbang terserap ke dalam Awan
	var target_pos = cloud.global_position + Vector2(randf_range(-25.0, 25.0), randf_range(-15.0, 15.0))
	lbl_status.text = "Tetesan air murni terserap ke dalam awan..."
	lbl_status.modulate = Color.WHITE
	lbl_status.set("theme_override_colors/font_color", Color(0.08, 0.48, 0.85, 1.0))
	
	item_node.fly_to_target(target_pos, func():
		if level_completed:
			return
		collected_droplets += 1
		Global.add_score(50)
		hud.update_hud()
		_update_collected_ui()
		
		# Efek reaksi awan saat menyerap uap air (punch bounce)
		var ct = create_tween()
		var current_ratio = float(collected_droplets) / float(TARGET_DROPLETS)
		var target_scale = base_cloud_scale * lerp(0.95, 1.08, current_ratio)
		ct.tween_property(cloud_sprite, "scale", target_scale * 1.06, 0.08).set_trans(Tween.TRANS_SINE)
		ct.tween_property(cloud_sprite, "scale", target_scale, 0.12).set_trans(Tween.TRANS_SINE)
		
		# Punch/bounce animation on panel_info
		panel_info.pivot_offset = panel_info.size / 2
		var pt = create_tween()
		pt.tween_property(panel_info, "scale", Vector2(1.06, 1.06), 0.08).set_trans(Tween.TRANS_SINE)
		pt.tween_property(panel_info, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE)
		
		lbl_status.text = "Bagus! Uap air diserap awan (makin pekat & jenuh)."
		lbl_status.modulate = Color.WHITE
		lbl_status.set("theme_override_colors/font_color", Color(0.08, 0.48, 0.85, 1.0))
		
		if collected_droplets >= TARGET_DROPLETS:
			_on_precipitation_completed()
	)

func hit_distractor(item_node: Node) -> void:
	if level_completed:
		return
	
	Global.play_sfx("gagal")
	abstraction_errors += 1
	var item_title = item_node.item_name if "item_name" in item_node else "Pengecoh"
	lbl_status.text = "Itu bukan air murni (" + item_title + ")! Abstraksikan: abaikan noise benda terbang ini."
	lbl_status.modulate = Color.WHITE
	lbl_status.set("theme_override_colors/font_color", Color(0.85, 0.2, 0.2, 1.0))
	
	# Pengecoh TIDAK hilang; beri animasi shake/flash
	if item_node.has_method("play_distractor_feedback"):
		item_node.play_distractor_feedback()
	
	# Evaluasi CT Abstraksi (tanpa game over)
	Global.ct_abstraction = max(50, 100 - (abstraction_errors * 10))

func _on_precipitation_completed() -> void:
	level_completed = true
	Global.play_sfx("guntur")
	Global.play_sfx("berhasil")
	Global.play_rain_sfx(true)
	Global.add_score(250)
	if Global.ct_abstraction == 0:
		Global.ct_abstraction = max(50, 100 - (abstraction_errors * 10))
	
	# Langsung aktifkan node hujan & partikel agar terdeteksi aktif
	if rain_node:
		rain_node.visible = true
		rain_node.modulate.a = 0.0
	
	if splash_particles:
		splash_particles.emitting = true
	
	if rain_drops:
		rain_drops.emitting = true
	
	btn_next.visible = true
	btn_next.modulate.a = 0.0
	
	lbl_status.text = "Awan sudah sangat jenuh! Air mulai turun..."
	lbl_status.modulate = Color.WHITE
	lbl_status.set("theme_override_colors/font_color", Color(0.08, 0.52, 0.85, 1.0))
	
	# 1. Efek Awan Bergetar (Cloud Rumble / Saturation Shake)
	var orig_cloud_pos = cloud.position
	var rumble = create_tween()
	rumble.tween_property(cloud, "position:x", orig_cloud_pos.x + 7.0, 0.04)
	rumble.tween_property(cloud, "position:x", orig_cloud_pos.x - 7.0, 0.04)
	rumble.tween_property(cloud, "position:x", orig_cloud_pos.x + 5.0, 0.04)
	rumble.tween_property(cloud, "position:x", orig_cloud_pos.x - 5.0, 0.04)
	rumble.tween_property(cloud, "position:x", orig_cloud_pos.x + 3.0, 0.04)
	rumble.tween_property(cloud, "position", orig_cloud_pos, 0.04)
	
	# 2. Kilatan petir halus (Flash) & suasana mendung
	var flash_t = create_tween()
	flash_t.tween_property(cloud_sprite, "modulate", Color(2.2, 2.2, 2.3, 1.0), 0.08)
	flash_t.tween_property(cloud_sprite, "modulate", Color(0.48, 0.5, 0.58, 1.0), 0.25)
	
	if background:
		var bg_t = create_tween()
		bg_t.tween_property(background, "modulate", Color(0.82, 0.85, 0.92, 1.0), 0.5)
	
	# 3. Aliran Hujan Turun Deras (Fade In Smooth)
	if rain_node:
		var rain_tween = create_tween()
		rain_tween.tween_property(rain_node, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD)
	
	# 4. Status berhasil & Tombol Next muncul dengan bounce lembut
	lbl_status.text = "Luar Biasa! Awan Jenuh, Presipitasi Terjadi: Hujan Turun ke Bumi! 🌧️"
	lbl_status.modulate = Color.WHITE
	lbl_status.set("theme_override_colors/font_color", Color(0.08, 0.62, 0.25, 1.0))
	
	btn_next.pivot_offset = btn_next.size / 2
	var btn_t = create_tween()
	btn_t.tween_property(btn_next, "modulate:a", 1.0, 0.4)
	btn_t.parallel().tween_property(btn_next, "scale", Vector2(1.05, 1.05), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	btn_t.tween_property(btn_next, "scale", Vector2.ONE, 0.15)

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

func _exit_tree() -> void:
	Global.play_rain_sfx(false)

func _on_btn_next_pressed() -> void:
	Global.play_sfx("klik")
	Global.play_rain_sfx(false)
	Global.complete_level(3, Global.ct_abstraction)
