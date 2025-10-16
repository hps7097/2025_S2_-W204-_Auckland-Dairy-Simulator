# MADE WITH CHATGPT
extends "res://addons/gut/test.gd"

func test_save_and_load_cycle():
	var gs = GameState.new()
	gs.start_new_run()
	gs.record_choice("test_choice")
	gs.set_ending("neutral")
	gs.save_to_file("temp_test")
	
	var gs2 = GameState.new()
	var ok = gs2.load_from_file("temp_test")
	assert_true(ok)
	assert_eq(gs2.runs.size(), 1)


