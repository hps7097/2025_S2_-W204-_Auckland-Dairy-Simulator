#MADE WITH CHATGPT
extends Node

const FILE := "user://options.cfg"

var music_vol: float = 0.8
var sfx_vol: float = 0.8
var dialogue_speed: float = 1.0
var graphics_quality: String = "Medium"

func save() -> void:
	var cfg = ConfigFile.new()
	cfg.set_value("audio", "music", music_vol)
	cfg.set_value("audio", "sfx", sfx_vol)
	cfg.set_value("ui", "dialogue_speed", dialogue_speed)
	cfg.set_value("graphics", "quality", graphics_quality)
	cfg.save(FILE)

func load() -> void:
	var cfg = ConfigFile.new()
	if cfg.load(FILE) == OK:
		music_vol = cfg.get_value("audio", "music", 0.8)
		sfx_vol = cfg.get_value("audio", "sfx", 0.8)
		dialogue_speed = cfg.get_value("ui", "dialogue_speed", 1.0)
		graphics_quality = cfg.get_value("graphics", "quality", "Medium")
