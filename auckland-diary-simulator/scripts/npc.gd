extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

@export var move_speed: float = 50.0
@export var stop_time: float = 2.0
@export var loop_path: bool = true
@export var stop_positions: Array[NodePath] = []  # Assign your Stop nodes in the inspector

var markers: Array[Marker2D] = []
var current_stop_index: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var last_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	# Load markers from the exported NodePath array
	for path in stop_positions:
		var marker = get_node_or_null(path)
		if marker is Marker2D:
			markers.append(marker)
			print("Loaded marker at: ", marker.global_position)
		else:
			push_warning("Invalid marker at path: ", path)
	
	if markers.is_empty():
		push_error("No valid markers found! Assign markers in the inspector.")
		return
	
	print("NPC ready with ", markers.size(), " markers")

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	if markers.is_empty() or not path_follow:
		animated_sprite_2d.play(_get_idle_animation())
		return
	
	if waiting:
		# Handle waiting at stops
		animated_sprite_2d.play(_get_idle_animation())
		wait_timer -= delta
		if wait_timer <= 0.0:
			waiting = false
			current_stop_index += 1
			if current_stop_index >= markers.size():
				if loop_path:
					current_stop_index = 0
				else:
					# Stop moving
					return
		return
	
	# Move along the path continuously
	path_follow.progress += move_speed * delta
	global_position = path_follow.global_position
	
	# Check if we're close to the current target marker
	var current_marker = markers[current_stop_index]
	var distance = global_position.distance_to(current_marker.global_position)
	
	if distance < 20.0:  # Close to current target marker
		print("Reached marker ", current_stop_index)
		waiting = true
		wait_timer = stop_time
		
		# Special handling for counter (you can check by name or index)
		if current_marker.name == "CounterStop" or current_stop_index == markers.size() - 1:
			last_direction = Vector2.DOWN
			animated_sprite_2d.play("idleFront")
	
	# Play walking animation
	animated_sprite_2d.play("walkSide")
	animated_sprite_2d.flip_h = false

func _get_idle_animation() -> String:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite_2d.flip_h = last_direction.x > 0
		return "idleSide"
	elif last_direction.y > 0:
		return "idleFront"
	elif last_direction.y < 0:
		return "idleBack"
	return "idleFront"
