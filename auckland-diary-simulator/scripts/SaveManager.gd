#MADE WITH CHATGPT

extends Node

const SAVE_DIR := "user://saves/"
const MAX_SLOTS := 10

func _ready() -> void:
	# Ensure save directory exists
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		var err = DirAccess.make_dir_recursive_absolute(SAVE_DIR)
		if err != OK:
			push_error("SaveManager: Failed to create save directory!")

func _save_path(slot:int) -> String:
	slot = clamp(slot, 1, MAX_SLOTS)
	return SAVE_DIR + "save_%d.json" % slot

# Save the given dictionary to a JSON file
func save_game(slot:int, state:Dictionary) -> bool:
	var path = _save_path(slot)
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("SaveManager: Failed to open file for write: %s" % path)
		return false
	f.store_string(JSON.stringify(state, "\t"))
	f.close()
	return true

# Load a dictionary from a JSON file
func load_game(slot:int) -> Dictionary:
	var path = _save_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("SaveManager: Failed to open file for read: %s" % path)
		return {}
	var text := f.get_as_text()
	f.close()

	var result = JSON.parse_string(text)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("SaveManager: Invalid save data in %s" % path)
		return {}
	return result

# Returns a list of save slots that exist
func list_saves() -> Array:
	var saves := []
	for i in range(1, MAX_SLOTS + 1):
		if FileAccess.file_exists(_save_path(i)):
			saves.append(i)
	return saves
