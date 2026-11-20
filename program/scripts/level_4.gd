extends Control

@onready var hud = $HUD
@onready var slots_container = $SlotsContainer
@onready var slot1 = $SlotsContainer/Slot1
@onready var slot2 = $SlotsContainer/Slot2
@onready var slot3 = $SlotsContainer/Slot3
@onready var slot4 = $SlotsContainer/Slot4

@onready var card_pres = $CardsContainer/CardPres
@onready var card_evap = $CardsContainer/CardEvap
@onready var card_infi = $CardsContainer/CardInfi
@onready var card_kond = $CardsContainer/CardKond

@onready var btn_reset: TextureButton = $ActionRow/BtnReset
@onready var btn_check: TextureButton = $ActionRow/BtnCheck
@onready var btn_next: TextureButton = $BtnNext
@onready var lbl_feedback: Label = $Panduan/VBox/LblFeedback

const TEX_EVAP = preload("res://assets/sprites/element/kartu_evaporasi.png")
const TEX_KOND = preload("res://assets/sprites/element/kartu_kondensasi.png")
const TEX_PRES = preload("res://assets/sprites/element/kartu_presipitasi.png")
const TEX_INFI = preload("res://assets/sprites/element/kartu_infiltrasi.png")

const CORRECT_ORDER: Array[String] = ["Evaporasi", "Kondensasi", "Presipitasi", "Infiltrasi"]
var slot_cards: Array[String] = ["", "", "", ""]
var selected_tray_card: String = ""
var level_completed: bool = false
var wrong_attempts: int = 0
var tweens: Dictionary = {}

func _ready() -> void:
	Global.play_bgm("musik_level")
	Global.current_level = 4
	hud.update_hud()
	hud.set_help_instruction("Tarik (drag & drop) gambar tahapan siklus air ke kotak Tahap 1 sampai 4 secara berurutan!")
	
	btn_next.visible = false
	btn_next.modulate.a = 0.0
	
	# Setup button animations
	for btn in [btn_reset, btn_check, btn_next]:
		_setup_button_animations(btn)
	
	_refresh_slots_display()

func _setup_button_animations(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: TextureButton) -> void:
	if btn.disabled:
		return
	_tween_btn(btn, Vector2(1.05, 1.05), Color(1.12, 1.12, 1.12, 1.0))

func _on_unhover(btn: TextureButton) -> void:
	if btn.disabled:
		return
	_tween_btn(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: TextureButton) -> void:
	if btn.disabled:
		return
	Global.play_sfx("klik")
	_tween_btn(btn, Vector2(0.94, 0.94), Color(0.85, 0.85, 0.85, 1.0))

func _on_release(btn: TextureButton) -> void:
	if btn.disabled:
		return
	_tween_btn(btn, Vector2(1.05, 1.05), Color(1.12, 1.12, 1.12, 1.0))

func _tween_btn(btn: TextureButton, target_scale: Vector2, target_color: Color) -> void:
	if tweens.has(btn) and tweens[btn] and tweens[btn].is_running():
		tweens[btn].kill()
	btn.pivot_offset = btn.size / 2
	var t = create_tween().set_parallel(true)
	t.tween_property(btn, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
	t.tween_property(btn, "modulate", target_color, 0.1).set_trans(Tween.TRANS_SINE)
	tweens[btn] = t

func _get_card_texture(name: String) -> Texture2D:
	match name:
		"Evaporasi":
			return TEX_EVAP
		"Kondensasi":
			return TEX_KOND
		"Presipitasi":
			return TEX_PRES
		"Infiltrasi":
			return TEX_INFI
	return null

func _get_tray_card_node(name: String) -> Node:
	match name:
		"Evaporasi":
			return card_evap
		"Kondensasi":
			return card_kond
		"Presipitasi":
			return card_pres
		"Infiltrasi":
			return card_infi
	return null

func get_card_at_slot(idx: int) -> String:
	if idx >= 0 and idx < slot_cards.size():
		return slot_cards[idx]
	return ""

func _refresh_slots_display() -> void:
	var slots = [slot1, slot2, slot3, slot4]
	for i in range(4):
		var slot_node = slots[i]
		var card_placed = slot_node.get_node("CardPlaced") as TextureRect
		var lbl_tahap = slot_node.get_node_or_null("LblTahap") as Label
		
		var card_name = slot_cards[i]
		if card_name != "":
			card_placed.texture = _get_card_texture(card_name)
			card_placed.visible = true
			if lbl_tahap:
				lbl_tahap.text = "Tahap " + str(i + 1)
		else:
			card_placed.visible = false
			card_placed.texture = null
			if lbl_tahap:
				lbl_tahap.text = "Tahap " + str(i + 1)

func place_card_in_slot(target_slot_idx: int, card_name: String) -> void:
	if level_completed or target_slot_idx < 0 or target_slot_idx >= 4:
		return
	
	# Jika kartu ini sudah berada di slot lain, kosongkan slot asalnya (move/swap)
	for i in range(4):
		if i != target_slot_idx and slot_cards[i] == card_name:
			slot_cards[i] = ""
	
	# Jika slot target sudah berisi kartu lain, kembalikan kartu lama ke tray
	var old_card = slot_cards[target_slot_idx]
	if old_card != "" and old_card != card_name:
		var old_node = _get_tray_card_node(old_card)
		if old_node:
			old_node.is_placed = false
			old_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# Pasang kartu baru ke slot target
	slot_cards[target_slot_idx] = card_name
	var new_node = _get_tray_card_node(card_name)
	if new_node:
		new_node.is_placed = true
		new_node.modulate = Color(0.4, 0.4, 0.4, 0.45)
	
	_refresh_slots_display()
	
	# Animasi bounce pop pada slot target
	var slots = [slot1, slot2, slot3, slot4]
	var target_slot = slots[target_slot_idx]
	var placed_card = target_slot.get_node("CardPlaced") as TextureRect
	placed_card.scale = Vector2(0.4, 0.4)
	var t = create_tween()
	t.tween_property(placed_card, "scale", Vector2(1.08, 1.08), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(placed_card, "scale", Vector2.ONE, 0.08)
	
	selected_tray_card = ""
	lbl_feedback.text = card_name + " diletakkan di Tahap " + str(target_slot_idx + 1) + "."
	lbl_feedback.modulate = Color(0.12, 0.45, 0.85)

func remove_card_from_slot(slot_idx: int) -> void:
	if level_completed or slot_idx < 0 or slot_idx >= 4:
		return
	var card_name = slot_cards[slot_idx]
	if card_name == "":
		return
	
	slot_cards[slot_idx] = ""
	var card_node = _get_tray_card_node(card_name)
	if card_node:
		card_node.is_placed = false
		card_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	_refresh_slots_display()
	lbl_feedback.text = card_name + " dikembalikan ke daftar kartu."
	lbl_feedback.modulate = Color(0.65, 0.45, 0.15)

func on_slot_dropped(target_slot_idx: int, data: Dictionary) -> void:
	var card_name = data.get("card_name", "")
	var from_slot = data.get("from_slot", -1)
	
	if card_name == "":
		return
	
	# Jika ditarik dari slot lain (swap)
	if from_slot >= 0 and from_slot < 4:
		var displaced_card = slot_cards[target_slot_idx]
		slot_cards[from_slot] = displaced_card
		slot_cards[target_slot_idx] = card_name
		_refresh_slots_display()
		lbl_feedback.text = "Posisi kartu ditukar: " + card_name + " ke Tahap " + str(target_slot_idx + 1) + "."
		lbl_feedback.modulate = Color(0.12, 0.45, 0.85)
		return
	
	# Jika ditarik dari daftar kartu bawah
	place_card_in_slot(target_slot_idx, card_name)

func on_slot_clicked(slot_idx: int) -> void:
	if level_completed:
		return
	
	# Jika pemain sedang memilih kartu dari bawah, masukkan ke slot ini
	if selected_tray_card != "":
		place_card_in_slot(slot_idx, selected_tray_card)
		return
	
	# Jika slot sudah terisi kartu, klik pada slot akan melepas kartu kembali
	if slot_cards[slot_idx] != "":
		remove_card_from_slot(slot_idx)

func on_card_clicked(process_name: String, _card_node: Node) -> void:
	if level_completed:
		return
	
	# Jika diklik, jadikan selected_tray_card dan beri petunjuk drag
	selected_tray_card = process_name
	lbl_feedback.text = "Geser (drag) " + process_name + " ke kotak Tahap 1, 2, 3, atau 4 di atas!"
	lbl_feedback.modulate = Color(0.15, 0.5, 0.85)
	
	# Pulsa lembut pada kotak slot yang masih kosong
	var slots = [slot1, slot2, slot3, slot4]
	for i in range(4):
		if slot_cards[i] == "":
			var st = create_tween()
			st.tween_property(slots[i], "scale", Vector2(1.05, 1.05), 0.1)
			st.tween_property(slots[i], "scale", Vector2.ONE, 0.1)

func _shake_slots() -> void:
	var orig_x = slots_container.position.x
	var t = create_tween()
	t.tween_property(slots_container, "position:x", orig_x - 14.0, 0.04)
	t.tween_property(slots_container, "position:x", orig_x + 14.0, 0.05)
	t.tween_property(slots_container, "position:x", orig_x - 9.0, 0.04)
	t.tween_property(slots_container, "position:x", orig_x + 9.0, 0.04)
	t.tween_property(slots_container, "position:x", orig_x, 0.04)

func _on_btn_reset_pressed() -> void:
	if level_completed:
		return
	
	for i in range(4):
		slot_cards[i] = ""
	
	selected_tray_card = ""
	for card in [card_evap, card_kond, card_pres, card_infi]:
		if card:
			card.is_placed = false
			card.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	lbl_feedback.text = "Urutan kartu di-reset. Geser kartu ke kotak tahapan di atas."
	lbl_feedback.modulate = Color(0.18, 0.45, 0.72)
	_refresh_slots_display()

func _on_btn_check_pressed() -> void:
	if level_completed:
		return
	
	# Cek apakah masih ada kotak kosong
	for i in range(4):
		if slot_cards[i] == "":
			lbl_feedback.text = "Kotak Tahap " + str(i + 1) + " masih kosong! Lengkapi semua 4 tahapan."
			lbl_feedback.modulate = Color(0.85, 0.45, 0.05)
			return
	
	# Periksa urutan
	if slot_cards == CORRECT_ORDER:
		level_completed = true
		Global.play_sfx("berhasil")
		lbl_feedback.text = "Urutan Benar! Siklus air tersusun secara sempurna! 🎉"
		lbl_feedback.modulate = Color(0.12, 0.65, 0.25)
		
		var ct_points = max(60, 100 - (wrong_attempts * 15))
		Global.ct_algorithm = ct_points
		Global.add_score(250)
		hud.update_hud()
		
		# Efek hijau selebrasi pada slot
		var slots = [slot1, slot2, slot3, slot4]
		for s in slots:
			var st = create_tween()
			st.tween_property(s, "modulate", Color(0.7, 1.25, 0.7, 1.0), 0.2)
		
		btn_next.visible = true
		btn_next.modulate.a = 0.0
		var bt = create_tween()
		bt.tween_property(btn_next, "modulate:a", 1.0, 0.4)
		bt.parallel().tween_property(btn_next, "scale", Vector2(1.06, 1.06), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		bt.tween_property(btn_next, "scale", Vector2.ONE, 0.15)
	else:
		wrong_attempts += 1
		lbl_feedback.text = "Urutan belum tepat! Coba ingat kembali aliran siklus air."
		lbl_feedback.modulate = Color(0.85, 0.18, 0.18)
		_shake_slots()
		Global.play_sfx("gagal")
		
		# Jeda sebentar lalu reset kartu agar siswa dapat mencoba kembali
		await get_tree().create_timer(0.75).timeout
		if not level_completed:
			_on_btn_reset_pressed()

func _on_btn_next_pressed() -> void:
	Global.complete_level(4, Global.ct_algorithm)
