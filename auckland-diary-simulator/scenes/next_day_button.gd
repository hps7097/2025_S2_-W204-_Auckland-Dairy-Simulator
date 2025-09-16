extends Button

var state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	state = true

func _on_button_up() -> void:
	if state:
		get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
		ProductManager.spawnNew()
		
