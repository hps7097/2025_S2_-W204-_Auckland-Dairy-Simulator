# MADE WITH CHATGPT

# GameState.gd — global singleton for runs, choices, save/load
extends Node

var runs: Array = []
var current_run: Dictionary = {}
var replay_count: int = 0
const SAVE_DIR := "user://saves"
var flags: Dictionary = {}

func _ready():
    # nothing special — ensure autoload is set in Project Settings
    pass

func start_new_run():
    reset_flags()
    current_run = {"choices": [], "events": [], "ending": ""}
    runs.append(current_run)
    replay_count += 1

func reset_flags():
    flags.clear()

func record_choice(choice_id: String):
    if not current_run:
        start_new_run()
    current_run["choices"].append(choice_id)

func record_event(event_id: String):
    if not current_run:
        start_new_run()
    current_run["events"].append(event_id)

func set_ending(ending_id: String):
    if not current_run:
        start_new_run()
    current_run["ending"] = ending_id
    print("Run " + str(replay_count) + " ended with ending: " + ending_id)

func save_to_file(filename: String) -> bool:
    # Ensure save dir exists
    if not DirAccess.dir_exists_absolute(SAVE_DIR):
        DirAccess.make_dir_recursive_absolute(SAVE_DIR)

    var path = SAVE_DIR + "/" + filename + ".json"
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        printerr("Failed to open save file for writing: ", path)
        return false

    var data = {"runs": runs, "replay_count": replay_count, "flags": flags}
    file.store_string(JSON.stringify(data))
    file.close()
    print("Saved to:", path)
    return true

func load_from_file(filename: String) -> bool:
    var path = SAVE_DIR + "/" + filename + ".json"
    if not FileAccess.file_exists(path):
        push_warning("Save file not found: " + path)
        return false

    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        printerr("Failed to open save file for read: ", path)
        return false

    var text = file.get_as_text()
    file.close()

    var parsed = JSON.parse_string(text)
    if typeof(parsed) != TYPE_DICTIONARY:
        printerr("Invalid save JSON:", path)
        return false

    runs = parsed.get("runs", [])
    replay_count = parsed.get("replay_count", 0)
    flags = parsed.get("flags", {})
    print("Loaded save:", path)
    return true

func list_saves() -> Array:
    var saves: Array = []
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        return saves
    dir.list_dir_begin()
    var f = dir.get_next()
    while f != "":
        if f.ends_with(".json"):
            saves.append(f.replace(".json", ""))
        f = dir.get_next()
    dir.list_dir_end()
    return saves

func set_flag(key: String, value: bool):
    flags[key] = value

func get_flag(key: String) -> bool:
    return flags.get(key, false)

func end_run():
    # Called when a run is finished to finalize ending and optionally prompt quiz
    var ending_manager = get_node_or_null("/root/EndingManager")
    if ending_manager:
        var ending_id = ending_manager.calculate_ending()
        set_ending(ending_id)
        # Save an autosave for this run (optional name)
        save_to_file("autosave")
        # Trigger external quiz if necessary
        if ending_manager.should_show_quiz():
            print("Player has reached quiz threshold (3 runs). Prompting external quiz.")
            # Optional: open external URL automatically
            # OS.shell_open("https://forms.gle/YOUR_QUIZ_LINK")
