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
			var json = JSON.new()
			var error = json.parse(raw_text)
			if error == OK:
				var parsed_result = json.get_data()
				if parsed_result != null and typeof(parsed_result) == TYPE_DICTIONARY:
					dialogues = parsed_result
			else:
				push_warning("Failed to parse master dialogue file: " + json.get_error_message())

# Public: start dialogue for a given NPC/dialogue id (filename without extension)
func start_dialogue(npc_dialogue_id: String, purchases: Array) -> void:
	current_npc = npc_dialogue_id
	purchaseArray = purchases
	var path: String = "res://data/dialogues/%s.json" % npc_dialogue_id
	if not FileAccess.file_exists(path):
		print("Dialogue file not found: ", path)
		ProductManager.spawnNew(purchaseArray)
		return

	var f: FileAccess = FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("Failed to open dialogue file: %s" % path)
		return
	var raw_text: String = f.get_as_text()
	f.close()

	# Use the newer JSON parsing method
	var json = JSON.new()
	var error = json.parse(raw_text)
	if error != OK:
		push_warning("Failed to parse dialogue JSON for %s: %s" % [npc_dialogue_id, json.get_error_message()])
		ProductManager.spawnNew(purchaseArray)
		return
	
	var parsed_dict = json.get_data()
	if typeof(parsed_dict) != TYPE_DICTIONARY:
		push_warning("Dialogue JSON for %s did not parse into Dictionary. Got type: %s" % [npc_dialogue_id, typeof(parsed_dict)])
		ProductManager.spawnNew(purchaseArray)
		return

	current_data = parsed_dict
	
	# FIXED: Better handling of both start_nodes and start systems
	var current_day = GameManager.dayCount
	print("Current day: ", current_day, " - Loading dialogue for: ", npc_dialogue_id)
	
	var start_nodes = current_data.get("start_nodes", {})
	var simple_start = current_data.get("start", "")
	
	# Priority: start_nodes > start > fallback
	if start_nodes.has(str(current_day)):
		current_node_id = start_nodes[str(current_day)]
		print("Using day-specific start node: ", current_node_id)
	elif simple_start != "":
		current_node_id = simple_start
		print("Using simple start node: ", current_node_id)
	elif start_nodes.size() > 0:
		# Fallback to first start_node if no day match
		var first_key = start_nodes.keys()[0]
		current_node_id = start_nodes[first_key]
		print("Using fallback start node: ", current_node_id)
	else:
		push_warning("No start node found for %s" % npc_dialogue_id)
		ProductManager.spawnNew(purchaseArray)
		return

	_open_node(current_node_id)

# Internal: open a dialogue node by id
func _open_node(node_id: String) -> void:
	# Ensure nodes exists and is a Dictionary
	if not current_data.has("nodes"):
		push_warning("Dialogue has no 'nodes' key")
		ProductManager.spawnNew(purchaseArray)
		return
	
	var nodes_dict = current_data["nodes"]
	if typeof(nodes_dict) != TYPE_DICTIONARY:
		push_warning("Dialogue 'nodes' is not a Dictionary. Got type: %s" % typeof(nodes_dict))
		ProductManager.spawnNew(purchaseArray)
		return

	var node = nodes_dict.get(node_id, null)
	if typeof(node) != TYPE_DICTIONARY:
		push_warning("Dialogue node not found or not a Dictionary: %s" % node_id)
		ProductManager.spawnNew(purchaseArray)
		return

	# TEMPORARY FIX: Skip condition checking for now
	# Show via UI
	ui_instance = $"../main/DialogueUI"
	if ui_instance == null:
		push_warning("Dialogue UI not available to show node")
		ProductManager.spawnNew(purchaseArray)
		return

	# Use the new method for day-based dialogues
	if ui_instance.has_method("show_dialogue_node"):
		ui_instance.show_dialogue_node(current_data, node_id, purchaseArray)
	else:
		# Fallback to existing method if available
		push_warning("DialogueUI doesn't have show_dialogue_node, using start()")
		ui_instance.start(current_data, purchaseArray)

	current_node_id = node_id
