# REMADE WITH CHATGPT
extends Node
class_name SaveSystem

const SAVE_PATH := "user://savegame.json"
const OPTIONS_PATH := "user://options.json"

# Save the full game state to user://
func save_game(save_name: String = "") -> bool:
	var data := {
		"day": GameState.current_day if "current_day" in GameState else GameState.day,
		"money": GameState.money,
		"flags": GameState.flags,
		"upgrades": GameState.upgrades,
		"history": GameState.history,
		"options": GameState.options
	}
	var filepath := SAVE_PATH
	if save_name != "":
		filepath = "user://savegame_%s.json" % save_name
	var f := FileAccess.open(filepath, FileAccess.WRITE)
	if f == null:
		push_warning("Failed to open save file for write: %s" % filepath)
		return false
	f.store_string(JSON.stringify(data))
	f.close()
	return true

# Load default or named save
func load_game(save_name: String = "") -> bool:
	var filepath := SAVE_PATH
	if save_name != "":
		filepath = "user://savegame_%s.json" % save_name
	if not FileAccess.file_exists(filepath):
		push_warning("Save file not found: %s" % filepath)
		return false
	var f := FileAccess.open(filepath, FileAccess.READ)
	if f == null:
		push_warning("Failed to open save file: %s" % filepath)
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Save parse failed for %s" % filepath)
		return false
	var data: Dictionary = parsed
	GameState.current_day = int(data.get("day", GameState.current_day))
	GameState.money = int(data.get("money", GameState.money))
	GameState.flags = data.get("flags", {}) as Dictionary
	GameState.upgrades = data.get("upgrades", []) as Array
	GameState.history = data.get("history", []) as Array
	GameState.options = data.get("options", GameState.options)
	return true

# Save/load options separately (for the Options menu)
func save_options() -> void:
	var f := FileAccess.open(OPTIONS_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(GameState.options))
		f.close()

func load_options() -> void:
	if not FileAccess.file_exists(OPTIONS_PATH):
		return
	var f := FileAccess.open(OPTIONS_PATH, FileAccess.READ)
	if f:
		var parsed = JSON.parse_string(f.get_as_text())
		f.close()
		if typeof(parsed) == TYPE_DICTIONARY:
			GameState.options = parsed

