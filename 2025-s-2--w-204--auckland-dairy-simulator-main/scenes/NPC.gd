#MADE WITH CHATGPT
extends Area2D

@export var npc_id: String = "" 
@export var display_name: String = "Shopper" 
@export_file("*.json") var dialogue_file: String = "gumboot_story.json"  # filename in dialogues folder 
@export var dialogue_start_node: String = ""   # optional override 
@export var npc_data: Dictionary = {}  # optional metadata (items they buy, price list) 
@export var spawn_conditions: Array = []  # array of condition dictionaries 

@onready var name_label = $NameLabel

func _ready():
	name_label.text = display_name
	self.input_event.connect(_on_input_event)  # Updated connection for Godot 4.x

	# Evaluate spawn conditions on ready (or let spawner call show/hide) 
	if not _evaluate_spawn_conditions():
		visible = false
	else:
		visible = true
		GameState.npc_present[npc_id] = true

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.LEFT:
		_interact()

func _interact():
	# open dialogue through DialogueManager
	var dm = get_node("/root/Main/DialogueManager") if has_node("/root/Main/DialogueManager") else get_tree().get_root().find_node("DialogueManager", true, false)
	if dm:
		dm.start_dialogue(dialogue_file, dialogue_start_node)
	else:
		print("No DialogueManager found!")

func _evaluate_spawn_conditions() -> bool:
	# spawn_conditions example: [{type: "day_equals", "day": 2}, {type:"flag_true","key":"sold_hoons_to_gang"}] 
	for cond in spawn_conditions:
		var t = cond.get("type", "")
		match t:
			"day_equals":
				if GameState.day != int(cond.get("day", 0)):
					return false
			"day_gte":
				if GameState.day < int(cond.get("day", 0)):
					return false
			"flag_true":
				if not GameState.get_flag(cond.get("key", "")):
					return false
			"flag_false":
				if GameState.get_flag(cond.get("key", "")):
					return false
			_:
				# unknown conditions assume true
				pass
	return true

# optional: a function to force re-evaluate when the day changes or when flags update 
func reevaluate():
	visible = _evaluate_spawn_conditions()
	if visible:
		GameState.npc_present[npc_id] = true
	else:
		GameState.npc_present.erase(npc_id)
