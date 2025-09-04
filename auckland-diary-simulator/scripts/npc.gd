extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var loop_path: bool = true

var path_follow: PathFollow2D
var waiting: bool = false
var wait_timer: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	# Try to find PathFollow2D in different possible locations
	find_path_follow()
	
	if path_follow:
		print("PathFollow2D found: ", path_follow.get_path())
		path_follow.loop = loop_path
	else:
		print("PathFollow2D not found. Using simple movement.")
		push_warning("Path system not found - NPC will move right instead")

func find_path_follow() -> void:
	# Try different possible locations for PathFollow2D
	var possible_paths = [
		"Path2D/PathFollow2D",           # Direct child
		"../Path2D/PathFollow2D",        # Sibling
		"../../Path2D/PathFollow2D",     # Parent's sibling
		"PathFollow2D",                  # Direct child with different name
		"Path/PathFollow2D"              # Alternative naming
	]
	
	for path in possible_paths:
		path_follow = get_node_or_null(path)
		if path_follow:
			print("Found PathFollow2D at: ", path)
			return
	
	# If not found, search recursively in the scene tree
	path_follow = find_node_recursive(get_parent(), "PathFollow2D")
	if path_follow:
		print("Found PathFollow2D recursively")

func find_node_recursive(node: Node, node_name: String) -> Node:
	if node == null:
		return null
	
	if node.name == node_name:
		return node
	
	for child in node.get_children():
		var found = find_node_recursive(child, node_name)
		if found:
			return found
	
	return null

func _physics_process(delta: float) -> void:
	# PROPER Z-INDEX: Use Y-based sorting for correct depth
	# Add a small offset if needed to adjust sorting
	z_index = int(global_position.y) + 10  # +10 to keep NPC slightly in front
	
	if path_follow:
		# Handle waiting
		if waiting:
			wait_timer -= delta
			animated_sprite_2d.play(_get_idle_animation())
			if wait_timer <= 0.0:
				waiting = false
			return
		
		# Move along the path
		path_follow.progress += move_speed * delta
		global_position = path_follow.global_position
		
		# Calculate movement direction for animation
		var movement = _get_movement_direction()
		_update_animation(movement)
		
		# REMOVED THE AUTOMATIC STOP - Let the path control movement
		# The stopping was happening because of this condition:
		# if path_follow.progress_ratio > 0.3 and path_follow.progress_ratio < 0.32:
		
	else:
		# Fallback: simple movement to the right
		velocity.x = move_speed
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = false
		move_and_slide()
	
	# Pixel-perfect positioning
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)

func _get_movement_direction() -> Vector2:
	# Estimate direction based on path tangent
	if path_follow.progress > 1.0:
		var current_pos = path_follow.global_position
		var test_progress = path_follow.progress + 1.0
		path_follow.progress = test_progress
		var next_pos = path_follow.global_position
		path_follow.progress = test_progress - 1.0
		return (next_pos - current_pos).normalized()
	return Vector2.RIGHT

func _update_animation(movement: Vector2) -> void:
	if abs(movement.x) > abs(movement.y):
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = movement.x > 0
	elif movement.y > 0:
		animated_sprite_2d.play("walkFront")
	elif movement.y < 0:
		animated_sprite_2d.play("walkBack")

func _get_idle_animation() -> String:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite_2d.flip_h = last_direction.x > 0
		return "idleSide"
	elif last_direction.y > 0:
		return "idleFront"
	elif last_direction.y < 0:
		return "idleBack"
	return "idleFront"
