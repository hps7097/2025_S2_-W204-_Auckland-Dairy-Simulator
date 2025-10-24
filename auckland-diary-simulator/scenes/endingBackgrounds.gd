extends Node2D

var moving := false
var start_pos: Vector2
var target_pos: Vector2
var multiplier: float = 1

func moveAnimation():
	start_pos = position
	target_pos = position - Vector2(0, 1080)
	moving = true

func _process(delta):
	if moving:
		position.y -= 8 * delta * multiplier
		if position.y > ((start_pos.y + target_pos.y) / 2):
			multiplier *= 1.01;
		else:
			multiplier /= 1.01;
		
		if position.y <= target_pos.y:
			position.y = target_pos.y
			moving = false
