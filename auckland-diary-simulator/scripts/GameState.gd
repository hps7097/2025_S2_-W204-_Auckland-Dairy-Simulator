class_name GameState
extends Node

# Central game state and simple JSON save/load helpers.
# Works with Godot 4.5. Saves to user://saves/<name>.json

var runs: Array = []
var current_run: Dictionary = {}
var replay_count: int = 0
const SAVE_DIR := "user://saves"

func _ready() -> void:
    # Ensure save directory exists
    if DirAccess.open(SAVE_DIR) == null:
        DirAccess.make_dir_recursive(SAVE_DIR)

func start_new_run() -> void:
    current_run = {"choices": [], "events": [], "ending": ""}
    runs.append(current_run)
    replay_count += 1

func record_choice(choice_id: String) -> void:
    if not current_run.has("choices"):
        current_run["choices"] = []
    current_run["choices"].append(choice_id)

func set_ending(ending_id: String) -> void:
    current_run["ending"] = ending_id

func save_to_file(filename: String) -> bool:
    # Create directory if missing
    if DirAccess.open(SAVE_DIR) == null:
        DirAccess.make_dir_recursive(SAVE_DIR)
    var path := SAVE_DIR + "/" + filename + ".json"
    var data := {"runs": runs, "replay_count": replay_count}

    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_warning("GameState.save_to_file: failed to open file: %s" % path)
        return false
    file.store_string(JSON.stringify(data))
    file.close()
    return true

func load_from_file(filename: String) -> bool:
    var path := SAVE_DIR + "/" + filename + ".json"
    if not FileAccess.file_exists(path):
        return false
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_warning("GameState.load_from_file: failed to open file: %s" % path)
        return false
    var text := file.get_as_text()
    file.close()

    var parsed := JSON.parse_string(text)
    if parsed.error != OK:
        push_warning("GameState.load_from_file: JSON parse error in %s" % path)
        return false
    var data := parsed.result
    runs = data.get("runs", [])
    replay_count = int(data.get("replay_count", 0))
    # restore the most recent run into current_run
    if runs.size() > 0:
        current_run = runs[runs.size() - 1]
    else:
        current_run = {"choices": [], "events": [], "ending": ""}
    return true

func list_saves() -> Array:
    var saves: Array = []
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        return saves
    dir.list_dir_begin()
    var f := dir.get_next()
    while f != "":
        if f.ends_with(".json"):
            saves.append(f.replace(".json", ""))
        f = dir.get_next()
    dir.list_dir_end()
    return saves

# Optional helper for flexible state flags
var flags: Dictionary = {}

func set_flag(key: String, value: bool) -> void:
    flags[key] = value

func get_flag(key: String) -> bool:
    return flags.get(key, false)
