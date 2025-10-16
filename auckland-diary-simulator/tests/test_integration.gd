# MADE WITH CHATGPT
extends "res://addons/gut/test.gd"

func test_game_starts_and_saves():
	var gs = GameState.new()
	gs.start_new_run()
	gs.record_choice("test_choice")
	gs.set_ending("neutral")
	assert_eq(gs.current_run["ending"], "neutral")
	assert_true(gs.save_to_file("testsave"))


