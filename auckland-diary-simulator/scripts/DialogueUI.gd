# MADE WITH CHATGPT
extends Control

@onready var npc_name_label: Label = $DialogPanel/VBoxContainer/NPCName
@onready var dialogue_text: RichTextLabel = $DialogPanel/VBoxContainer/VBoxContainer/MarginContainer/DialogueText
@onready var choices_container: VBoxContainer = $DialogPanel/VBoxContainer/VBoxContainer/ChoicesContainer
@onready var close_button: Button = $DialogPanel/VBoxContainer/HBoxContainer/CloseButton

var current_dialogue: Dictionary = {}
var current_node: String = ""

var purchaseArray: Array = []

func _ready() -> void:
	z_index = 4096
	close_button.hide()

func start(dialogue: Dictionary, purchases: Array) -> void:
	current_dialogue = dialogue
	purchaseArray = purchases
	print(str(current_dialogue))
	current_node = dialogue.get("start", "")
	if current_node == "":
		print("NO START NODE")
		ProductManager.spawnNew(purchaseArray)
		hide()
		return
	show()
	show_node(current_node)
	

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
	dialogue_text.visible_characters = 0
	for i in dialogue_text.text.length():
		dialogue_text.visible_characters = i
		await get_tree().create_timer(0.05).timeout
		if Input.is_action_pressed("speed_up"):
			break
	dialogue_text.visible_characters = -1

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

func _on_choice_pressed(choice: Dictionary) -> void:
	# Apply flags
	for flag in choice.get("flags_set", []):
		GameManager.add_flag(str(flag))

	# Advance
	var next: String = choice.get("next", "")
	if next == "":
		hide()
		ProductManager.spawnNew(purchaseArray)
	else:
		show_node(next)

func _on_close_button_pressed() -> void:
	ProductManager.spawnNew(purchaseArray)
	hide()
