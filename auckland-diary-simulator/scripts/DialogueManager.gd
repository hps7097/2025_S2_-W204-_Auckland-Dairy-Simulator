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
			var parsed_result = JSON.parse_string(raw_text)
			if parsed_result != null:
				var loaded: Dictionary = parsed_result
				if loaded != null:
					dialogues = loaded

# Public: start dialogue for a given NPC/dialogue id (filename without extension)
func start_dialogue(npc_dialogue_id: String, purchases: Array) -> void:
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

	var parsed_dict: Dictionary = JSON.parse_string(raw_text) as Dictionary
	if parsed_dict == null:
		push_warning("Dialogue JSON for %s did not parse into Dictionary" % npc_dialogue_id)
		return

	current_data = parsed_dict
	
	# NEW: Handle start_nodes based on current day from GameManager
	var current_day = GameManager.dayCount # Get current day from GameManager
	print("Current day: ", current_day)
	var start_nodes = current_data.get("start_nodes", {})
	print("Start nodes available: ", start_nodes)
	
	# Check if this NPC uses start_nodes system
	if start_nodes.has(str(current_day)):
		current_node_id = start_nodes[str(current_day)]
		print("Using day-specific start node for day ", current_day, ": ", current_node_id)
	elif start_nodes.size() > 0:
		# Has start_nodes but no entry for current day - use fallback or first available
		var fallback_node = current_data.get("start", "") as String
		if fallback_node == "" and start_nodes.size() > 0:
			# Use the first start_node as fallback
			var first_key = start_nodes.keys()[0]
			current_node_id = start_nodes[first_key]
			print("No start node for day ", current_day, ", using fallback: ", current_node_id)
		else:
			current_node_id = fallback_node
	else:
		# Use traditional start field
		current_node_id = current_data.get("start", "") as String
		print("Using traditional start node: ", current_node_id)
	
	if current_node_id == "":
		push_warning("No start node for %s on day %s" % [npc_dialogue_id, current_day])
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
	var nodes_dict: Dictionary = current_data["nodes"] as Dictionary
	if nodes_dict == null:
		push_warning("Dialogue 'nodes' is not a Dictionary")
		ProductManager.spawnNew(purchaseArray)
		return

	var node: Dictionary = nodes_dict.get(node_id, null) as Dictionary
	if node == null:
		push_warning("Dialogue node not found: %s" % node_id)
		ProductManager.spawnNew(purchaseArray)
		return

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
