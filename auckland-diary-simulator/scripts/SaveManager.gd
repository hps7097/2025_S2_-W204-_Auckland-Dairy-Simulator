# MADE WITH CHATGPT

extends Node

const SAVE_FMT := "user://save_slot_%d.json"

func save_game(slot: int = 1) -> bool:
	var data := {
		"day": GameManager.dayCount,
		"money": ProductManager.money,
		"flags": GameManager.flags,
		"upgrades": UpgradeManager.upgrades,
	}
	var path := SAVE_FMT % slot
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("Failed to open save file for writing: %s" % path)
		return false
	f.store_string(JSON.stringify(data))
	f.close()
	return true

func load_game(slot: int = 1) -> bool:
	var path := SAVE_FMT % slot
	if not FileAccess.file_exists(path):
		return false
	var f = FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if parsed.error != OK:
		push_error("Save JSON parse error")
		return false
	var d = parsed.result
	GameManager.dayCount = int(d.get("day", 1))
	ProductManager.money = int(d.get("money", 0))
	GameManager.flags = d.get("flags", {})
	UpgradeManager.upgrades = d.get("upgrades", {})
	return true
