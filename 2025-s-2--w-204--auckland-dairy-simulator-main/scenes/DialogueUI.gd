#MADE WITH CHATGPT
extends Control

@onready var npc_name = $Panel/VBoxContainer/NPCName
@onready var dialogue_text = $Panel/VBoxContainer/DialogueText
@onready var choices_container = $Panel/VBoxContainer/ChoicesContainer

func _ready() -> void:
	hide()
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.dialogue_choice_made.connect(_on_choice_made)

func _on_dialogue_started(dialogue: Dictionary) -> void:
	show()
	_show_line(dialogue["lines"][0])

func _on_dialogue_ended() -> void:
	hide()

func _on_choice_made(choice: Dictionary) -> void:
	# Immediately show next line after a choice
	if DialogueManager.current_dialogue.has("lines"):
		var idx = DialogueManager.current_index
		if idx < DialogueManager.current_dialogue["lines"].size():
			_show_line(DialogueManager.current_dialogue["lines"][idx])

func _show_line(line: Dictionary) -> void:
	npc_name.text = line.get("npc", "???")
	dialogue_text.text = line.get("text", "")
	_clear_choices()

	if line.has("choices"):
		for choice in line["choices"]:
			var btn = Button.new()
			btn.text = choice["text"]
			btn.pressed.connect(_on_choice_pressed.bind(choice["text"]))
			choices_container.add_child(btn)
	else:
		# Add a "Continue" button if no choices
		var cont = Button.new()
		cont.text = "Continue"
		cont.pressed.connect(_on_choice_pressed.bind(""))
		choices_container.add_child(cont)

func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()

func _on_choice_pressed(choice_text: String) -> void:
	DialogueManager.next(choice_text)
