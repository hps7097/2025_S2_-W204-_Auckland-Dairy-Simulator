# MADE WITH CHATGPT
extends Node

const SAVE_PATH := "user://saves/"

func _ensure_save_dir():
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)

func save_game(filename: String, data: Dictionary) -> bool:
	_ensure_save_dir()
	var file = FileAccess.open(SAVE_PATH + filename + ".json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		return true
	return false

func load_game(filename: String) -> Dictionary:
	var path = SAVE_PATH + filename + ".json"
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data
