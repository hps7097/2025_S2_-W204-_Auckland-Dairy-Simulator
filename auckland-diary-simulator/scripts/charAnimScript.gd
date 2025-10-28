extends Sprite2D

@export var move_speed: float = 200.0

# Counter position (lowered so chest + head are visible above counter)
@export var entry_position: Vector2 = Vector2(40, -50)

@export var leave_position: Vector2 = Vector2(280, -50)

# Starting position (offscreen left, same Y for smooth slide-in)
@export var start_position: Vector2 = Vector2(-200, -50)

var move_tween: Tween
var fade_tween: Tween

func _ready() -> void:
	position = start_position
	modulate.a = 0.0

func enter_scene(dialogue_id: String) -> void:
	var file_path
	match dialogue_id:
		"regular_customer1":
			file_path = "res://assets/_NPC_Character6.png"
		"regular_customer2":
			file_path = "res://assets/_NPC_Character5.png"
		"regular_customer3":
			file_path = "res://assets/_NPC_Character4.png"
		"regular_customer31":
			file_path = "res://assets/_NPC_Character4.png"
		"gang_kid":
			file_path = "res://assets/_NPC_Character3.png"
		"gang_kid1":
			file_path = "res://assets/_NPC_Character3.png"
		"police":
			file_path = "res://assets/_NPC_Character1.png"
		"police_1":
			file_path = "res://assets/_NPC_Character1.png"
		"police_2":
			file_path = "res://assets/_NPC_Character1.png"
		"gang_boss":
			file_path = "res://assets/_NPC_Character2.png"
		"gang_boss2":
			file_path = "res://assets/_NPC_Character2.png"
		"regular_customer4":
			file_path = "res://assets/_NPC_Character7.png"
		"regular_customer5":
			file_path = "res://assets/_NPC_Character8.png"
		
		
	var new_texture = load(file_path)
	if new_texture:
		texture = new_texture
	else:
		push_warning("Texture not found: " + file_path)
	position = start_position
	modulate.a = 0.0
	fade_in(1.0)
	move_to(entry_position)
	
func leave_scene() -> void:
	fade_out(1.0)
	move_to(leave_position)

func move_to(pos: Vector2) -> void:
	if move_tween and move_tween.is_running():
		move_tween.kill()

	move_tween = create_tween()
	var duration = position.distance_to(pos) / move_speed

	move_tween.tween_property(self, "position", pos, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

func fade_in(duration: float = 1.0) -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, duration)

func fade_out(duration: float = 1.0) -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, duration)
