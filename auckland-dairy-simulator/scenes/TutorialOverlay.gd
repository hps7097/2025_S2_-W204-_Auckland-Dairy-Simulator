# MADE WITH CHATGPT

extends CanvasLayer

var steps = [
	"Welcome to the store!",
	"Drag an item to the scanner.",
	"Sell it to the NPC.",
    "Talk to NPCs and make choices."
]
var current = 0
@onready var step_label = $step_label

func _ready():
	show_step()

func show_step():
	step_label.text = steps[current]

func _on_next_button_pressed():
	current += 1
	if current < steps.size():
		show_step()
	else:
		queue_free() # remove overlay
