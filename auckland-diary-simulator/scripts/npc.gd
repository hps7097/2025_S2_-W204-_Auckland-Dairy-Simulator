extends CharacterBody2D

# === Movement / Animation ===
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_speed: float = 70.0
@export var stop_time: float = 3.0
@export var stop_tolerance: float = 15.0
@export var loop_path: bool = false

var path_follow: PathFollow2D
var waiting: bool = false
var wait_timer: float = 0.0
var saved_progress: float = 0.0
var last_direction: Vector2 = Vector2.RIGHT
var is_moving: bool = true
var current_target_index: int = 0
var waitingForCounter: bool = false
var waitingForPlayer: bool = false
var pathType: int

# Stop configurations per path
var stop_directions = [
	[Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN],
	[Vector2.UP, Vector2.UP, Vector2.DOWN],
	[Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
]

var target_progress_values = [
	[280.0, 480.0, 725.0],
	[280.0, 420.0, 680.0],
	[400.0, 630.0, 770.0]
]

var stop_direction
var target_progress_value

# === Dialogue Integration ===
@export var npc_id: String = ""        # NPC name or ID
@export var dialogue_id: String = ""   # e.g. "police_1"
@export var show_conditions: Array = [] # optional ["flag:sold_illegal","day:3"]
@export var purchases: Array = []

# === Ready ===
func _ready() -> void:
	print("NPC SPAWNED: ", npc_id)
	find_path_follow()
	if path_follow:
		print("PathFollow2D found at: ", path_follow.get_path())
		path_follow.loop = loop_path
		saved_progress = path_follow.progress
		is_moving = true
	else:
		push_error("No PathFollow2D found in scene!")

# === Movement / Physics ===
func find_path_follow() -> void:
	var possible_path = [
		"../Path2D/PathFollow2D",
		"../Path2D2/PathFollow2D",
		"../Path2D3/PathFollow2D"
	]
	pathType = randi_range(0, 2)
	var path = possible_path[pathType]

	stop_direction = stop_directions[pathType]
	target_progress_value = target_progress_values[pathType]

	path_follow = get_node_or_null(path)

func _physics_process(delta: float) -> void:
	z_index = position.y

	if not path_follow or not is_moving:
		animated_sprite_2d.play(_get_idle_animation())
		return

	if waiting:
		wait_timer -= delta
		last_direction = stop_direction[current_target_index]
		animated_sprite_2d.play(_get_idle_animation())
		if wait_timer <= 0.0:
			if waitingForCounter and not NpcManager.counterFree:
				return
			if waitingForPlayer and GameManager.customerAtDesk:
				return
			if current_target_index == target_progress_values.size() - 1:
				NpcManager.counterFree = true
			if current_target_index == target_progress_values.size() - 2:
				NpcManager.counterFree = false
			waiting = false
			current_target_index += 1
			if current_target_index >= target_progress_values.size():
				if loop_path:
					current_target_index = 0
					path_follow.progress = 0.0
			path_follow.progress = saved_progress
			waitingForCounter = false
		return

	path_follow.progress += move_speed * delta
	saved_progress = path_follow.progress

	var movement = _get_movement_direction()
	_update_animation(movement)

	if current_target_index < target_progress_value.size():
		var target_progress = target_progress_value[current_target_index]
		if abs(path_follow.progress - target_progress) < stop_tolerance:
			print("STOPPING at point ", current_target_index)
			if current_target_index == target_progress_values.size() - 2:
				waitingForCounter = true
			if current_target_index == target_progress_values.size() - 1:
				GameManager.customerAppear(dialogue_id, purchases)
				waitingForPlayer = true
			waiting = true
			wait_timer = stop_time
			last_direction = stop_direction[current_target_index]

	if path_follow.progress_ratio >= 1:
		queue_free()

	global_position = path_follow.global_position.round()

func _get_movement_direction() -> Vector2:
	var current_pos = path_follow.global_position
	path_follow.progress += 5.0
	var next_pos = path_follow.global_position
	path_follow.progress = saved_progress
	return (next_pos - current_pos).normalized()

func _update_animation(movement: Vector2) -> void:
	if movement.length() < 0.1:
		animated_sprite_2d.play(_get_idle_animation())
		return
	if abs(movement.x) > abs(movement.y):
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = movement.x > 0
	elif movement.y > 0:
		animated_sprite_2d.play("walkFront")
	else:
		animated_sprite_2d.play("walkBack")

func _get_idle_animation() -> String:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite_2d.flip_h = last_direction.x > 0
		return "idleSide"
	elif last_direction.y > 0:
		return "idleFront"
	elif last_direction.y < 0:
		return "idleBack"
	return "idleFront"
	
func _input(event):
	if event.is_action("speed_up"):
		wait_timer = 0
	if event.is_action_pressed("speed_up"): # when key is pressed down
		move_speed = 500
	elif event.is_action_released("speed_up"): # when key is released
		move_speed = 70
