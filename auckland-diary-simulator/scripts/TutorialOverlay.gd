extends Control

var stepsDay = [
	"Welcome to the store! Its your at first day at Auckland's \nFinest Dairy! Are we ready to grow your business?",
	"Customers will start converstations, converse with the locals\nand make dialogue choices that may affect the story.",
	"When serving customers, Drag items to the scanning desk. Only here\ncan items be scanned. Then drag the scanner to scan the item.",
	"Hover the scanner's beam over the item long enough, and when\nthe scanner beeps, Bag the item to sell it to the NPC.",
]
var stepsNight = [
	"Welcome to the After Hours Shop!",
	"This is where you can upgrade your dairy with various upgrades!",
	"The left upgrade is for your dairy's building.\nThis is to make your dairy more aesthetic!",
	"The middle upgrade is for your dairy's stock upgrades. \nUpgrade this to unlock more items to sell, gaining more daily customers!",
	"The last upgrade is...\nWell we dont talk about it."
]
var steps

var current = 0

@onready var step_label: Label = $PanelContainer/VBoxContainer/MarginContainer/step_label
@onready var next_button: Button = $PanelContainer/VBoxContainer/next_button

func _ready():
	z_index = 4096
	if GameManager.dayCount == 1:
		show()
		show_step()
	else:
		hide()

func show_step():
	var current_scene = get_tree().current_scene
	print(str(current_scene.name))
	if current_scene != null and current_scene.name == "main":
		steps = stepsDay
	else:
		steps = stepsNight
	step_label.text = steps[current]

func _on_next_button_pressed():
	current += 1
	if current < steps.size():
		show_step()
	else:
		hide()
	if current == steps.size() - 1:
		next_button.text = "Close"
