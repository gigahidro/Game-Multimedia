extends TextureRect

@export var slot_index: int = 0
var level: Node = null

@onready var card_placed: TextureRect = $CardPlaced
@onready var lbl_tahap: Label = get_node_or_null("LblTahap")

func _ready() -> void:
	level = owner if owner != null else get_parent().get_parent()
	mouse_filter = Control.MOUSE_FILTER_STOP

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if level == null or level.level_completed:
		return false
	return typeof(data) == TYPE_DICTIONARY and data.has("card_name")

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Global.play_sfx("card_snap")
	if level:
		level.on_slot_dropped(slot_index, data)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if level == null or level.level_completed:
		return null
	var current_card = level.get_card_at_slot(slot_index)
	if current_card == "":
		return null
	
	Global.play_sfx("card_grab")
	var tex = card_placed.texture
	var data = {
		"card_name": current_card,
		"from_slot": slot_index,
		"texture": tex
	}
	
	# Bungkus preview dalam Control holder agar posisi kartu pas mengikuti kursor mouse (offset _at_position)
	var preview_holder = Control.new()
	var preview = TextureRect.new()
	preview.texture = tex
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.size = card_placed.size
	preview.position = -_at_position
	preview.pivot_offset = card_placed.size / 2
	preview.modulate = Color(1.15, 1.15, 1.15, 0.92)
	preview_holder.add_child(preview)
	set_drag_preview(preview_holder)
	
	return data

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if level:
			level.on_slot_clicked(slot_index)
