#MADE WITH CHATGPT
extends Node
# class_name DialogueManager   <-- REMOVE this if autoloaded!

signal dialogue_started(dialogue: Dictionary)
signal dialogue_ended
signal dialogue_choice_made(choice: Dictionary)

var dialogues: Dictionary = {}
var current_dialogue: Dictionary = {}
var current_index := 0

func load_dialogues(path: String) -> void:
	if not FileAccess.file_exists(path):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(content)
	if typeof(parsed) == TYPE_DICTIONARY:
		dialogues = parsed

func start(dialogue_id: String) -> void:
	if not dialogues.has(dialogue_id):
		push_warning("Dialogue not found: " + dialogue_id)
		return
	current_dialogue = dialogues[dialogue_id]
	current_index = 0
	emit_signal("dialogue_started", current_dialogue)

func next(choice: String = "") -> void:
	if not current_dialogue.has("lines"):
		emit_signal("dialogue_ended")
		return

	var lines: Array = current_dialogue["lines"]
	if current_index >= lines.size():
		emit_signal("dialogue_ended")
		return

	var line: Dictionary = lines[current_index]

	# Apply effects from a chosen option
	if choice != "" and line.has("choices"):
		for c in line["choices"]:
			if c["text"] == choice:
				if c.has("effects"):
					_apply_effects(c["effects"])
				emit_signal("dialogue_choice_made", c)

	current_index += 1
	if current_index >= lines.size():
		emit_signal("dialogue_ended")

func _apply_effects(effects: Dictionary) -> void:
	for key in effects.keys():
		match key:
			"money":
				GameState.money += int(effects[key])
			"police_rep":
				GameState.police_rep += int(effects[key])
			"gang_rep":
				GameState.gang_rep += int(effects[key])
			_:
				GameState.flags[key] = effects[key]

func _ready() -> void:
	var file = FileAccess.open("res://dialogues/test.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY:
			dialogues = data
