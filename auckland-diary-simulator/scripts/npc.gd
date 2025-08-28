extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $"../Path2D/PathFollow2D"
@export var move_speed: float = 50.0
@export var loop_path: bool = true

var last_position: Vector2

func _ready() -> void:
	if path_follow == null:
		push_error("PathFollow2D is null! Check the node path.")
		return 
	path_follow.loop = loop_path
	last_position = path_follow.global_position
	# Start NPC at the first point of the path
	global_position = path_follow.global_position

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	if path_follow == null:
		return
	
	# Move the PathFollow2D along the path
	path_follow.progress += move_speed * delta
	
	# Update sprite position relative to NPC
	global_position = path_follow.global_position
	
	# Calculate movement delta for animation
	var movement := path_follow.global_position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)
		
	last_position = path_follow.global_position
	
	move_and_slide()
	
	# Snapping to grid, no blurry pixel art
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)

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
