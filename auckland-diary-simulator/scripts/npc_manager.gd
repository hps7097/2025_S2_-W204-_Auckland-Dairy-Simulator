extends Node

var counterFree: bool = true
var npcScene: PackedScene = preload("res://scenes/npc.tscn")

@onready var shop_overview_main: Node = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"

@export var npc_data_file: String = "res://data/npc_data.json"
var npc_data: Dictionary = {}

func _ready() -> void:
	_load_npc_data()
	# If you want continuous spawn loop:
	# run()
	# If you want per-day spawns from JSON:
	# spawn_for_day(GameManager.dayCount, shop_overview_main)

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
	
	if not npc_data.has("npcs"):
		return
	var npcs: Array = npc_data["npcs"]
	for entry in npcs:
		if _npc_should_spawn(entry, day):
			print("spawning")
			GameManager.dayCustomerCount += 1
			var scene_path: String = entry.get("scene", "")
			print(str(scene_path))
			if scene_path == "":
				continue
			var npc_root = npcScene.instantiate()
			var npc = npc_root.get_node("CharacterBody2D")
			# Map fields into NPC
			npc.npc_id = entry.get("npc_id", "")
			npc.dialogue_id = entry.get("dialogue_id", "")
			npc.show_conditions = entry.get("show_conditions", [])
			npc.purchases = entry.get("purchases", [])
			npc_root.position = Vector2(-330, 0)
			parent.add_child(npc_root)
			# connect interacted if needed
			if npc.has_signal("interacted"):
				npc.connect("interacted", Callable(self, "_on_npc_interacted"))
			print("spawned in " + entry.get("npc_id", ""))
			for i in range(20):
				await get_tree().create_timer(0.5).timeout
				if !get_tree().current_scene.scene_file_path.ends_with("dayScreen.tscn"):
					return

func _npc_should_spawn(entry: Dictionary, day: float) -> bool:
	print("checking")
	if entry.has("appears_on_days"):
		var arr: Array = entry["appears_on_days"]
		var today: bool = false
		print(str(day) + " " + str(arr))
		if day not in arr:
			return false
	var spawnable: bool = true
	if entry.has("show_conditions"):
		var conditions: Array = entry["show_conditions"]
		for cond in conditions:
			var p: Array = cond.split(":")
			if p[0] == "flag" and not GameManager.check_flag(p[1]):
				print("not flag")
				spawnable = false
			if p[0] == "upgrade1" and int(p[1]) != UpgradeManager.getUpgrade(0):
				print("not upgrade1")
				spawnable = false
			if p[0] == "upgrade2" and int(p[1]) != UpgradeManager.getUpgrade(1):
				print("not upgrade2")
				spawnable = false
			if p[0] == "upgrade3" and int(p[1]) != UpgradeManager.getUpgrade(2):
				print("not upgrade3")
				spawnable = false
	return spawnable
