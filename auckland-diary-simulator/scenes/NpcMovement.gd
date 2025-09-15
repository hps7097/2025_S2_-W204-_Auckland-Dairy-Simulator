extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var loop_path: bool = true
@export var start_moving: bool = true  # Allow starting in a paused state
@export var stop_tolerance: float = 20.0  # Make this configurable

var path_follow: PathFollow2D
var waiting: bool = false
var wait_timer: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT
var current_stop_index: int = 0
var markers: Array[Marker2D] = []
var saved_progress: float = 0.0  # where we paused on the path
var is_moving: bool = true

func _ready() -> void:
	# Collect all Marker2D children
	for child in get_children():
		if child is Marker2D:
			markers.append(child)

	# Sort by name (ShelfStop1 → ShelfStop2 → CounterStop)
	markers.sort_custom(func(a, b): return a.name.naturalcasecmp_to(b.name) < 0)

	print("Markers found (sorted): ", markers.map(func(m): return m.name))

	# Find PathFollow2D
	find_path_follow()
	
	if path_follow:
		print("PathFollow2D found")
		path_follow.loop = loop_path
		saved_progress = path_follow.progress
		
		# Start in the correct state
		is_moving = start_moving
		if !start_moving:
			waiting = true
			wait_timer = 0.0

func find_path_follow() -> void:
	var possible_paths = [
		"Path2D/PathFollow2D",
		"../Path2D/PathFollow2D", 
		"PathFollow2D"
	]
	
	for path in possible_paths:
		path_follow = get_node_or_null(path)
		if path_follow:
			print("Found PathFollow2D at: ", path)
			return
	
	# If we still haven't found it, search recursively
	var found_node = find_child("PathFollow2D", true, false)
	if found_node and found_node is PathFollow2D:
		path_follow = found_node
		print("Found PathFollow2D recursively")

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	if not path_follow:
		return

	# Handle waiting
	if waiting:
		wait_timer -= delta
		animated_sprite_2d.play(_get_idle_animation())
		if wait_timer <= 0.0:
			waiting = false
			current_stop_index += 1
			if current_stop_index >= markers.size():
				if loop_path:
					current_stop_index = 0
				else:
					# If not looping, stay at the last position
					is_moving = false
					return
			# resume from saved progress
			path_follow.progress = saved_progress
		return
	
	if !is_moving:
		animated_sprite_2d.play(_get_idle_animation())
		return
	
	# Move along path
	path_follow.progress += move_speed * delta
	saved_progress = path_follow.progress
	global_position = path_follow.global_position
	
	# Animation
	var movement = _get_movement_direction()
	_update_animation(movement)
	
	# Check if reached current stop
	if not markers.is_empty() and current_stop_index < markers.size():
		var target_marker = markers[current_stop_index]
		var distance = global_position.distance_to(target_marker.global_position)
		if distance < stop_tolerance:
			waiting = true
			wait_timer = stop_time
			last_direction = movement
			# Snap exactly to stop
			global_position = target_marker.global_position
			# Emit signal or call method when arriving at a stop
			_arrived_at_stop(target_marker.name)

	# Pixel-perfect positioning
	global_position = global_position.round()

func _get_movement_direction() -> Vector2:
	if path_follow:
		var current_pos = path_follow.global_position
		var test_progress = path_follow.progress + 1.0
		path_follow.progress = test_progress
		var next_pos = path_follow.global_position
		path_follow.progress = saved_progress
		return (next_pos - current_pos).normalized()
	return Vector2.RIGHT

func _update_animation(movement: Vector2) -> void:
	if movement.length() < 0.1:
		animated_sprite_2d.play(_get_idle_animation())
		return
		
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

func _arrived_at_stop(stop_name: String) -> void:
	print("Arrived at stop: ", stop_name)
	# You can add custom behavior for different stops here
	match stop_name:
		"ShelfStop1":
			# Do something specific for ShelfStop1
			pass
		"CounterStop":
			# Do something specific for CounterStop
			pass

# Public methods to control the NPC
func start_movement() -> void:
	is_moving = true
	waiting = false

func stop_movement() -> void:
	is_moving = false

func pause_movement(time: float = 0.0) -> void:
	if time > 0:
		waiting = true
		wait_timer = time
	else:
		is_moving = false

func go_to_stop(stop_name: String) -> void:
	for i in range(markers.size()):
		if markers[i].name == stop_name:
			current_stop_index = i
			# Calculate the progress needed to reach this marker
			# This would need additional logic based on your path setup
			print("Going to stop: ", stop_name)
			return
	print("Stop not found: ", stop_name)

func set_next_stop(stop_name: String) -> bool:
	for i in range(markers.size()):
		if markers[i].name == stop_name:
			current_stop_index = i - 1  # Will be incremented in the waiting logic
			if waiting:
				wait_timer = 0.1  # Short wait to trigger next stop
			return true
	print("Stop not found: ", stop_name)
	return false
