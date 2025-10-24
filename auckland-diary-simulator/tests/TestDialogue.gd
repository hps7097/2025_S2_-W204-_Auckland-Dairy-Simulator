# MADE WITH CHATGPT
extends "res://addons/gut/test.gd"

func before_each():
    GameState.reset_state()

func test_dialogue_bribe_sets_flag_and_money():
    # Start dialogue (ok with default empty purchases now)
    DialogueManager.start_dialogue("police_1")

    # Simulate choosing the “Bribe” option
    var choice := {
        "text": "(Bribe)",
        "flags_set": ["bribed_police"],
        "effects": {"money": -50},
        "next": ""
    }
    DialogueManager._on_choice_made(choice)

    assert_true(GameState.get_flag("bribed_police"))
    assert_eq(GameState.money, -50)

