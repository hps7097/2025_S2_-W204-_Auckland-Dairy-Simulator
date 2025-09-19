#MADE WITH CHATGPT
extends Node
# Path to dialogue JSONs 
const DIALOGUE_DIR := "res://addons/story/dialogues/" 
 
@onready var ui = null 
 
func _ready(): 
	# Ensure DialogueUI is available (you can also instantiate it at runtime) 
	ui = get_node_or_null("/root/Main/DialogueUI") 
	if not ui: 
		# fallback: try autoload or scene tree lookup 
		ui = get_tree().get_root().find_node("DialogueUI", true, false) 

# Load dialogue by id (file contains multiple trees; or you can use one file per tree) 
func load_dialogue_by_file(file_path: String) -> Dictionary: 
	var f = File.new() 
	if not f.file_exists(file_path): 
		push_error("Dialogue file not found: %s" % file_path) 
		return {} 
	f.open(file_path, File.READ) 
	var txt = f.get_as_text() 
	f.close() 
	var data = {} 
	if txt != "": 
		data = parse_json(txt) 
	return data 

# Start a dialogue tree given its file and starting node id 
func start_dialogue(dialogue_file: String, start_node_id: String=null): 
	var file = DIALOGUE_DIR + dialogue_file 
	var data = load_dialogue_by_file(file) 
	if not data: 
		return 
	var start = start_node_id if start_node_id != null else data.get("start", null) 
	if start == null: 
		push_error("Dialogue missing start node: %s" % dialogue_file) 
		return 
	ui.show_dialogue(data, start, self) 
 
# Called by UI when choice is chosen 
func process_node(dialogue_data: Dictionary, node_id: String): 
	var node = dialogue_data["nodes"].get(node_id, null) 
	if node == null: 
		push_error("Dialogue node missing: %s" % node_id) 
		return 
	# apply effects if any 
	var effects = node.get("effects", []) 
	for e in effects: 
		apply_effect(e) 
	# if node declares an ending, report it 
	if node.has("ending"): 
		var ending = node["ending"] 
		GameState.seen_endings.append(ending) 
		GameState.set_flag("last_ending", ending) 
	# record branch history for replay tracking 
	GameState.branch_history.append(node_id)

# effect application 
func apply_effect(effect: Dictionary) -> void: 
	var t = effect.get("type", "") 
	match t: 
		"set_flag": 
			GameState.set_flag(effect.get("key", ""), effect.get("value", true)) 
		"clear_flag": 
			GameState.set_flag(effect.get("key", ""), false) 
		"give_item": 
			GameState.add_item(effect.get("item_id", ""), int(effect.get("count",1))) 
		"add_money": 
			GameState.add_money(int(effect.get("amount",0))) 
		"change_rep": 
			var target = effect.get("target","") 
			var amount = int(effect.get("amount",0)) 
			if target == "police": 
				GameState.police_rep += amount 
			elif target == "gang": 
				GameState.gang_rep += amount 
		"spawn_npc": 
			# dispatch signal or call your spawner system 
			var nid = effect.get("npc_id","") 
			emit_signal("spawn_npc", nid) 
		_: 
			print("Unknown effect type: %s" % t) 
 
# signals (optionally) 
# signal spawn_npc(npc_id)




 
