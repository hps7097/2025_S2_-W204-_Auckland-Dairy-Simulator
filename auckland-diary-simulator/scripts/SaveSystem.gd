# MADE WITH CHATGPT
extends Node
class_name SaveSystem

const SAVE_PATH = "user://savegame.json"
const OPTIONS_PATH = "user://options.json"

static func save_game():
	var data = {
		"day": GameState.day,
		"money": GameState.money,
		"flags": GameState.flags,
		"inventory": GameState.inventory
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

static func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		GameState.day = data.get("day", 1)
		GameState.money = data.get("money", 0)
		GameState.flags = data.get("flags", {})
		GameState.inventory = data.get("inventory", [])
		return true
	return false

static func save_options():
	var file = FileAccess.open(OPTIONS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(GameState.options))
	file.close()

static func load_options():
	if not FileAccess.file_exists(OPTIONS_PATH):
		return
	var file = FileAccess.open(OPTIONS_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY:
		GameState.options = data
