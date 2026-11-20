extends Node2D

@onready var hud = $HUD
@onready var bg_malam: TextureRect = $Backgrounds/BgMalam
@onready var bg_siang: TextureRect = $Backgrounds/BgSiang
@onready var bulan: TextureRect = $Celestial/Bulan
@onready var matahari: TextureRect = $Celestial/Matahari

@onready var uap_laut: CPUParticles2D = $Particles/UapLaut
@onready var uap_pohon: CPUParticles2D = $Particles/UapPohon

@onready var panduan_malam: TextureRect = $UI/PanduanMalam
@onready var panduan_siang: TextureRect = $UI/PanduanSiang
@onready var btn_transisi_siang: TextureButton = $UI/BtnTransisiSiang

@onready var panel_suhu_card: TextureRect = $UI/PanelSuhuCard
@onready var slider_suhu: HSlider = $UI/PanelSuhuCard/SliderSuhu
@onready var lbl_suhu_val: Label = $UI/PanelSuhuCard/LblSuhuVal

@onready var progress_bar: ProgressBar = $UI/ProgressContainer/ProgressBar
@onready var lbl_status: Label = $UI/ProgressContainer/LblStatus
@onready var btn_next: TextureButton = $UI/BtnNext

const TEX_KNOB_KUNING = preload("res://assets/sprites/element/knop_kuning_pengatur_suhu.png")
const TEX_KNOB_BIRU = preload("res://assets/sprites/element/knop_biru_pengatur_suhu.png")

var slider_fill_style: StyleBoxFlat = null
var is_daytime: bool = false
var evaporation_progress: float = 0.0
var level_completed: bool = false
var wrong_order_count: int = 0
var tweens: Dictionary = {}

var sun_pulse_tween: Tween = null
var pulse_time: float = 0.0
var panel_shake_tween: Tween = null
var panel_suhu_initial_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.play_bgm("musik_level")
	Global.current_level = 1
	hud.update_hud()
	hud.set_help_instruction("Misi Dekomposisi: Temukan kombinasi kondisi alam yang tepat agar air laut & pohon bisa menguap!")
	
	progress_bar.value = 0.0
	panel_suhu_card.visible = true
	panel_suhu_card.modulate.a = 1.0
	btn_transisi_siang.visible = true
	btn_transisi_siang.modulate.a = 1.0
	panel_suhu_initial_pos = panel_suhu_card.position
	
	var orig_fill = slider_suhu.get_theme_stylebox("grabber_area")
	if orig_fill is StyleBoxFlat:
		slider_fill_style = orig_fill.duplicate()
		slider_suhu.add_theme_stylebox_override("grabber_area", slider_fill_style)
		slider_suhu.add_theme_stylebox_override("grabber_area_highlight", slider_fill_style)
	
	_update_suhu_label(slider_suhu.value)
	_setup_button_animations(btn_transisi_siang)
	_setup_button_animations(btn_next)
	
	matahari.pivot_offset = matahari.size / 2

func _process(delta: float) -> void:
	if level_completed:
		return
	
	var suhu = slider_suhu.value
	
	# Animasi denyut / pendaran sinar matahari (Opsi 2: Pulsing & Glow)
	if is_daytime:
		var pulse_speed = 3.0
		var pulse_amount = 0.03
		if suhu >= 45.0:
			pulse_speed = 6.0
			pulse_amount = 0.07
		
		pulse_time += delta * pulse_speed
		var scale_factor = 1.0 + sin(pulse_time) * pulse_amount
		matahari.scale = Vector2(scale_factor, scale_factor)
		
		# Pendaran warna hangat saat panas
		if suhu >= 45.0:
			var glow_val = 1.0 + (sin(pulse_time) * 0.15)
			matahari.modulate = Color(glow_val, glow_val * 0.95, glow_val * 0.85, 1.0)
		else:
			matahari.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	if is_daytime and suhu >= 45.0:
		uap_laut.emitting = true
		uap_pohon.emitting = true
		
		# Kecepatan evaporasi proporsional terhadap suhu
		var speed = lerp(15.0, 35.0, (suhu - 45.0) / 25.0)
		evaporation_progress = min(100.0, evaporation_progress + delta * speed)
		progress_bar.value = evaporation_progress
		
		lbl_status.text = "Suhu panas! Air laut menguap (Evaporasi) & pohon berkeringat (Transpirasi)!"
		lbl_status.modulate = Color(0.3, 1.0, 0.4)
		
		if evaporation_progress >= 100.0:
			_on_evaporation_completed()
	else:
		uap_laut.emitting = false
		uap_pohon.emitting = false
		
		if not is_daytime:
			if suhu >= 45.0:
				lbl_status.text = "Suhu dinaikkan, tapi matahari malam belum bersinar. Dekomposisi belum lengkap: butuh waktu siang!"
				lbl_status.modulate = Color(1.0, 0.4, 0.4)
			else:
				lbl_status.text = "Malam hari: Suhu dingin, belum ada penguapan air."
				lbl_status.modulate = Color(0.8, 0.9, 1.0)
		elif suhu < 45.0:
			lbl_status.text = "Hari sudah siang, tapi suhu belum cukup panas (geser slider ke >= 45°C)!"
			lbl_status.modulate = Color(1.0, 0.8, 0.2)

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

func _update_suhu_label(val: float) -> void:
	if val < 30.0:
		slider_suhu.add_theme_icon_override("grabber", TEX_KNOB_BIRU)
		slider_suhu.add_theme_icon_override("grabber_highlight", TEX_KNOB_BIRU)
		if slider_fill_style:
			slider_fill_style.bg_color = Color(0.2, 0.65, 0.95, 1.0)
			slider_fill_style.border_color = Color(0.1, 0.4, 0.7, 1.0)
	else:
		slider_suhu.add_theme_icon_override("grabber", TEX_KNOB_KUNING)
		slider_suhu.add_theme_icon_override("grabber_highlight", TEX_KNOB_KUNING)
		if slider_fill_style:
			if val >= 45.0:
				slider_fill_style.bg_color = Color(1.0, 0.42, 0.12, 1.0)
				slider_fill_style.border_color = Color(0.85, 0.25, 0.05, 1.0)
			else:
				slider_fill_style.bg_color = Color(0.98, 0.62, 0.15, 1.0)
				slider_fill_style.border_color = Color(0.85, 0.45, 0.08, 1.0)
	
	var category = ""
	if val < 30.0:
		category = " (Redup / Dingin)"
	elif val < 45.0:
		category = " (Sedang / Hangat)"
	else:
		category = " (Terik 🔥 / Panas)"
	lbl_suhu_val.text = str(int(val)) + " °C" + category

func _shake_panel(panel: Control) -> void:
	if panel_suhu_initial_pos == Vector2.ZERO:
		panel_suhu_initial_pos = panel.position
	if panel_shake_tween and panel_shake_tween.is_running():
		panel_shake_tween.kill()
		panel.position = panel_suhu_initial_pos
	
	panel_shake_tween = create_tween()
	var shake_offset = 8.0
	panel_shake_tween.tween_property(panel, "position:x", panel_suhu_initial_pos.x - shake_offset, 0.04)
	panel_shake_tween.tween_property(panel, "position:x", panel_suhu_initial_pos.x + shake_offset, 0.04)
	panel_shake_tween.tween_property(panel, "position:x", panel_suhu_initial_pos.x - shake_offset * 0.5, 0.04)
	panel_shake_tween.tween_property(panel, "position:x", panel_suhu_initial_pos.x, 0.04)

func _on_slider_suhu_value_changed(value: float) -> void:
	_update_suhu_label(value)
	
	# Feedback CT jika pemain mencoba menaikkan suhu saat malam hari
	if not is_daytime and value >= 45.0 and not level_completed:
		wrong_order_count += 1
		Global.play_sfx("gagal")
		lbl_status.text = "Suhu dinaikkan, tapi matahari malam belum bersinar. Dekomposisi belum lengkap: butuh waktu siang!"
		lbl_status.modulate = Color(1.0, 0.4, 0.4)
		_shake_panel(panel_suhu_card)
	elif is_daytime and value < 45.0:
		lbl_status.text = "Hari sudah siang, tapi suhu belum cukup panas (geser slider ke >= 45°C)!"
		lbl_status.modulate = Color(1.0, 0.8, 0.2)

func _on_btn_transisi_siang_pressed() -> void:
	if is_daytime:
		return
	is_daytime = true
	Global.play_sfx("klik")
	Global.play_sfx("siang")
	
	if slider_suhu.value >= 45.0:
		uap_laut.emitting = true
		uap_pohon.emitting = true
		lbl_status.text = "Suhu panas! Air laut menguap (Evaporasi) & pohon berkeringat (Transpirasi)!"
		lbl_status.modulate = Color(0.3, 1.0, 0.4)
	
	# Transisi halus ke siang hari
	var t = create_tween().set_parallel(true)
	t.tween_property(bg_siang, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(bulan, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(matahari, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(panduan_malam, "modulate:a", 0.0, 0.5)
	t.tween_property(btn_transisi_siang, "modulate:a", 0.0, 0.4)
	
	await t.finished
	panduan_malam.visible = false
	btn_transisi_siang.visible = false
	
	panduan_siang.visible = true
	panduan_siang.modulate.a = 0.0
	
	var t2 = create_tween()
	t2.tween_property(panduan_siang, "modulate:a", 1.0, 0.6)

func _on_evaporation_completed() -> void:
	level_completed = true
	Global.play_sfx("berhasil")
	lbl_status.text = "Luar Biasa! Air laut menguap (Evaporasi) & pohon berkeringat (Transpirasi)!"
	lbl_status.modulate = Color(0.2, 1.0, 0.5)
	
	# Kalkulasi skor CT Dekomposisi
	var ct_points = 100
	if wrong_order_count > 0:
		ct_points = max(60, 100 - (wrong_order_count * 15))
	
	Global.add_score(250)
	Global.ct_decomposition = ct_points
	hud.update_hud()
	
	btn_next.visible = true
	btn_next.modulate.a = 0.0
	var t = create_tween()
	t.tween_property(btn_next, "modulate:a", 1.0, 0.5)

func _on_btn_next_pressed() -> void:
	Global.play_sfx("klik")
	Global.complete_level(1, Global.ct_decomposition)
