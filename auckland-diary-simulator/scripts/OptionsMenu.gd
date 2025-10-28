# MADE WITH CHATGPT

extends Control

@onready var volume_slider = $VBox/VolumeSlider
@onready var dialogue_speed_slider = $VBox/DialogueSpeedSlider
@onready var back_button = $VBox/BackButton

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	dialogue_speed_slider.value = GameState.options.get("dialogue_speed", 1.0)

	volume_slider.connect("value_changed", Callable(self, "_on_volume_changed"))
	dialogue_speed_slider.connect("value_changed", Callable(self, "_on_dialogue_speed_changed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

func _on_volume_changed(val):
	AudioServer.set_bus_volume_db(0, linear_to_db(val))
	GameState.options["volume"] = val

func _on_dialogue_speed_changed(val):
	GameState.options["dialogue_speed"] = val

func _on_back_pressed():
	self.visible = false
	get_node("/root/Main/MainMenu").visible = true
	SaveSystem.save_options()
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
