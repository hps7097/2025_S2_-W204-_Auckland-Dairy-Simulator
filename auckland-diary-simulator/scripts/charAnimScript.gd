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

func enter_scene() -> void:
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
