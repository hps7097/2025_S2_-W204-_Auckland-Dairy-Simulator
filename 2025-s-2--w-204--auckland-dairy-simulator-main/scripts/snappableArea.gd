extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(Color.WHITE, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MouseManager.is_dragging and !MouseManager.selectScanner:
		visible = true
		if MouseManager.current_dragged.get_parent().scanned:
			modulate = Color(Color.PALE_GREEN, 0.5)
		else:
			modulate = Color(Color.INDIAN_RED, 0.5)
	else:
		visible = false
