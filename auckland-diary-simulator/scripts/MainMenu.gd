extends Control

@onready var play_button = $VBox/PlayButton
@onready var options_button = $VBox/OptionsButton
@onready var load_button = $VBox/LoadButton
@onready var quit_button = $VBox/QuitButton
const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

func _ready():
	# Connect all button signals to their handlers
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

# helper function to play the click sound
func _play_click_sound(button: Button) -> void:
	var sound: AudioStreamPlayer2D = button.get_node_or_null("AudioStreamPlayer2D")
	if sound:
		sound.play()

func _on_play_button_pressed():
	var sfx: AudioStreamPlayer2D = $VBox/PlayButton/AudioStreamPlayer2D
	if sfx:
		sfx.play()
		await get_tree().create_timer(0.12).timeout
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	GameManager.newDay()

func _on_options_button_pressed():
	var sfx: AudioStreamPlayer2D = $VBox/OptionsButton/AudioStreamPlayer2D
	if sfx:
		sfx.play()
		await get_tree().create_timer(0.12).timeout
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096
	get_tree().current_scene.add_child(optionsMenu)

func _on_load_button_pressed():
	var sfx: AudioStreamPlayer2D = $VBox/LoadButton/AudioStreamPlayer2D
	if sfx:
		sfx.play()
		await get_tree().create_timer(0.12).timeout
	get_tree().change_scene_to_file("res://scenes/LoadMenu.tscn")

func _on_quit_button_pressed():
	var sfx: AudioStreamPlayer2D = $VBox/QuitButton/AudioStreamPlayer2D
	if sfx:
		sfx.play()
		await get_tree().create_timer(0.12).timeout
	get_tree().quit()
