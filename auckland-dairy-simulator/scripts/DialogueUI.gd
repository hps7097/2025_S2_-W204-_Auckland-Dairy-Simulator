# MADE WITH CHATGPT
extends Control

signal choice_made(choice: Dictionary)

@onready var npc_name_label: Label = $DialogPanel/NPCName
@onready var dialogue_text: RichTextLabel = $DialogPanel/DialogueText
@onready var choices_container: VBoxContainer = $DialogPanel/ChoicesContainer
@onready var close_button: Button = $DialogPanel/CloseButton

var current_dialogue: Dictionary = {}
var current_node: String = ""
var auto_mode: bool = false

func _ready() -> void:
	close_button.visible = false
	close_button.pressed.connect(_on_close_pressed)

func start(dialogue: Dictionary) -> void:
	current_dialogue = dialogue
	current_node = dialogue.get("start", "")
	if current_node == "":
		hide()
		return
	show_node(current_node)
	show()

func show_node(node_id: String) -> void:
	# clear old choices
	for c in choices_container.get_children():
		c.queue_free()

	var node: Dictionary = current_dialogue["nodes"].get(node_id, null)
	if node == null:
		hide()
		return

	current_node = node_id
	npc_name_label.text = node.get("speaker", "")
	dialogue_text.text = node.get("text", "")

	var choices: Array = node.get("choices", [])
	if choices.is_empty():
		close_button.visible = true
	else:
		close_button.visible = false
		for choice in choices:
			var btn := Button.new()
			btn.text = choice.get("text", "…")
			btn.pressed.connect(_on_choice_pressed.bind(choice))
			choices_container.add_child(btn)

	if auto_mode and not choices.is_empty():
		await get_tree().create_timer(2.0).timeout
		_on_choice_pressed(choices[0])

func _on_choice_pressed(choice: Dictionary) -> void:
	emit_signal("choice_made", choice)

	# Apply flags
	for flag in choice.get("flags_set", []):
		GameState.set_flag(flag, true)

	# Apply effects
	var effs: Dictionary = choice.get("effects", {})
	if effs.has("money"):
		GameState.money += effs["money"]

	# Advance
	var next: String = choice.get("next", "")
	if next == "":
		hide()
	else:
		show_node(next)

func _on_close_pressed() -> void:
	hide()

func set_auto_mode(enabled: bool) -> void:
	auto_mode = enabled
