# tests/test_integration.gd
extends "res://addons/gut/test.gd"

# This test assumes EndingManager and GameState are autoloaded
# and present at /root/EndingManager and /root/GameState

func before_each() -> void:
    # Reset GameState to known state (if available)
    if Engine.has_singleton("GameState"):
        GameState.runs = []
        GameState.replay_count = 0
        GameState.flags.clear()
    # Reset EndingManager history if accessible
    if Engine.has_singleton("EndingManager"):
        EndingManager.history.clear()
        EndingManager.current_choices.clear()

func test_integration_simple_run() -> void:
    # Create a simulated run with some choices
    EndingManager.start_new_run()
    EndingManager.register_choice("bribe_police", {"weight": -3})
    EndingManager.register_choice("help_neighbor", {"weight": 3})
    EndingManager.register_choice("feed_cows", {"weight": 2})

    var ending := EndingManager.calculate_ending()
    assert_true(ending in ["good", "neutral", "bad"])
    # verify GameState recorded an ending when set via EndingManager
    assert_true(GameState.runs.size() >= 1)

