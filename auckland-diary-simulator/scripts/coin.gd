extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coin_sprite: HBoxContainer = $"../MoneyCounter"

var init_pos: Vector2
var move = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	z_index = 4096
	scale = Vector2(0,0)
	position = Vector2(randi_range(17, 105), randi_range(757, 947))
	init_pos = position + Vector2(0, -50)
	sprite_2d.region_rect = Rect2(randi_range(0, 1) * 48, 0, 48, 48)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		scale = lerp(scale, Vector2(0, 0), 0.8 * delta)
		position = lerp(position, coin_sprite.position + Vector2(24, 24), 4 * delta)
		if position == init_pos:
			queue_free()
	else:
		position = lerp(position, init_pos, 5 * delta)
		scale = lerp(scale, Vector2(1, 1), 4 * delta)
		if scale > Vector2(0.95, 0.95):
			move = true
		
