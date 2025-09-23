#MADE WITH CHATGPT
extends Node

var day := 1
var money := 0
var police_rep := 0
var gang_rep := 0
var flags: Dictionary = {}

func to_dict() -> Dictionary:
	return {
		"day": day,
		"money": money,
		"police_rep": police_rep,
		"gang_rep": gang_rep,
		"flags": flags
	}

func load_from_dict(data: Dictionary) -> void:
	day = data.get("day", 1)
	money = data.get("money", 0)
	police_rep = data.get("police_rep", 0)
	gang_rep = data.get("gang_rep", 0)
	flags = data.get("flags", {})


 
