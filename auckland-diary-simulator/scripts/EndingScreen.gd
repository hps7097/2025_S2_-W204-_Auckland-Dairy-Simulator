extends Control
@onready var day_7: TextureRect = $Day7
@onready var top: Sprite2D = $Top
@onready var bottom: Sprite2D = $Bottom
@onready var ending_title: TextureRect = $EndingTitle
@onready var return_to_main_menu: Button = $"Return to Main Menu"
@onready var sirens: AudioStreamPlayer2D = $sirens
@onready var crash: AudioStreamPlayer2D = $crash
@onready var label: Label = $Label


func _ready() -> void:
	var backgroundFilePath
	var titleFilePath
	if GameManager.check_flag("ending_clean"):
		backgroundFilePath = "res://assets/Endings/EndingScreenBackupArrived.png"
		titleFilePath = "res://assets/Endings/EndingTitlesBackupArrived.png"
	elif GameManager.check_flag("ending_busted"):
		sirens.play()
		backgroundFilePath = "res://assets/Endings/EndingScreenBusted.png"
		titleFilePath = "res://assets/Endings/EndingTitlesBusted.png"
	elif GameManager.check_flag("gang_affiliated"):
		backgroundFilePath = "res://assets/Endings/EndingScreenGangAffiliated.png"
		titleFilePath = "res://assets/Endings/EndingTitlesGangAffiliated.png"
	elif UpgradeManager.getUpgrade(0) == 5:
		crash.play()
		backgroundFilePath = "res://assets/Endings/EndingScreenFullyArmoured.png"
		titleFilePath = "res://assets/Endings/EndingTitlesFullyArmoured.png"
	else:
		crash.play()
		sirens.play()
		backgroundFilePath = "res://assets/Endings/EndingScreenRamRaided.png"
		titleFilePath = "res://assets/Endings/EndingTitlesRamRaided.png"
	# HAVE CHECK THE FLAGS FOR THE ENDING
	ending_title.texture = load(titleFilePath)
	bottom.texture = load(backgroundFilePath)
	
	await get_tree().create_timer(1.0).timeout
	top.moveAnimation()
	bottom.moveAnimation()
	await get_tree().create_timer(1.0).timeout
	day_7.modulate.a = 1.0
	await get_tree().create_timer(3.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(day_7, "modulate:a", 0, 2.0)
	await get_tree().create_timer(5.0).timeout
	ending_title.modulate.a = 1.0
	await get_tree().create_timer(3.0).timeout
	label.show()
	return_to_main_menu.show()

func _on_return_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
