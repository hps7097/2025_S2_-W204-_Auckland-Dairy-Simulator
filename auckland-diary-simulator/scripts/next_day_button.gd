extends Button

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "START DAY " + str(GameManager.dayCount + 1)

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	GameManager.newDay()
