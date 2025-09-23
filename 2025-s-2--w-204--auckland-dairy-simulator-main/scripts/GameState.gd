#MADE WITH CHATGPT
extends Node

# --- Persistent Variables ---
var money: int = 0
var police_rep: int = 0
var gang_rep: int = 0
var flags: Dictionary = {}
var day: int = 1

func _ready() -> void:
	# Try to load previous save
	var loaded := SaveManager.load_game()
	if loaded.size() > 0:
		money = loaded.get("money", 0)
		police_rep = loaded.get("police_rep", 0)
		gang_rep = loaded.get("gang_rep", 0)
		flags = loaded.get("flags", {})
		day = loaded.get("day", 1)
		print("✅ GameState loaded:", loaded)
	else:
		print("⚠️ No save file found, starting fresh.")

# --- State-Changing Methods ---
func add_money(amount: int) -> void:
	money += amount
	save()

func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value
	save()

func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

func adjust_police_rep(amount: int) -> void:
	police_rep += amount
	save()

func adjust_gang_rep(amount: int) -> void:
	gang_rep += amount
	save()

func next_day() -> void:
	day += 1
	save()

# --- Save/Load ---
func save() -> void:
	var data := {
		"money": money,
		"police_rep": police_rep,
		"gang_rep": gang_rep,
		"flags": flags,
		"day": day
	}
	SaveManager.save_game(data)
