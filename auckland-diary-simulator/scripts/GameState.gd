# MADE WITH CHATGPT
extends Node

# Stores multiple playthrough runs
var runs: Array = []
var current_run: Dictionary = {}
var replay_count: int = 0
const SAVE_DIR := "user://saves"

# Track boolean flags for path decisions
var flags := {}

# Start a brand-new playthrough
func start_new_run() -> void:
    current_run = {
        "choices": [],
        "events": [],
        "ending": ""
    }
    runs.append(current_run)
    replay_count += 1

# Record a choice made by the player
func record_choice(choice_id: String) -> void:
    current_run["choices"].append(choice_id)

# Record an event or scene trigger
func record_event(event_id: String) -> void:
    current_run["events"].append(event_id)

# Set the final ending of this run
func set_ending(ending_id: String) -> void:
    current_run["ending"] = ending_id

# Save all data to JSON file
func save_to_file(filename: String) -> bool:
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        DirAccess.make_dir_recursive_absolute(SAVE_DIR)
    var data := {
        "runs": runs,
        "replay_count": replay_count
    }
    var path := SAVE_DIR + "/" + filename + ".json"
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))
        file.close()
        return true
    return false

# Load all data from JSON file
func load_from_file(filename: String) -> bool:
    var path := SAVE_DIR + "/" + filename + ".json"
    if not FileAccess.file_exists(path):
        return false
    var file := FileAccess.open(path, FileAccess.READ)
    var text := file.get_as_text()
    file.close()
    var data := JSON.parse_string(text)
    if typeof(data) != TYPE_DICTIONARY:
        return false
    runs = data.get("runs", [])
    replay_count = data.get("replay_count", 0)
    return true

# List all saves in user://saves directory
func list_saves() -> Array:
    var saves: Array = []
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        return saves
    dir.list_dir_begin()
    var file_name := dir.get_next()
    while file_name != "":
        if file_name.ends_with(".json"):
            saves.append(file_name.replace(".json", ""))
        file_name = dir.get_next()
    dir.list_dir_end()
    return saves

# Optional path flag system
func set_flag(key: String, value: bool) -> void:
    flags[key] = value

func get_flag(key: String) -> bool:
    return flags.get(key, false)
