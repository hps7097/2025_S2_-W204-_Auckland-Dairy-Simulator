# MADE WITH CHATGPT

extends Node

const SAVE_PATH := "user://savegame.json"

var save_data := {
	"money": 0,
	"day": 1,
	"inventory": []
}

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved!")

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			save_data = parsed
			print("Game loaded: ", save_data)
			return true
	return false
