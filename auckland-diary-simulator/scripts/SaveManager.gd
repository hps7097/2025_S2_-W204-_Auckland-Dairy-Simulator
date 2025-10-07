#MADE WITH CHATGPT

extends Node


const SAVE_DIR := "user://saves/"
const MAX_SLOTS := 10


func _ready():
var dir = Directory.new()
if not dir.dir_exists(SAVE_DIR):
dir.make_dir_recursive(SAVE_DIR)


# state should be a Dictionary serializable to JSON
func save(slot:int, state:Dictionary) -> bool:
slot = clamp(slot, 1, MAX_SLOTS)
var file = File.new()
var path = SAVE_DIR + "save_%d.json" % slot
var err = file.open(path, File.WRITE)
if err != OK:
push_error("SaveManager: cannot open file "%s"" % path)
return false
file.store_string(to_json(state))
file.close()
return true


# returns Dictionary or null on failure
func load(slot:int) -> Dictionary:
slot = clamp(slot, 1, MAX_SLOTS)
var path = SAVE_DIR + "save_%d.json" % slot
var file = File.new()
if not file.file_exists(path):
return null
var err = file.open(path, File.READ)
if err != OK:
push_error("SaveManager: cannot open file for read: %s" % path)
return null
var text = file.get_as_text()
file.close()
var parsed = parse_json(text)
if typeof(parsed) != TYPE_DICTIONARY:
push_error("SaveManager: corrupted save file: %s" % path)
return null
return parsed


func list_saves() -> Array:
var dir = Directory.new()
var saves = []
if dir.open(SAVE_DIR) != OK:
return saves
dir.list_dir_begin(true, true)
var fname = dir.get_next()
while fname != "":
if fname.ends_with('.json'):
return int(a["slot"]) - int(b["slot"])
