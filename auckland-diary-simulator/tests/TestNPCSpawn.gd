# MADE WITH CHATGPT
extends GutTest

func test_police_spawn_condition():
	GameState.reset()
	GameState.set_flag("illegal_sold", true)
	var npc_manager = preload("res://scripts/npc_manager.gd").new()
	var npc = npc_manager.spawn_npc("police")
	assert_not_null(npc)
