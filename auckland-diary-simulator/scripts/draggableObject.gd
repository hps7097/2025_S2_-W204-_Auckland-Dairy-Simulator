extends Node2D

var draggable = false
var selected = false
var scanned = false
var bagged = false

var is_inside_dropable = false

var is_inside_till = true
var is_inside_desk = false
var is_hovering_till = true
var is_hovering_desk = false

var body_ref
var dropPos
var initialPos: Vector2
var scaleBy: float = 1
var bagPos: Vector2

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Ensure centre point area never changes size
	centre_area.global_scale = Vector2(1, 1)
	# Always have size change depending on scaleBy
	scale = lerp(scale, Vector2(scaleBy, scaleBy), 10 * delta)
	if selected:
		# Follow Mouse
		global_position = lerp(global_position, get_global_mouse_position() + Vector2(-1, 0), 25 * delta)
		# Animate Shadow:
		drop_shadow.modulate = lerp(drop_shadow.modulate, Color(1, 1, 1, 0.3), 25 * delta)
		drop_shadow.position = lerp(drop_shadow.position, Vector2(0,40 + 20 * scaleBy), 25 * delta)
		# Handle rotation
		if get_global_mouse_position().x < global_position.x:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, global_position.angle_to_point(get_global_mouse_position()) + PI, 20 * delta)
			sprite_2d.flip_h = true;
		else:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, global_position.angle_to_point(get_global_mouse_position()), 20 * delta)
			sprite_2d.flip_h = false
	else:
		# Reset Rotation
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, 0, 10 * delta)
		# Animate Shadow:
		drop_shadow.modulate = lerp(drop_shadow.modulate, Color(1, 1, 1, 0), 20 * delta)
		drop_shadow.position = lerp(drop_shadow.position, Vector2(0, 0), 20 * delta)
		# Move Object
		if is_inside_dropable and scanned: # Snap to droppable location (bagging area)
			position = lerp(position, bagPos, 20 * delta)
		elif is_inside_dropable or (not is_hovering_till && not is_hovering_desk): # Return to initial location if not on table or trying to bag but not scanned
			dropPos = initialPos
			global_position = lerp(global_position, initialPos, 10 * delta)
		else: # Just drop to current location
			position = lerp(position, dropPos, 20 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# When dropped
		if selected and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			# Update Mouse Manager
			MouseManager.current_dragged = null
			MouseManager.is_dragging = false
			# Update Object
			selected = false;
			dropPos = drop_shadow.global_position
			# Check if bagged:
			if is_inside_dropable and scanned:
				bagged = true
				ProductManager.bag(self)
				# Randomise position in the bagging area
				bagPos = Vector2(0, randi_range(-50, 50)) + body_ref.position
			else:
					bagged = false;
					ProductManager.unbag(self)

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
		body_ref = body

func _on_click_area_body_exited(body: Node2D) -> void:
	# When exiting a snappable droppable area
	if body.is_in_group('dropable'):
		is_inside_dropable = false

func _on_hover_check_area_entered(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_hovering_till = true
		is_inside_till = true
		scaleBy = 1
	if area.is_in_group('desk'):
		is_hovering_desk = true
		is_inside_desk = true
		scaleBy = 2

func _on_hover_check_area_exited(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_hovering_till = false
		is_inside_till = false
		if is_inside_desk:
			scaleBy = 2
	if area.is_in_group('desk'):
		is_hovering_desk = false
		is_inside_desk = false
		if is_inside_till:
			scaleBy = 1


func _on_centre_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = true
		scaleBy = 1
	elif area.is_in_group('desk'):
		is_inside_desk = true
		scaleBy = 2


func _on_centre_area_area_exited(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = false
		if is_inside_desk:
			scaleBy = 2
	if area.is_in_group('desk'):
		is_inside_desk = false
		if is_inside_till:
			scaleBy = 1
