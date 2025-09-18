extends Node2D

enum Type { PIE, XXLPIE, V, VREFRESH, ICECREAM, CHOCOLATE, LOLLIES, CHIPS, MORECHIPS, BREADMILK }
var item_type: Type

var type_values := {
	Type.PIE: 3.50,
	Type.XXLPIE: 4.40,
	Type.V: 4.10,
	Type.VREFRESH: 4.30,
	Type.ICECREAM: 3.10,
	Type.CHOCOLATE: 2.60,
	Type.LOLLIES: 3.90,
	Type.CHIPS: 4.00,
	Type.MORECHIPS: 4.50,
	Type.BREADMILK: 3.40
}	

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
@onready var popup_text: Node2D = get_parent().get_node("PopupText")

func _ready() -> void:
	reset_item()

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		# Ensure nothing is being dragged right now
		if MouseManager.current_dragged == null and !bagged:
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
	if draggable:
		scale = lerp(scale, Vector2(scaleBy + 0.1, scaleBy + 0.1), 10 * delta)
	else:
		scale = lerp(scale, Vector2(scaleBy, scaleBy), 10 * delta)
	if selected:
		# Follow Mouse
		global_position = lerp(global_position, get_global_mouse_position() + Vector2(-1, 0), 25 * delta)
		# Animate Shadow:
		drop_shadow.modulate = lerp(drop_shadow.modulate, Color(1, 1, 1, 0.3), 25 * delta)
		drop_shadow.position = lerp(drop_shadow.position, Vector2(0,40 + 30 * scaleBy), 25 * delta)
		# Handle rotation
		if get_global_mouse_position().x < global_position.x:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, global_position.angle_to_point(get_global_mouse_position()) + PI, 10 * delta)
		else:
			sprite_2d.rotation = lerp_angle(sprite_2d.rotation, global_position.angle_to_point(get_global_mouse_position()), 10 * delta)
	else:
		# Reset Rotation
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, 0, 10 * delta)
		# Animate Shadow:
		drop_shadow.modulate = lerp(drop_shadow.modulate, Color(1, 1, 1, 0), 20 * delta)
		drop_shadow.position = lerp(drop_shadow.position, Vector2(0,  10 * scaleBy), 20 * delta)
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
			dropPos = drop_shadow.global_position + Vector2(0, -20 * scaleBy)
			# Check if bagged:
			if is_inside_dropable and scanned:
				bagged = true
				ProductManager.bag(self)
				# Randomise position in the bagging area
				bagPos = dropPos
				if bagPos.x > 80:
					bagPos.x = 80
				if bagPos.y > 900:
					bagPos.y = 900
			else:
				bagged = false;
				ProductManager.unbag(self)
				if is_inside_dropable:
					popup_text.calling("Scan item first!")

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
	else:
		draggable = false

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
			
func reset_item() -> void:
	# Randomising Item Type, remove if deliberately choosing type
	var keys  = Type.keys()
	var type = keys[randi_range(0, keys.size() - 1)]
	item_type = Type[type]
	# If upgrade unavailable, downgrade type
	if item_type == Type[keys[1]] && UpgradeManager.getUpgrade(1) < 1:
		item_type = Type[keys[0]]
	if item_type == Type[keys[3]] && UpgradeManager.getUpgrade(1) < 2:
		item_type = Type[keys[2]]
	if item_type == Type[keys[8]] && UpgradeManager.getUpgrade(1) < 3:
		item_type = Type[keys[7]]
		
	sprite_2d.region_rect = Rect2(128 * randi_range(0, 3), 128 * item_type, 128, 128)  # (x, y, w, h)
	position = Vector2(328, 650)
	dropPos = Vector2(randi_range(230, 430), randi_range(730, 900))
	scale = Vector2(scaleBy, scaleBy)
	MouseManager.push(click_area)
	scanned = false;
	bagged = false
	
func flash_white(area: Area2D) -> void:
	if (area.get_parent() == self):
		# Ensure unique material instance
		if not sprite_2d.material or sprite_2d.material.resource_local_to_scene == false:
			sprite_2d.material = sprite_2d.material.duplicate()
			sprite_2d.material.resource_local_to_scene = true
		
		# Set flash to 1.0 instantly
		sprite_2d.material.set("shader_param/flash", 0.5)
		
		# Tween back to 0.0
		var tween = create_tween()
		tween.tween_method(
			func(value): sprite_2d.material.set("shader_param/flash", value),
			1.0, 0.0, 0.2
		)
		
		# await get_tree().create_timer(0.1).timeout
		# sprite_2d.material.set("shader_param/flash", 1.0)
	
