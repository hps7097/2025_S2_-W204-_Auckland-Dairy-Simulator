# MADE WITH CHATGPT
# tests/test_save_load.gd
extends "res://addons/gut/test.gd"

var gs

func before_each() -> void:
    gs = load("res://scripts/GameState.gd").new()
    # Ensure we have one save to list
    gs.start_new_run()
    gs.set_ending("save_list_test")
    gs.save_to_file("test_save_for_listing")

func test_list_saves_contains_testfile() -> void:
    var saves = gs.list_saves()
    assert_true("test_save_for_listing" in saves)

func test_load_saved_file_works() -> void:
    var gs2 = load("res://scripts/GameState.gd").new()
    assert_true(gs2.load_from_file("test_save_for_listing"))

