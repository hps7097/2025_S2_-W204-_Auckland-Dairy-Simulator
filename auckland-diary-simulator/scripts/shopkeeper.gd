extends Node2D

# If your sprite node has a different name, use the correct path:
@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite2D  # or whatever the name is
# or
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite

func _ready():
	animated_sprite_2d.play("idleBack")

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
