extends Node2D

var draggable = false
var selected = false
var body_ref
var initialPos: Vector2
var scaleBy: float = 1
@onready var centre_area: Area2D = $CentreArea
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	scale = Vector2(scaleBy, scaleBy)
	initialPos = position
	MouseManager.push(self)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		if MouseManager.current_dragged == null:
			MouseManager.selectScanner = true
			MouseManager.current_dragged = self
			selected = true;
			# Bring this object to the front
			MouseManager.is_dragging = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	z_index = MouseManager.top_z_index + 1
	if selected:
		global_position = lerp(global_position, get_global_mouse_position() + Vector2(1, 0), 25 * delta)
		if get_global_mouse_position().x < global_position.x:
			sprite_2d.look_at(get_global_mouse_position())
			sprite_2d.rotation_degrees += 180
		else:
			sprite_2d.look_at(get_global_mouse_position())
	else:
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, 0, 10 * delta)
		global_position = lerp(global_position, initialPos, 10 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if selected and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			MouseManager.current_dragged = null
			selected = false;
			MouseManager.is_dragging = false
		
			# Tween location depending if dropped in a snappable area, the table, or nothing
			

func _on_area_2d_mouse_entered() -> void:
	if !MouseManager.is_dragging:
		if MouseManager.is_hovering:
			var area = MouseManager.pick_top_object(get_global_mouse_position())
			if area == self:
				MouseManager.signalAllObjects()
			else:
				return;
		draggable = true
		MouseManager.is_hovering = true
		scale = Vector2(scaleBy + 0.05, scaleBy + 0.05)

func check_top() -> void:
	var area = MouseManager.pick_top_object(get_global_mouse_position())
	if area == self:
		draggable = true
		scale = Vector2(scaleBy + 0.05, scaleBy + 0.05)
	else:
		draggable = false
		scale = Vector2(scaleBy, scaleBy)

func _on_area_2d_mouse_exited() -> void:
	if !MouseManager.is_dragging:
		MouseManager.signalAllObjects()
		draggable = false
		scale = Vector2(scaleBy, scaleBy)
		
			
func rescale():
	var tweenScale = get_tree().create_tween()
	var tweenScale2 = get_tree().create_tween()
	tweenScale.tween_property(self, "scale", Vector2(scaleBy + 0.05, scaleBy + 0.05), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale2.tween_property(centre_area, "global_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)
