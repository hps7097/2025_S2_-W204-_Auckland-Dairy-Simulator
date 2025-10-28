extends Control

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_pressed() -> void:
	var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
	if sound:
		sound.play()
		await get_tree().create_timer(0.12).timeout

	GameManager.newDay()
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
