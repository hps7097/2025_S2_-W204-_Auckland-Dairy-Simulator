extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $".."

@export var move_speed: float = 50.0
@export var loop_path: bool = true
@export var stop_markers: Array[NodePath] = [] # assign Marker2Ds in the Inspector
@export var stop_time: float = 2.0 # seconds to wait at each stop

var current_stop_index: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var last_position: Vector2

func _ready() -> void:
	if path_follow == null:
		push_error("PathFollow2D is null! Check the node path.")
		return
	
	path_follow.loop = loop_path
	last_position = global_position

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)

	# Handle waiting at stop points
	if waiting:
		animated_sprite_2d.play("idleFront") # idle while waiting
		wait_timer -= delta
		if wait_timer <= 0.0:
			waiting = false
		else:
			return

	# Move along the path (this moves the parent PathFollow2D)
	path_follow.progress += move_speed * delta

	# Calculate movement delta for animation
	var movement := global_position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)
	last_position = global_position

	# Check if we reached the next stop marker
	if current_stop_index < stop_markers.size():
		var marker = get_node(stop_markers[current_stop_index]) as Marker2D
		if global_position.distance_to(marker.global_position) < 5.0: # close enough
			waiting = true
			wait_timer = stop_time
			current_stop_index += 1

	# Loop stops if needed
	if current_stop_index >= stop_markers.size() and loop_path:
		current_stop_index = 0
		path_follow.progress = 0.0 # restart path

# Animation handling
func _update_animation(movement: Vector2) -> void:
	if abs(movement.x) > abs(movement.y):
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = movement.x > 0
	elif movement.y > 0:
		animated_sprite_2d.play("walkFront")
	elif movement.y < 0:
		animated_sprite_2d.play("walkBack")
	else:
		animated_sprite_2d.play("idleBack")
