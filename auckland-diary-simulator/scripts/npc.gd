extends CharacterBody2D

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
# Removed target_positions: Array[Vector2] = [Vector2(-154.74, 49.0), Vector2(-284.0, 83.0), Vector2(-133.0, 105.0)]
var stop_directions = [\
[Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN],\
[Vector2.UP, Vector2.UP, Vector2.DOWN],\
[Vector2.RIGHT, Vector2.UP, Vector2.DOWN]]

var target_progress_values = [\
[280.0, 480.0, 725.0],
[280.0, 420.0, 680.0],
[400.0, 630.0, 770.0]]

var stop_direction
var target_progress_value

var current_target_index: int = 0

var waitingForCounter: bool = false
var pathType: int

# Preload the NPC scene
const NPC_SCENE = preload("res://scenes/npc.tscn")  # Confirm this path

func _ready() -> void:
	print("NPC SPAWNED")
	find_path_follow()
	if path_follow:
		print("PathFollow2D found at: ", path_follow.get_path())
		path_follow.loop = loop_path
		saved_progress = path_follow.progress
		is_moving = true
	else:
		print("WARNING: PathFollow2D not found! Searching from /root/dayscreen/shopOverviewMain/Path2D/PathFollow2D...")
		path_follow = get_node_or_null("/root/dayscreen/shopOverviewMain/Path2D/PathFollow2D")
		if path_follow:
			print("Found PathFollow2D at: /root/dayscreen/shopOverviewMain/Path2D/PathFollow2D")
			path_follow.loop = loop_path
			saved_progress = path_follow.progress
			is_moving = true
		else:
			push_error("No PathFollow2D found in dayscreen hierarchy!")

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
	if path_follow:
		print("Found PathFollow2D at: ", path)
		return

func _physics_process(delta: float) -> void:
	z_index = position.y
	
	if not path_follow or not is_moving:
		if animated_sprite_2d:
			animated_sprite_2d.play(_get_idle_animation())
		return

	if waiting:
		wait_timer -= delta
		if animated_sprite_2d:
			last_direction = stop_direction[current_target_index]
			animated_sprite_2d.play(_get_idle_animation())
		if wait_timer <= 0.0:
			if waitingForCounter:
				if NpcManager.counterFree == false:
					return
				else:
					NpcManager.counterFree = false
			if current_target_index == target_progress_values.size() - 1:
				NpcManager.counterFree = true
			waiting = false
			current_target_index += 1
			if current_target_index >= target_progress_values.size():
				if loop_path:
					current_target_index = 0
					path_follow.progress = 0.0  # Reset to start
			path_follow.progress = saved_progress
			waitingForCounter = false
		return

	path_follow.progress += move_speed * delta
	saved_progress = path_follow.progress
	
	var movement = _get_movement_direction()
	_update_animation(movement)

	if current_target_index <= target_progress_values.size():
		var target_progress = 99999
		if current_target_index < 3:
			target_progress = target_progress_value[current_target_index]
		var current_progress = path_follow.progress
		
		if abs(current_progress - target_progress) < stop_tolerance:
			print("STOPPING at position ", current_target_index, " for 3 seconds")
			if current_target_index == target_progress_values.size() - 2:
				waitingForCounter = true;
			waiting = true
			wait_timer = stop_time
			last_direction = stop_direction[current_target_index]
			
	if path_follow.progress_ratio >= 1:
		queue_free()
	global_position = path_follow.global_position.round()

func _get_movement_direction() -> Vector2:
	if not path_follow:
		return Vector2.RIGHT
	var current_pos = path_follow.global_position
	var test_progress = path_follow.progress + 5.0
	path_follow.progress = test_progress
	var next_pos = path_follow.global_position
	path_follow.progress = saved_progress
	return (next_pos - current_pos).normalized()

func _update_animation(movement: Vector2) -> void:
	if not animated_sprite_2d:
		return
	if movement.length() < 0.1:
		animated_sprite_2d.play(_get_idle_animation())
		return
	if abs(movement.x) > abs(movement.y):
		animated_sprite_2d.play("walkSide")
		animated_sprite_2d.flip_h = movement.x > 0
	elif movement.y > 0:
		animated_sprite_2d.play("walkFront")
	elif movement.y < 0:
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
