extends Node2D

var draggable = false
var selected = false
var scanned = false

var is_inside_dropable = false

var is_inside_till = true
var is_inside_desk = false
var is_hovering_till = true
var is_hovering_desk = false

var body_ref
var dropPos
var initialPos: Vector2
var scaleBy: float = 1
@onready var drop_shadow: Sprite2D = $DropShadow
@onready var centre_area: Area2D = $CentreArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var click_area: Area2D = $ClickArea

func _ready() -> void:
	sprite_2d.region_rect = Rect2(128 * randi_range(0, 3), 0, 128, 128)  # (x, y, w, h)
	scale = Vector2(scaleBy, scaleBy)
	dropPos = position
	MouseManager.push(click_area)

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		# Ensure nothing is being dragged right now
		if MouseManager.current_dragged == null:
			# Check if object is top most at mouse location
			var area = MouseManager.pick_top_object(event.position)
			if area == click_area:
				# Update Mouse Manager
				MouseManager.current_dragged = click_area
				MouseManager.push(click_area)
				MouseManager.is_dragging = true
				selected = true;
				# Bring this object to the front
				MouseManager.top_z_index += 1
				z_index = MouseManager.top_z_index
				initialPos = global_position
				# Shadow Animation
				var tweenShadowAlpha = get_tree().create_tween()
				var tweenShadowPos = get_tree().create_tween()
				tweenShadowAlpha.tween_property(drop_shadow, "modulate", Color(1, 1, 1, 0.3), 0.2).set_ease(Tween.EASE_OUT)
				tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,20 + 70 / scaleBy), 0.2).set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if selected:
		# Follow Mouse
		global_position = lerp(global_position, get_global_mouse_position() + Vector2(-1, 0), 25 * delta)
		# Handle rotation
		if get_global_mouse_position().x < global_position.x:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, -global_position.angle_to_point(get_global_mouse_position()) + PI, 20 * delta)
			sprite_2d.flip_h = true;
		else:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, global_position.angle_to_point(get_global_mouse_position()), 20 * delta)
			sprite_2d.flip_h = false
	else:
		# Reset Rotation
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, 0, 10 * delta)
		# Move Object
		if is_inside_dropable: # Snap to droppable location
			position = lerp(position, body_ref.position, 20 * delta)
		elif not is_hovering_till && not is_hovering_desk: # Return to initial location if not on table
			dropPos = initialPos
			global_position = lerp(global_position, initialPos, 10 * delta)
		else: # Just drop to current location
			position = lerp(position, dropPos, 20 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if selected and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Update Mouse Manager
			MouseManager.current_dragged = null
			MouseManager.is_dragging = false
			# Update Object
			selected = false;
			dropPos = position + Vector2(0, 50);
			# Shadow hide aniation
			var tweenShadowAlpha = get_tree().create_tween()
			var tweenShadowPos = get_tree().create_tween()
			tweenShadowAlpha.tween_property(drop_shadow, "modulate", Color(1, 1, 1, 0), 0.1).set_ease(Tween.EASE_OUT)
			tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,35), 0.1).set_ease(Tween.EASE_OUT)

# When mouse enters an area, check again if current top object is the same
func _on_click_area_mouse_entered() -> void:
	if !MouseManager.is_dragging:
		MouseManager.signalAllObjects()
		
# When mouse leaves an area, check again if current top object is the same
func _on_click_area_mouse_exited() -> void:
	if !MouseManager.is_dragging:
		MouseManager.signalAllObjects()

# Check if current top object is the same, if it is be draggable, if not be false
func check_top() -> void:
	var area = MouseManager.pick_top_object(get_global_mouse_position())
	if area == click_area:
		draggable = true
		scale = Vector2(scaleBy + 0.1, scaleBy + 0.1)
	else:
		draggable = false
		scale = Vector2(scaleBy, scaleBy)

func _on_click_area_body_entered(body: Node2D) -> void:
	# When entering a snappable droppable area
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.WEB_GRAY, 1)
		body_ref = body

func _on_click_area_body_exited(body: Node2D) -> void:
	# When exiting a snappable droppable area
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		body.modulate = Color(Color.LIGHT_GRAY, 0.7)

# Utilized whenever the object switches between till and desk, changing size (Shadow and sprite) 
func rescale():
	var tweenShadowPos = get_tree().create_tween()
	var tweenScale = get_tree().create_tween()
	var tweenScale2 = get_tree().create_tween()
	tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,20 + 70 / scaleBy), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale.tween_property(self, "scale", Vector2(scaleBy + 0.1, scaleBy + 0.1), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale2.tween_property(centre_area, "global_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)

func _on_hover_check_area_entered(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_hovering_till = true
		is_inside_till = true
		scaleBy = 1
		rescale()
	if area.is_in_group('desk'):
		is_hovering_desk = true
		is_inside_desk = true
		scaleBy = 2
		rescale()

func _on_hover_check_area_exited(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_hovering_till = false
		is_inside_till = false
		if is_inside_desk:
			scaleBy = 2
			rescale()
	if area.is_in_group('desk'):
		is_hovering_desk = false
		is_inside_desk = false
		if is_inside_till:
			scaleBy = 1
			rescale()


func _on_centre_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = true
		scaleBy = 1
		rescale()
	elif area.is_in_group('desk'):
		is_inside_desk = true
		scaleBy = 2
		rescale()


func _on_centre_area_area_exited(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = false
		if is_inside_desk:
			scaleBy = 2
			rescale()
	if area.is_in_group('desk'):
		is_inside_desk = false
		if is_inside_till:
			scaleBy = 1
			rescale()
