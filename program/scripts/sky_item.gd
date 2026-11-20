extends Area2D

@export var is_water: bool = true
@export var item_name: String = "Uap Air"

@onready var sprite: Sprite2D = $Sprite

var initial_y: float = 0.0
var initial_x: float = 0.0
var wobble_offset: float = 0.0
var base_scale: Vector2 = Vector2.ONE
var hover_tween: Tween = null
var shake_tween: Tween = null
var is_being_collected: bool = false

func _ready() -> void:
	initial_y = position.y
	initial_x = position.x
	wobble_offset = randf() * TAU
	base_scale = scale
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	if is_being_collected:
		return
	# Subtle floating bobbing motion
	var time = Time.get_ticks_msec() / 1000.0
	position.y = initial_y + sin(time * 2.2 + wobble_offset) * 7.0

func _on_mouse_entered() -> void:
	if is_being_collected:
		return
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	hover_tween = create_tween()
	hover_tween.tween_property(self, "scale", base_scale * 1.12, 0.12).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited() -> void:
	if is_being_collected:
		return
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	hover_tween = create_tween()
	hover_tween.tween_property(self, "scale", base_scale, 0.12).set_trans(Tween.TRANS_SINE)

func play_distractor_feedback() -> void:
	if is_being_collected:
		return
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	
	scale = base_scale
	var orig_x = initial_x
	var orig_mod = Color.WHITE
	
	shake_tween = create_tween()
	shake_tween.tween_property(self, "modulate", Color(1.3, 0.35, 0.35, 1.0), 0.06)
	shake_tween.tween_property(self, "position:x", orig_x - 12.0, 0.04)
	shake_tween.tween_property(self, "position:x", orig_x + 12.0, 0.05)
	shake_tween.tween_property(self, "position:x", orig_x - 7.0, 0.04)
	shake_tween.tween_property(self, "position:x", orig_x + 7.0, 0.04)
	shake_tween.tween_property(self, "position:x", orig_x, 0.04)
	shake_tween.tween_property(self, "modulate", orig_mod, 0.15)

func fly_to_target(target_pos: Vector2, on_reached: Callable) -> void:
	is_being_collected = true
	set_process(false)
	input_pickable = false
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	
	var t = create_tween().set_parallel(true)
	t.tween_property(self, "global_position", target_pos, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(self, "scale", base_scale * 0.25, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(self, "modulate:a", 0.4, 0.45)
	t.chain().tween_callback(func():
		on_reached.call()
		queue_free()
	)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_being_collected:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var lvl = owner if owner != null else get_parent().get_parent()
		if lvl == null or not lvl.has_method("collect_water_droplet"):
			lvl = get_tree().current_scene
		if lvl:
			if is_water:
				lvl.collect_water_droplet(self)
			else:
				lvl.hit_distractor(self)
