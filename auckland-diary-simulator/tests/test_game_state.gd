extends "res://addons/gut/test.gd"

var gs

func before_each():
    gs = load("res://scripts/GameState.gd").new()

func test_replay_tracking():
    gs.start_new_run()
    gs.record_choice("feed_cow")
    gs.set_ending("good")
    assert_eq(gs.runs.size(), 1)
    assert_eq(gs.runs[0]["ending"], "good")

func test_save_and_load_cycle():
    gs.start_new_run()
    gs.record_choice("sleep")
    gs.set_ending("neutral")
    var save_ok = gs.save_to_file("unittest_save")
    assert_true(save_ok)
    var gs2 = load("res://scripts/GameState.gd").new()
    var load_ok = gs2.load_from_file("unittest_save")
    assert_true(load_ok)
    assert_eq(gs2.runs.size(), 1)

func test_flag_handling():
    gs.set_flag("gang_path", true)
    assert_true(gs.get_flag("gang_path"))
    assert_false(gs.get_flag("lawful_path"))
