extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

# Reference your marker nodes
@onready var shelf_stop_1: Marker2D = $ShelfStop1
@onready var shelf_stop_2: Marker2D = $ShelfStop2
@onready var counter_stop: Marker2D = $CounterStop

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var loop_path: bool = true

var markers: Array[Marker2D] = []
var marker_progress: Array[float] = []  # Store progress values for each marker
var current_stop_index: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var last_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	if path_follow == null:
		push_error("PathFollow2D not found!")
		return
	
	# Add your markers to the array
	markers.append(shelf_stop_1)
	markers.append(shelf_stop_2)
	markers.append(counter_stop)
	
	# Calculate progress positions for each marker along the path
	_calculate_marker_progress()
	
	print("NPC ready with ", markers.size(), " markers")

func _calculate_marker_progress() -> void:
	if not path_follow.get_parent() is Path2D:
		return
	
	var path: Path2D = path_follow.get_parent()
	var curve: Curve2D = path.curve
	
	if curve == null:
		return
	
	# For each marker, find the closest point on the path curve
	for marker in markers:
		var closest_progress = 0.0
		var closest_distance = INF
		
		# Sample the curve to find closest point to marker
		for i in range(100):
			var test_progress = (i / 99.0) * curve.get_baked_length()
			var point_on_curve = curve.sample_baked(test_progress)
			var world_point = path.global_position + point_on_curve
			var distance = marker.global_position.distance_to(world_point)
			
			if distance < closest_distance:
				closest_distance = distance
				closest_progress = test_progress
		
		marker_progress.append(closest_progress)
		print("Marker progress: ", closest_progress)

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	if path_follow == null or marker_progress.is_empty():
		return
	
	if waiting:
		# Handle waiting at stops
		animated_sprite_2d.play(_get_idle_animation())
		wait_timer -= delta
		if wait_timer <= 0.0:
			waiting = false
		return
	
	# Move along the path
	path_follow.progress += move_speed * delta
	global_position = path_follow.global_position
	
	# Calculate movement direction for animation
	var movement = _get_movement_direction()
	_update_animation(movement)
	
	# Check if we reached the current marker's progress
	if current_stop_index < marker_progress.size():
		var target_progress = marker_progress[current_stop_index]
		
		if path_follow.progress >= target_progress - 5.0 and path_follow.progress <= target_progress + 5.0:
			print("Reached marker ", current_stop_index)
			waiting = true
			wait_timer = stop_time
			current_stop_index += 1
			
			if current_stop_index >= marker_progress.size() and loop_path:
				current_stop_index = 0
				path_follow.progress = 0.0
	
	move_and_slide()

func _get_movement_direction() -> Vector2:
	# Estimate direction based on path tangent
	if path_follow.progress > 1.0:
		var current_pos = path_follow.global_position
		var test_progress = path_follow.progress + 1.0
		path_follow.progress = test_progress
		var next_pos = path_follow.global_position
		path_follow.progress = test_progress - 1.0  # Reset
		return (next_pos - current_pos).normalized()
	return Vector2.RIGHT  # Default direction

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
