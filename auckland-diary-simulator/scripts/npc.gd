extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var loop_path: bool = true

# Manually assign your markers in the Inspector
@export var shelf_stop_1: NodePath
@export var shelf_stop_2: NodePath
@export var counter_stop: NodePath

var path_follow: PathFollow2D
var waiting: bool = false
var wait_timer: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT
var current_stop_index: int = 0
var markers: Array[Marker2D] = []

func _ready() -> void:
	# Load markers from exported NodePaths
	if shelf_stop_1:
		var marker = get_node_or_null(shelf_stop_1)
		if marker and marker is Marker2D:
			markers.append(marker)
	if shelf_stop_2:
		var marker = get_node_or_null(shelf_stop_2)
		if marker and marker is Marker2D:
			markers.append(marker)
	if counter_stop:
		var marker = get_node_or_null(counter_stop)
		if marker and marker is Marker2D:
			markers.append(marker)
	
	print("Markers found: ", markers.size())
	
	# Find PathFollow2D
	find_path_follow()
	
	if path_follow:
		print("PathFollow2D found")
		path_follow.loop = loop_path

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
	z_index = int(global_position.y)
	
	if path_follow:
		if waiting:
			wait_timer -= delta
			animated_sprite_2d.play(_get_idle_animation())
			if wait_timer <= 0.0:
				waiting = false
				current_stop_index += 1
				if current_stop_index >= markers.size():
					if loop_path:
						current_stop_index = 0
			return
		
		# Move along path
		path_follow.progress += move_speed * delta
		global_position = path_follow.global_position
		
		# Animation
		var movement = _get_movement_direction()
		_update_animation(movement)
		
		# Check stops if markers exist
		if not markers.is_empty() and current_stop_index < markers.size():
			var target_marker = markers[current_stop_index]
			var distance = global_position.distance_to(target_marker.global_position)
			if distance < 25.0:
				waiting = true
				wait_timer = stop_time
				if current_stop_index == markers.size() - 1:
					last_direction = Vector2.DOWN
	
	# Pixel-perfect
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)

func _get_movement_direction() -> Vector2:
	if path_follow and path_follow.progress > 1.0:
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
