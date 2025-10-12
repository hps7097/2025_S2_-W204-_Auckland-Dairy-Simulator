# MADE WITH CHATGPT

extends Node

var runs: Array = []
var current_run: Dictionary = {}
var replay_count: int = 0
const SAVE_DIR := "user://saves"

# Optional helper for flexible state flags
var flags := {}

func start_new_run():
    reset_flags()
    current_run = {"choices": [], "events": [], "ending": ""}
    runs.append(current_run)
    replay_count += 1

func reset_flags():
    flags.clear()

func record_choice(choice_id: String):
    current_run["choices"].append(choice_id)

func record_event(event_id: String):
    current_run["events"].append(event_id)

func set_ending(ending_id: String):
    current_run["ending"] = ending_id
    print("Run " + str(replay_count) + " ended with ending: " + ending_id)

func save_to_file(filename: String) -> bool:
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        DirAccess.make_dir_recursive_absolute(SAVE_DIR)
    var data = {"runs": runs, "replay_count": replay_count}
    var file := FileAccess.open(SAVE_DIR + "/" + filename + ".json", FileAccess.WRITE)
    file.store_string(JSON.stringify(data))
    file.close()
    return true

func load_from_file(filename: String) -> bool:
    var path = SAVE_DIR + "/" + filename + ".json"
    if not FileAccess.file_exists(path):
        push_warning("Save file not found: " + path)
        return false
    var file := FileAccess.open(path, FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())
    file.close()
    runs = data.get("runs", [])
    replay_count = data.get("replay_count", 0)
    return true

func list_saves() -> Array:
    var saves = []
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
    # Finalize and record the ending
    var ending_manager = get_node_or_null("/root/EndingManager")
    if ending_manager:
        var ending_id = ending_manager.calculate_ending()
        set_ending(ending_id)
        
        # If player has reached 3 playthroughs, trigger external quiz prompt
        if ending_manager.should_show_quiz():
            print("🎉 You've completed 3 playthroughs! Please complete the replay experience quiz.")
            OS.shell_open("https://forms.gle/your_quiz_link_here") # Replace with your quiz link
