extends Node2D

const MOVESPEED = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += -MOVESPEED * delta
	position.y += -MOVESPEED * delta
	if position.x < -2160:
		position.x += 4320
	if position.y < -1200:
		position.y += 2400
