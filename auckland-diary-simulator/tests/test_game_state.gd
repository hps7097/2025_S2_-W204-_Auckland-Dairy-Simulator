# MADE WITH CHATGPT

# tests/test_game_state.gd
extends "res://addons/gut/test.gd"

var gs

func before_each() -> void:
    gs = load("res://scripts/GameState.gd").new()

func test_start_record_and_end() -> void:
    gs.start_new_run()
    gs.record_choice("test_choice")
    gs.record_event("test_event")
    gs.set_ending("test_end")
    assert_eq(gs.runs.size(), 1)
    assert_eq(gs.runs[0]["ending"], "test_end")

func test_save_and_load_cycle() -> void:
    gs.start_new_run()
    gs.set_ending("save_test_end")
    assert_true(gs.save_to_file("unittest_save"))
    var gs2 = load("res://scripts/GameState.gd").new()
    assert_true(gs2.load_from_file("unittest_save"))
    assert_eq(gs2.runs.size(), 1)

