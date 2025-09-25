extends Node

const PAUSE_MENU = preload("res://scenes/PauseMenu.tscn")
var pauseMenu

var dialogSpeed = 0.05
var volume = 1

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Allows windowing / fullscreening toggleablilty
func _input(event):
	if event.is_action_pressed("fullscreen"): # bind F11 in Input Map
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			set_windowed()
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if event.is_action_pressed("ui_pause"):
		if get_tree().current_scene.has_node("PauseMenu"):
			pauseMenu.queue_free()
		elif get_tree().current_scene.name == "main" || get_tree().current_scene.name == "nightScreen":
			pauseMenu = PAUSE_MENU.instantiate()
			pauseMenu.z_index = 4096 
			get_tree().current_scene.add_child(pauseMenu)
		

# Makes window small and centered
func set_windowed() -> void:
	var screen_size = DisplayServer.screen_get_size()
	var ratio: float = 16.0 / 9.0
	
	var target_height = screen_size.y - 100
	var target_width = int(target_height * ratio)
	var safe_size = Vector2i(target_width, target_height)


	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(safe_size)
	# Center safely
	var pos = (screen_size - safe_size) / 2
	# Clamp so it never goes off-screen
	pos.x = max(pos.x, 0)
	pos.y = max(pos.y, 0)
	DisplayServer.window_set_position(pos)
