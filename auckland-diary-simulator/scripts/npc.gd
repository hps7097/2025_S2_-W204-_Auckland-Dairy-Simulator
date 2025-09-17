extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var stop_time: float = 3.0
@export var stop_tolerance: float = 15.0
@export var loop_path: bool = true

var path_follow: PathFollow2D
var waiting: bool = false
var wait_timer: float = 0.0
var saved_progress: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT
var is_moving: bool = true

# Your exact stop positions
var target_positions: Array[Vector2] = [
	Vector2(-154.74, 49.0),    # ShelfStop1
	Vector2(-284.0, 83.0),     # ShelfStop2
	Vector2(-133.0, 105.0)     # CounterStop
]

# Specific directions for each stop position
var stop_directions: Array[Vector2] = [
	Vector2.RIGHT,    # ShelfStop1 - face right
	Vector2.LEFT,     # ShelfStop2 - face left  
	Vector2.DOWN       # CounterStop - face up (toward counter)
]

var current_target_index: int = 0
var target_progress_values: Array[float] = [280.0, 480.0, 720.0]

func _ready() -> void:
	# Find PathFollow2D
	find_path_follow()
	
	if path_follow:
		print("PathFollow2D found")
		path_follow.loop = loop_path
		saved_progress = path_follow.progress
		is_moving = true

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

func _physics_process(delta: float) -> void:
	if not path_follow or not is_moving:
		if animated_sprite_2d:
			animated_sprite_2d.play(_get_idle_animation())
		return

	# Handle waiting at stops
	if waiting:
		wait_timer -= delta
		if animated_sprite_2d:
			# Use the specific stop direction for this position
			var stop_direction = stop_directions[current_target_index]
			last_direction = stop_direction
			animated_sprite_2d.play(_get_idle_animation())
		if wait_timer <= 0.0:
			waiting = false
			current_target_index += 1
			if current_target_index >= target_progress_values.size():
				if loop_path:
					current_target_index = 0
				else:
					is_moving = false
					return
			path_follow.progress = saved_progress
		return

	# Move along path
	path_follow.progress += move_speed * delta
	saved_progress = path_follow.progress
	
	# Animation
	var movement = _get_movement_direction()
	_update_animation(movement)
	
	# Check if reached current stop progress
	if current_target_index < target_progress_values.size():
		var target_progress = target_progress_values[current_target_index]
		var current_progress = path_follow.progress
		
		if abs(current_progress - target_progress) < stop_tolerance:
			print("STOPPING at position ", current_target_index, " for 3 seconds")
			waiting = true
			wait_timer = stop_time
			# Set the specific direction for this stop
			last_direction = stop_directions[current_target_index]
			saved_progress = target_progress

	global_position = path_follow.global_position.round()

func _get_movement_direction() -> Vector2:
	if not path_follow:
		return Vector2.RIGHT
	var current_pos = path_follow.global_position
	var test_progress = path_follow.progress + 5.0
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

func _get_idle_animation() -> String:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite_2d.flip_h = last_direction.x > 0
		return "idleSide"
	elif last_direction.y > 0:
		return "idleFront"
	elif last_direction.y < 0:
		return "idleBack"
	return "idleFront"
