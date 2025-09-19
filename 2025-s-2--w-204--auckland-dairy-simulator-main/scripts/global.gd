extends Node

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Allows windowing / fullscreening toggleablilty
func _input(event):
	if event.is_action_pressed("fullscreen"): # bind F11 in Input Map
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			set_windowed()
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

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
