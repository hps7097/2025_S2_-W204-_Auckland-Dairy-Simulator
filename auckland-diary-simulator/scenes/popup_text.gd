extends Node2D

var fade = false
var movePos: Vector2
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	z_index = 4096
	scale = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade:
		modulate = lerp(modulate, Color(1, 1, 1, 0), 5 * delta)
	scale = lerp(scale, Vector2(1,1), 5 * delta)
	position = lerp(position, movePos, 0.5 * delta)
	if position.y < movePos.y + 5:
		fade = true;

func calling(msg: String):
	modulate = Color(1, 1, 1, 1)
	scale = Vector2(0,0)
	fade = false;
	position = get_global_mouse_position()
	if position.x < 100:
		position.x = 100
	movePos = position - Vector2(0, 20)
	label.text = msg
