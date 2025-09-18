#MADE WITH CHATGPT
extends Node 

var music_volume := 0.8 
var sfx_volume := 0.8 
var dialogue_speed := 1.0 
var graphics_quality := "medium" 

func _ready(): 
	# load persisted settings if present 
	var mv = SaveManager.load_setting("music_volume", music_volume) 
	var sv = SaveManager.load_setting("sfx_volume", sfx_volume) 
	var ds = SaveManager.load_setting("dialogue_speed", dialogue_speed) 
	var gq = SaveManager.load_setting("graphics_quality", graphics_quality) 
	music_volume = float(mv) 
	sfx_volume = float(sv) 
	dialogue_speed = float(ds) 
	graphics_quality = str(gq) 

func persist_all(): 
	SaveManager.save_setting("music_volume", music_volume) 
	SaveManager.save_setting("sfx_volume", sfx_volume) 
	SaveManager.save_setting("dialogue_speed", dialogue_speed) 
	SaveManager.save_setting("graphics_quality", graphics_quality) 

 
