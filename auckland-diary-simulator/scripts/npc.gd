extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@export var move_speed: float = 20.0
@export var loop_path: bool = true

var last_position: Vector2
var lastDirection = 2  # 0=up, 1=right, 2=down, 3=left

func _ready() -> void:
	if path_follow == null:
		push_error("PathFollow2D is null! Check the node path.")
		return
	path_follow.loop = loop_path
	last_position = path_follow.position
	# Start NPC at the first point of the path
	animated_sprite_2d.position = path_follow.position

func _physics_process(delta: float) -> void:
	if path_follow == null:
		return
	
	# Move the PathFollow2D along the path
	path_follow.progress += move_speed * delta
	
	# Update sprite position relative to NPC
	animated_sprite_2d.position = path_follow.position
	
	# Calculate movement delta for animation
	var movement := path_follow.position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)
		
	last_position = path_follow.position

# Animation handling
func _update_animation(movement: Vector2) -> void:
	if abs(movement.x) > abs(movement.y):
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = movement.x < 0
	elif movement.y > 0:
		animated_sprite_2d.play("walkFront")
	elif movement.y < 0:
		animated_sprite_2d.play("walkBack")
