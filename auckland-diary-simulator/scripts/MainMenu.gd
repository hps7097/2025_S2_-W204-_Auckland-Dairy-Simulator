extends Control

@onready var play_button = $VBox/PlayButton
@onready var options_button = $VBox/OptionsButton
@onready var load_button = $VBox/LoadButton
@onready var quit_button = $VBox/QuitButton
@onready var popup_text: Node2D = $PopupText

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

func _ready():
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	GameManager.setDayCount(0)
	UpgradeManager.resetUpgrades()
	GameManager.newDay()

func _on_options_button_pressed():
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_load_button_pressed() -> void:
	var loaded_data = SaveManager.load_game("1")
	if loaded_data:
		ProductManager.setMoney(loaded_data.get("money", 0))
		GameManager.setDayCount(loaded_data.get("day", 1))
		GameManager.setDayNight(loaded_data.get("dayNight", 1))
		UpgradeManager.upgrades = loaded_data.get("upgrades", [0,0,0])
		GameManager.setFlags(loaded_data.get("flags", []))
		GameManager.loadDay()
		print("Game loaded successfully ✅")
	else:
		popup_text.calling("No Save File Found")
		printerr("Failed to load game ❌")
