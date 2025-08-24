extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50.0
var lastDirection = 0 #0 = up, 1 = right, 2 = down, 3 = left

func _physics_process(delta: float) -> void:
	z_index = int(global_position.y)
	
	var xdirection := Input.get_axis("ui_left", "ui_right")
	var ydirection := Input.get_axis("ui_up", "ui_down")
	
	if xdirection:
		velocity.x = xdirection * SPEED
		if xdirection == 1:
			lastDirection = 1;
		else:
			lastDirection = 3;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	if ydirection:
		velocity.y = ydirection * SPEED
		if ydirection == 1:
			lastDirection = 2;
		else:
			lastDirection = 0;
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if xdirection:
		animated_sprite_2d.play("walkSide")
		if xdirection == 1:
			animated_sprite_2d.flip_h = true;
		else:
			animated_sprite_2d.flip_h = false
	elif ydirection == 1:
		animated_sprite_2d.play("walkFront")
	elif ydirection == -1:
		animated_sprite_2d.play("walkBack")
	else:
		if lastDirection == 0:
			animated_sprite_2d.play("idleBack")
		elif lastDirection == 2:
			animated_sprite_2d.play("idleFront")
		elif lastDirection == 3:
			animated_sprite_2d.play("idleSide")
			animated_sprite_2d.flip_h = false;
		else:
			animated_sprite_2d.play("idleSide")
			animated_sprite_2d.flip_h = true;

	move_and_slide()

	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)
