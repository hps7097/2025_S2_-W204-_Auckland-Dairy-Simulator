# MADE WITH CHATGPT
extends Node

@onready var dialogue_ui_scene: PackedScene = preload("res://scenes/DialogueUI.tscn")
@onready var ui_instance: Control = null

var dialogues: Dictionary = {}
var current_npc: String = ""
var current_data: Dictionary = {}
var current_node_id: String = ""

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


	# instantiate the UI and add to the scene root (so it's on top)
	var tmp_node: Node = dialogue_ui_scene.instantiate()
	if tmp_node is Control:
		ui_instance = tmp_node as Control
		get_tree().get_root().add_child(ui_instance)
		ui_instance.hide()
		# connect the choice_made signal (DialogueUI should emit this)
		if ui_instance.has_signal("choice_made"):
			ui_instance.connect("choice_made", Callable(self, "_on_choice_made"))
	else:
		push_warning("Dialogue UI scene did not instantiate as Control")

# Public: start dialogue for a given NPC/dialogue id (filename without extension)
func start_dialogue(npc_dialogue_id: String) -> void:
	current_npc = npc_dialogue_id
	var path: String = "res://data/dialogues/%s.json" % npc_dialogue_id
	if not FileAccess.file_exists(path):
		push_warning("Dialogue file not found: %s" % path)
		return

	var f: FileAccess = FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("Failed to open dialogue file: %s" % path)
		return
	var raw_text: String = f.get_as_text()
	f.close()

	var parsed_result = JSON.parse_string(raw_text) # no JSONParseResult here
	if parsed_result.error != OK:
		push_warning("Dialogue JSON parse error for %s (error %d)" % [npc_dialogue_id, parsed_result.error])
		return

	var parsed_dict: Dictionary = parsed_result.result as Dictionary
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
	if ui_instance == null:
		push_warning("Dialogue UI not available to show node")
		return

	ui_instance.show()
	# Expect UI instance to implement show_dialogue_node(node: Dictionary)
	if ui_instance.has_method("show_dialogue_node"):
		ui_instance.call_deferred("show_dialogue_node", node)
	else:
		push_warning("Dialogue UI missing method show_dialogue_node")

	current_node_id = node_id

# Called by the Dialogue UI when the player selects a choice
func _on_choice_made(choice: Dictionary) -> void:
	if typeof(choice) != TYPE_DICTIONARY:
		push_warning("_on_choice_made got non-dictionary choice")
		return

	# Apply flags_set (array of strings)
	var flags_arr: Array = choice.get("flags_set", []) as Array
	for f_item in flags_arr:
		if typeof(f_item) == TYPE_STRING:
			GameState.set_flag(f_item, true)

	# Apply effects (dictionary), e.g., {"money": 20}
	var effects: Dictionary = choice.get("effects", {}) as Dictionary
	if effects != null and effects.has("money"):
		var money_val = effects.get("money")
		# ensure numeric
		if typeof(money_val) in [TYPE_INT, TYPE_FLOAT]:
			GameState.add_money(int(money_val))

	# Add history entry for analytics
	var history_entry: Dictionary = {
		"type": "dialogue_choice",
		"npc": current_data.get("npc_id", current_npc),
		"node": current_node_id,
		"choice": choice.get("text", "")
	}
	GameState.history.append(history_entry)

	# Next node or end
	var next_node: String = choice.get("next", "") as String
	if next_node != "":
		_open_node(next_node)
	else:
		if ui_instance != null:
			ui_instance.hide()
