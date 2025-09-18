#MADE WITH CHATGPT
extends Node 

var save_path := "user://savegame.cfg" 

func save_game(dict_data: Dictionary) -> bool: 
	var cfg = ConfigFile.new() 
	for k in dict_data.keys(): 
		cfg.set_value("game", str(k), dict_data[k]) 
	var err = cfg.save(save_path)
	return err == OK 

func load_game() -> Dictionary: 
	var cfg = ConfigFile.new()
	var err = cfg.load(save_path)
	var out = {} 
	if err == OK:
		var keys = cfg.get_section_keys("game") 
		for k in keys: 
			out[k] = cfg.get_value("game", k) 
	return out 

func save_setting(key: String, val) -> bool: 
	var cfg = ConfigFile.new() 
	var err = cfg.load("user://settings.cfg") 
	cfg.set_value("settings", key, val) 
	return cfg.save("user://settings.cfg") == OK 

func load_setting(key: String, default=null): 
	var cfg = ConfigFile.new() 
	if cfg.load("user://settings.cfg") != OK: 
		return default 
	return cfg.get_value("settings", key, default) 
