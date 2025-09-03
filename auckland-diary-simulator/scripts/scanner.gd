extends Node2D

var draggable = false
var selected = false
var area_ref
var initialPos: Vector2
var scaleBy: float = 1
@onready var centre_area: Area2D = $CentreArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var scanner_click_area: Area2D = $ScannerClickArea
@onready var ray_sprite: Sprite2D = $RaySprite
@onready var scanner_area: Area2D = $ScannerArea
@onready var scan_timer: Timer = $ScannerArea/ScanTimer


func _ready() -> void:
	scale = Vector2(scaleBy, scaleBy)
	initialPos = position
	MouseManager.push(scanner_click_area)
	sprite_2d.region_rect = Rect2(0, 0, 128, 128)  # (x, y, w, h)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		# Ensure nothing is being dragged right now, scanner is always top object so no need to check
		if MouseManager.current_dragged == null:
			# Update Mouse Manager
			MouseManager.selectScanner = true
			MouseManager.current_dragged = scanner_click_area
			MouseManager.is_dragging = true
			selected = true;
			# Update Sprite
			sprite_2d.region_rect = Rect2(128, 0, 128, 128)  # (x, y, w, h)
			ray_sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	z_index = MouseManager.top_z_index + 1
	if selected:
		# Handle rotation
		global_position = lerp(global_position, get_global_mouse_position() + Vector2(1, 0), 25 * delta)
		if get_global_mouse_position().x < global_position.x:
			rotation = lerp_angle(rotation, -global_position.angle_to_point(get_global_mouse_position()) + PI, 10 * delta)
		else:
			rotation = lerp_angle(rotation, global_position.angle_to_point(get_global_mouse_position()), 10 * delta)
	else:
		# Reset to no rotation
		rotation = lerp_angle(rotation, 0, 10 * delta)
		global_position = lerp(global_position, initialPos, 10 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			MouseManager.push(scanner_click_area) # Always goes front
			if selected:
				MouseManager.current_dragged = null
				selected = false;
				MouseManager.is_dragging = false
				MouseManager.selectScanner = false
				sprite_2d.region_rect = Rect2(0, 0, 128, 128)  # (x, y, w, h)
				ray_sprite.visible = false
		
			# Tween location depending if dropped in a snappable area, the table, or nothing
			

# When mouse enters an area, check again if current top object is the same
func _on_area_2d_mouse_entered() -> void:
	if !MouseManager.is_dragging:
		MouseManager.signalAllObjects()
		
# When mouse leaves an area, check again if current top object is the same
func _on_area_2d_mouse_exited() -> void:
	if !MouseManager.is_dragging:
		MouseManager.signalAllObjects()

# Check if current top object is the same, if it is be draggable, if not be false
func check_top() -> void:
	var area = MouseManager.pick_top_object(get_global_mouse_position())
	if area == scanner_click_area:
		draggable = true
		scale = Vector2(scaleBy + 0.1, scaleBy + 0.1)
	else:
		draggable = false
		scale = Vector2(scaleBy, scaleBy)
		
			
func rescale():
	var tweenScale = get_tree().create_tween()
	var tweenScale2 = get_tree().create_tween()
	tweenScale.tween_property(self, "scale", Vector2(scaleBy + 0.05, scaleBy + 0.05), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale2.tween_property(centre_area, "global_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)

func _on_scanner_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('scannable'):
		if area.get_parent().is_inside_desk == true:
			area_ref = area
			scan_timer.start()
			ray_sprite.region_rect = Rect2(0, 0, 180, 100)  # (x, y, w, h)

func _on_scanner_area_area_exited(area: Area2D) -> void:
	if area.is_in_group('scannable'):
		scan_timer.stop()
		ray_sprite.region_rect = Rect2(180, 0, 180, 100)  # (x, y, w, h)

func _on_scan_timer_timeout() -> void:
	var area = MouseManager.pick_top_object(scanner_area.global_position)
	if area == area_ref:
		area_ref.get_parent().scanned = true;
		ProductManager.scan(area_ref.get_parent())
