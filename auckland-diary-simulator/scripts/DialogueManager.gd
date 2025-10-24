# MADE WITH CHATGPT
extends Node

@onready var ui_instance: Control = $"../main/DialogueUI"

var dialogues: Dictionary = {}
var current_npc: String = ""
var current_data: Dictionary = {}
var current_node_id: String = ""

var purchaseArray: Array = []

func _ready() -> void:
	var master_path: String = "res://data/dialogues/dialogues.json"
	if FileAccess.file_exists(master_path):
		var f: FileAccess = FileAccess.open(master_path, FileAccess.READ)
		if f != null:
			var raw_text: String = f.get_as_text()
			f.close()
			var parsed_result = JSON.parse_string(raw_text) # no explicit type
			if parsed_result.error == OK:
				var loaded: Dictionary = parsed_result.result as Dictionary
				if loaded != null:
					dialogues = loaded

# Public: start dialogue for a given NPC/dialogue id (filename without extension)
func start_dialogue(npc_dialogue_id: String, purchases: Array = []) -> void: # FIXED LINE WITH CHATGPT
	current_npc = npc_dialogue_id
	purchaseArray = purchases
	var path: String = "res://data/dialogues/%s.json" % npc_dialogue_id
	if not FileAccess.file_exists(path):
		ProductManager.spawnNew(purchaseArray)
		return

	var f: FileAccess = FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("Failed to open dialogue file: %s" % path)
		return
	var raw_text: String = f.get_as_text()
	f.close()

	var parsed_result = JSON.parse_string(raw_text) # no JSONParseResult here

	var parsed_dict: Dictionary = JSON.parse_string(raw_text) as Dictionary
	if parsed_dict == null:
		push_warning("Dialogue JSON for %s did not parse into Dictionary" % npc_dialogue_id)
		return

	current_data = parsed_dict
	current_node_id = current_data.get("start", "") as String
	if current_node_id == "":
		push_warning("No start node for %s" % npc_dialogue_id)
		return

	_open_node(current_node_id)

# Internal: open a dialogue node by id
func _open_node(node_id: String) -> void:
	# Ensure nodes exists and is a Dictionary
	if not current_data.has("nodes"):
		push_warning("Dialogue has no 'nodes' key")
		return
	var nodes_dict: Dictionary = current_data["nodes"] as Dictionary
	if nodes_dict == null:
		push_warning("Dialogue 'nodes' is not a Dictionary")
		return

	var node: Dictionary = nodes_dict.get(node_id, null) as Dictionary
	if node == null:
		push_warning("Dialogue node not found: %s" % node_id)
		return

	# Show via UI
	ui_instance = $"../main/DialogueUI"
	if ui_instance == null:
		push_warning("Dialogue UI not available to show node")
		return

	ui_instance.start(current_data, purchaseArray)

	current_node_id = node_id

# ADDED EXTRA FUNCTION WITH CHATGPT

func _on_choice_made(choice: Dictionary) -> void:
    # Set flags
    for flag in choice.get("flags_set", []):
        GameState.set_flag(flag, true)
    # Apply effects
    var eff := choice.get("effects", {})
    if typeof(eff) == TYPE_DICTIONARY and eff.has("money"):
        GameState.money += int(eff["money"])
