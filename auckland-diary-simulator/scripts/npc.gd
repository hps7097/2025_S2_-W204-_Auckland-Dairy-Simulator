extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var stop_tolerance: float = 20.0
@export var loop_path: bool = true
@export var start_moving: bool = true
@export var use_path_follow: bool = true
@export var stop_points: Array[NodePath] = []

var path_follow: PathFollow2D
var markers: Array[Marker2D] = []
var target_positions: Array[Vector2] = []
var current_target_index: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var saved_progress: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT
var is_moving: bool = true

# --- Helper Functions (moved to top) ---

func _get_idle_animation() -> String:
	if abs(last_direction.x) > abs(last_direction.y):
		if animated_sprite_2d:
			animated_sprite_2d.flip_h = last_direction.x > 0
		return "idleSide"
	elif last_direction.y > 0:
		return "idleFront"
	elif last_direction.y < 0:
		return "idleBack"
	return "idleFront"

func _get_movement_direction() -> Vector2:
	if not path_follow:
		return Vector2.RIGHT
	var current_pos = path_follow.global_position
	var test_progress = path_follow.progress + 1.0
	path_follow.progress = test_progress
	var next_pos = path_follow.global_position
	path_follow.progress = saved_progress
	return (next_pos - current_pos).normalized()

func _update_animation(movement: Vector2) -> void:
	if not animated_sprite_2d:
		return
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

func _arrived_at_stop(stop_name: String) -> void:
	print("Arrived at stop: ", stop_name)
	# Add custom behavior per stop here
	match stop_name:
		"ShelfStop1": pass
		"ShelfStop2": pass
		"CounterStop": pass

func _start_waiting(movement: Vector2, target_position: Vector2, stop_name: String) -> void:
	waiting = true
	wait_timer = stop_time
	last_direction = movement
	global_position = target_position
	if path_follow:
		saved_progress = path_follow.progress
	_arrived_at_stop(stop_name)

# --- Main Functions ---

func _ready() -> void:
	# Collect all Marker2D children
	for child in get_children():
		if child is Marker2D:
			markers.append(child)
			print("Found marker: ", child.name)  # Add this to see each marker found

	print("All markers found: ", markers.map(func(m): return m.name))

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
	var possible_paths = ["Path2D/PathFollow2D", "../Path2D/PathFollow2D", "PathFollow2D"]
	for path in possible_paths:
		path_follow = get_node_or_null(path)
		if path_follow:
			print("Found PathFollow2D at: ", path)
			return
	
	var found_node = find_child("PathFollow2D", true, false)
	if found_node and found_node is PathFollow2D:
		path_follow = found_node
		print("Found PathFollow2D recursively")

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	if not is_moving:
		if animated_sprite_2d:
			animated_sprite_2d.play(_get_idle_animation())
		return

	# Handle waiting at stops
	if waiting:
		wait_timer -= delta
		if animated_sprite_2d:
			animated_sprite_2d.play(_get_idle_animation())
		if wait_timer <= 0.0:
			waiting = false
			current_target_index += 1
			if use_path_follow:
				if current_target_index >= markers.size():
					if loop_path:
						current_target_index = 0
					else:
						is_moving = false
						return
				if path_follow:
					path_follow.progress = saved_progress
			else:
				if current_target_index >= target_positions.size():
					if loop_path:
						current_target_index = 0
					else:
						is_moving = false
						return
		return

	if use_path_follow:
		# Path following movement
		if not path_follow:
			return
		
		path_follow.progress += move_speed * delta
		saved_progress = path_follow.progress
		global_position = path_follow.global_position
		
		var movement = _get_movement_direction()
		_update_animation(movement)
		
		# Check if reached current stop
		if markers.size() > 0 and current_target_index < markers.size():
			var target_marker = markers[current_target_index]
			var distance = global_position.distance_to(target_marker.global_position)
			if distance <= stop_tolerance:
				_start_waiting(movement, target_marker.global_position, target_marker.name)
	else:
		# Direct movement mode
		if current_target_index >= target_positions.size():
			return
		
		var target = target_positions[current_target_index]
		var direction = (target - global_position).normalized()
		velocity = direction * move_speed
		
		# Move and handle animation
		move_and_slide()
		_update_animation(direction)
		
		# Check if reached target
		if global_position.distance_to(target) < stop_tolerance:
			_start_waiting(direction, target, "Stop_" + str(current_target_index))

	# Pixel-perfect positioning
	global_position = global_position.round()

# --- Public control methods ---

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
	if use_path_follow:
		for i in range(markers.size()):
			if markers[i].name == stop_name:
				current_target_index = i
				print("Going to stop: ", stop_name)
				return
	else:
		for i in range(target_positions.size()):
			var marker = get_node(stop_points[i])
			if marker and marker.name == stop_name:
				current_target_index = i
				print("Going to stop: ", stop_name)
				return
	print("Stop not found: ", stop_name)

func set_next_stop(stop_name: String) -> bool:
	if use_path_follow:
		for i in range(markers.size()):
			if markers[i].name == stop_name:
				current_target_index = i - 1
				if waiting:
					wait_timer = 0.1
				return true
	else:
		for i in range(target_positions.size()):
			var marker = get_node(stop_points[i])
			if marker and marker.name == stop_name:
				current_target_index = i - 1
				if waiting:
					wait_timer = 0.1
				return true
	print("Stop not found: ", stop_name)
	return false
