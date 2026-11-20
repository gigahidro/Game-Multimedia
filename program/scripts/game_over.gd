extends Control

@onready var lbl_score: Label = get_node_or_null("CenterBox/CardPanel/InnerVBox/LblScore")
@onready var btn_retry: Button = $CenterBox/Buttons/BtnRetry
@onready var btn_menu: Button = $CenterBox/Buttons/BtnMenu
@onready var card_panel: PanelContainer = get_node_or_null("CenterBox/CardPanel")

var tweens: Dictionary = {}

func _ready() -> void:
	Global.play_sfx("gagal")
	
	if not lbl_score:
		lbl_score = get_node_or_null("CenterBox/LblScore")
	if lbl_score:
		lbl_score.text = "Skor Akhir: " + str(Global.score) + " Poin"

	for btn in [btn_retry, btn_menu]:
		if btn:
			_setup_button_animations(btn)
			
	if card_panel:
		card_panel.pivot_offset = card_panel.size / 2
		card_panel.scale = Vector2(0.9, 0.9)
		var t = create_tween()
		t.tween_property(card_panel, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _setup_button_animations(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	btn.mouse_entered.connect(_on_hover.bind(btn))
	btn.mouse_exited.connect(_on_unhover.bind(btn))
	btn.button_down.connect(_on_press.bind(btn))
	btn.button_up.connect(_on_release.bind(btn))

func _on_hover(btn: Button) -> void:
	_tween_btn(btn, Vector2(1.05, 1.05), Color(1.1, 1.1, 1.1, 1.0))

func _on_unhover(btn: Button) -> void:
	_tween_btn(btn, Vector2(1.0, 1.0), Color(1.0, 1.0, 1.0, 1.0))

func _on_press(btn: Button) -> void:
	Global.play_sfx("klik")
	_tween_btn(btn, Vector2(0.95, 0.95), Color(0.9, 0.9, 0.9, 1.0))

func _on_release(btn: Button) -> void:
	_tween_btn(btn, Vector2(1.05, 1.05), Color(1.1, 1.1, 1.1, 1.0))

func _tween_btn(btn: Button, target_scale: Vector2, target_color: Color) -> void:
	if tweens.has(btn) and tweens[btn] and tweens[btn].is_running():
		tweens[btn].kill()
	btn.pivot_offset = btn.size / 2
	var t = create_tween().set_parallel(true)
	t.tween_property(btn, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
	t.tween_property(btn, "modulate", target_color, 0.1).set_trans(Tween.TRANS_SINE)
	tweens[btn] = t

func _on_btn_retry_pressed() -> void:
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/levels/level_1_evaporasi.tscn")

func _on_btn_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
