# MADE WITH CHATGPT
extends "res://addons/gut/test.gd"

func before_each():
    GameState.reset_state()

func test_add_upgrade():
    GameState.add_upgrade("fast_scanner")
    assert_true(GameState.has_upgrade("fast_scanner"))

