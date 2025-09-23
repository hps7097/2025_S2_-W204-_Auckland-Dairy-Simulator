extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coin_sprite: HBoxContainer = $"../MoneyCounter"
@onready var shop_button_1: Button = $"../HBoxContainer/ShopButton1"
@onready var shop_button_2: Button = $"../HBoxContainer/ShopButton2"
@onready var shop_button_3: Button = $"../HBoxContainer/ShopButton3"

var init_pos: Vector2
var target_pos: Vector2
var move = false

var type: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	z_index = 4096
	scale = Vector2(0,0)
	sprite_2d.region_rect = Rect2(randi_range(0, 1) * 48, 0, 48, 48)
	
	if type == 0:
		position = Vector2(randi_range(17, 105), randi_range(757, 947))
		target_pos = coin_sprite.position
		init_pos = position + Vector2(0, -50)
	elif type >= 1 && type <= 3:
		position = coin_sprite.position + Vector2(25 + randi_range(-5, 5), 50 + randi_range(-5, 5))
		if type == 1:
			target_pos = shop_button_1.global_position + Vector2(281, 360)
		elif type == 2:
			target_pos = shop_button_2.global_position + Vector2(281, 360)
		elif type == 3:
			target_pos = shop_button_3.global_position + Vector2(281, 360)
		init_pos = position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		scale = lerp(scale, Vector2(0, 0), 0.8 * delta)
		position = lerp(position, target_pos + Vector2(24, 24), 4 * delta)
		if position.distance_to(target_pos) < 30.0:
			queue_free()
	else:
		position = lerp(position, init_pos, 5 * delta)
		scale = lerp(scale, Vector2(1, 1), 4 * delta)
		if scale > Vector2(0.95, 0.95):
			move = true
