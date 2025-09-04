extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

# Reference your counter stops
@onready var shelf_stop_1: Marker2D = $ShelfStop1
@onready var shelf_stop_2: Marker2D = $ShelfStop2
@onready var counter_stop: Marker2D = $CounterStop

@export var move_speed: float = 50.0
@export var loop_path: bool = true
@export var stop_time: float = 2.0 # seconds to wait at each stop

var current_stop_index: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var last_position: Vector2
var last_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	if path_follow == null:
		push_error("PathFollow2D is null! Check the node path.")
		return 
	path_follow.loop = loop_path
	last_position = path_follow.global_position
	global_position = path_follow.global_position

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	if path_follow == null:
		return
	
	# Handle waiting at stop points
	if waiting:
		wait_timer -= delta
		# Use the correct idle animation based on which stop we're at
		if current_stop_index == 2:  # Counter stop (third position)
			animated_sprite_2d.play("idleFront")
		else:
			animated_sprite_2d.play(_get_idle_animation())
		
		if wait_timer <= 0.0:
			waiting = false
			current_stop_index += 1
			if current_stop_index >= 3:  # We have 3 stops
				if loop_path:
					current_stop_index = 0
		else:
			return
	
	# Move along the path
	path_follow.progress += move_speed * delta
	
	# UPDATE GLOBAL POSITION FIRST, THEN ROUND IT
	global_position = path_follow.global_position
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)
	
	# Calculate movement delta for animation
	var movement := global_position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)
		last_direction = movement.normalized()
	last_position = global_position
	
	# Check if we reached the next stop point based on marker positions
	if not waiting:
		var target_position: Vector2
		match current_stop_index:
			0: target_position = shelf_stop_1.global_position
			1: target_position = shelf_stop_2.global_position
			2: target_position = counter_stop.global_position
		
		var distance = global_position.distance_to(target_position)
		if distance < 25.0:  # Close enough to the stop
			waiting = true
			wait_timer = stop_time
			# Special handling for counter stop
			if current_stop_index == 2:
				last_direction = Vector2.DOWN
	
	move_and_slide()

# Animation handling
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
