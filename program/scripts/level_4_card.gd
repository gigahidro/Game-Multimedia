extends TextureRect

@export var process_name: String = ""
var level: Node = null
var is_placed: bool = false
var tweens: Dictionary = {}

func _ready() -> void:
	level = owner if owner != null else get_parent().get_parent()
	mouse_filter = Control.MOUSE_FILTER_STOP
	pivot_offset = size / 2

func _get_drag_data(_at_position: Vector2) -> Variant:
	if is_placed or (level and level.level_completed):
		return null
	
	var data = {
		"card_name": process_name,
		"from_slot": -1,
		"texture": texture
	}
	
	# Bungkus preview dalam Control holder agar posisi kartu pas mengikuti kursor mouse (offset _at_position)
	var preview_holder = Control.new()
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.size = size
	preview.position = -_at_position
	preview.pivot_offset = size / 2
	preview.modulate = Color(1.15, 1.15, 1.15, 0.92)
	preview_holder.add_child(preview)
	set_drag_preview(preview_holder)
	
	# Beri sedikit feedback animasi saat diangkat
	Global.play_sfx("card_grab")
	_tween_scale(Vector2(0.92, 0.92))
	
	return data

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not is_placed:
			_tween_scale(Vector2.ONE)

func _gui_input(event: InputEvent) -> void:
	if is_placed or (level and level.level_completed):
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if level:
			level.on_card_clicked(process_name, self)

func _notification_mouse_enter() -> void:
	if not is_placed and not (level and level.level_completed):
		_tween_scale(Vector2(1.06, 1.06))

func _notification_mouse_exit() -> void:
	if not is_placed:
		_tween_scale(Vector2.ONE)

func _tween_scale(target_scale: Vector2) -> void:
	pivot_offset = size / 2
	var t = create_tween()
	t.tween_property(self, "scale", target_scale, 0.1).set_trans(Tween.TRANS_SINE)
