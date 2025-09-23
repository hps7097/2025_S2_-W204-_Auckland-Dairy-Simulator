# MADE WITH CHATGPT

extends Node

const SAVE_FMT := "user://save_slot_%d.json"

func save_game(slot: int = 1) -> bool:
	var data := {
		"day": GameState.current_day,
		"money": GameState.money,
		"flags": GameState.flags,
		"upgrades": GameState.store_upgrades,
		"history": GameState.history,
		"options": GameState.options
	}
	var path := SAVE_FMT % slot
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("Failed to open save file for writing: %s" % path)
		return false
	f.store_string(JSON.stringify(data))
	f.close()
	return true

func load_game(slot: int = 1) -> bool:
	var path := SAVE_FMT % slot
	if not FileAccess.file_exists(path):
		return false
	var f = FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if parsed.error != OK:
		push_error("Save JSON parse error")
		return false
	var d = parsed.result
	GameState.current_day = int(d.get("day", 1))
	GameState.money = int(d.get("money", 0))
	GameState.flags = d.get("flags", {})
	GameState.store_upgrades = d.get("upgrades", {})
	GameState.history = d.get("history", [])
	GameState.options = d.get("options", GameState.options)
	return true
