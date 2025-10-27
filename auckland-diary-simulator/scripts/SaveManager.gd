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

func list_saves() -> Array:
	var saves = []
	var dir = DirAccess.open(SAVE_PATH)
	if dir == null:
		return saves
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".json"):
			saves.append(file.replace(".json", ""))
		file = dir.get_next()
	dir.list_dir_end()
	return saves
