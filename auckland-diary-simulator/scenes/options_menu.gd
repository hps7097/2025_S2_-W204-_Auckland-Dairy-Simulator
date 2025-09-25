extends Control

@onready var volume_slider: HSlider = $VBox/VolumeSlider
@onready var dialogue_speed_slider: HSlider = $VBox/DialogueSpeedSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_speed_slider.value = 1 - global.dialogSpeed
	volume_slider.value = global.volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	queue_free()

func _on_dialogue_speed_slider_drag_ended(value_changed: bool) -> void:
	global.dialogSpeed = 1 - dialogue_speed_slider.value

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	global.volume = volume_slider.value
