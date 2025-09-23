extends Node2D

@export var move_speed: float = 200.0

# Position at the counter (lowered on Y so character is closer to counter edge)
@export var entry_position: Vector2 = Vector2(400, 480)

# Starting position (offscreen left, same Y for straight horizontal entry)
@export var start_position: Vector2 = Vector2(-200, 480)

var move_tween: Tween
var fade_tween: Tween

func _ready() -> void:
	# Start offscreen and invisible
	position = start_position
	modulate.a = 0.0
	
	# Automatically run entry sequence
	enter_scene()

# === Entry sequence ===
func enter_scene() -> void:
	fade_in(1.0)
	move_to(entry_position)

# === Movement ===
func move_to(pos: Vector2) -> void:
	if move_tween and move_tween.is_running():
		move_tween.kill()

	move_tween = create_tween()
	var duration = position.distance_to(pos) / move_speed

	move_tween.tween_property(self, "position", pos, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

# === Fading ===
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
