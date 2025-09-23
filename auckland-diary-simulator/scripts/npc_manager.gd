# MADE WITH CHATGPT

extends Node

var counterFree: bool = true
var npcScene: PackedScene = preload("res://scenes/npc.tscn")

# One variable only, fallback to either path
@onready var shop_overview_main: Node = (
	$"../shopOverview" if has_node("../shopOverview") 
	else $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"
)

@export var npc_data_file: String = "res://data/npc_data.json"
var npc_data: Dictionary = {}

func _ready() -> void:
	_load_npc_data()
	# If you want continuous spawn loop:
	# run()
	# If you want per-day spawns from JSON:
	# spawn_for_day(GameState.current_day, shop_overview_main)

# ---------------- OLD LOOP SPAWNING ----------------
func run() -> void:
	var t: SceneTreeTimer = get_tree().create_timer(0.1)
	await t.timeout
	if shop_overview_main == null:
		print("shop_overview_main is NULL — check the node path!")
		return

	print("Manager Active")
	spawn_loop()

func spawn_loop() -> void:
	while true:
		if shop_overview_main == null:
			print("shop_overview_main is NULL — check the node path!")
			return
		print("Spawning NPC...")
		var npc: Node2D = npcScene.instantiate()
		npc.position = Vector2(-330, 0)
		shop_overview_main.add_child(npc)
		await get_tree().create_timer(2.0).timeout

# ---------------- NEW JSON SPAWNING ----------------
func _load_npc_data() -> void:
	if not FileAccess.file_exists(npc_data_file):
		push_warning("npc_data.json not found: %s" % npc_data_file)
		return
	var f: FileAccess = FileAccess.open(npc_data_file, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) == TYPE_DICTIONARY:
		npc_data = parsed
	else:
		push_warning("Failed parse npc_data.json")

# Spawn NPCs for a day into a given parent container
func spawn_for_day(day: int, parent: Node) -> void:
	# Clear existing children first (optional)
	for c in parent.get_children():
		c.queue_free()
	if not npc_data.has("npcs"):
		return
	var npcs: Array = npc_data["npcs"]
	for entry in npcs:
		if _npc_should_spawn(entry, day):
			var scene_path: String = entry.get("scene", "")
			if scene_path == "":
				continue
			var s: PackedScene = load(scene_path)
			if s == null:
				push_warning("Failed to load npc scene: %s" % scene_path)
				continue
			var npc: Node = s.instantiate()
			# Map fields into NPC
			npc.dialogue_id = entry.get("dialogue_id", entry.get("npc_id", ""))
			npc.is_special = entry.get("is_special", false)
			npc.show_conditions = entry.get("show_conditions", [])
			parent.add_child(npc)
			# connect interacted if needed
			if npc.has_signal("interacted"):
				npc.connect("interacted", Callable(self, "_on_npc_interacted"))

func _npc_should_spawn(entry: Dictionary, day: int) -> bool:
	if entry.has("appears_on_days"):
		var arr: Array = entry["appears_on_days"]
		if not day in arr:
			return false
	if entry.has("show_conditions"):
		var conditions: Array = entry["show_conditions"]
		for cond in conditions:
			var p: Array = cond.split(":")
			if p[0] == "flag" and not GameState.get_flag(p[1]):
				return false
			if p[0] == "day" and int(p[1]) != day:
				return false
	return true

func is_npc_allowed(npc_node: Node) -> bool:
	var conditions: Array = []
	if npc_node.has("show_conditions"):
		conditions = npc_node.get("show_conditions")
	for cond in conditions:
		var p: Array = cond.split(":")
		if p[0] == "flag" and not GameState.get_flag(p[1]):
			return false
		if p[0] == "day" and int(p[1]) != GameState.current_day:
			return false
	return true

func _on_npc_interacted(npc_id: String, dialogue_id: String) -> void:
	GameState.history.append({"type":"npc_interact", "npc": npc_id, "dialogue": dialogue_id})
	if dialogue_id != "":
		DialogueManager.start_dialogue(dialogue_id)
