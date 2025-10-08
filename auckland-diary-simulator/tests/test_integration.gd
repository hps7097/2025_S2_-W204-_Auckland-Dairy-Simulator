# MADE WITH CHATGPT
extends SceneTree

func _init():
	print("--- Running Integration test ---")
	GameState.reset_state() if Engine.has_singleton("GameState") else null

	# Simulate choices in one playthrough
	EndingManager.current_choices.clear()
	EndingManager.register_choice("bribe_police", {"weight": -3})
	EndingManager.register_choice("help_neighbor", {"weight": 3})
	EndingManager.register_choice("feed_cows", {"weight": 2})

	var ending := EndingManager.calculate_ending()
	print("Determined ending: ", ending)
	assert(ending in ["good", "bad", "neutral"])

	# Save current ending and state
	var state := {
		"last_ending": ending,
		"flags": {"test_flag": true}
	}
	var ok := SaveManager.save_game(1, state)
	assert(ok)

	# Load back
	var loaded := SaveManager.load_game(1)
	assert(loaded.has("last_ending"))
	assert(loaded["last_ending"] == ending)
	assert(loaded["flags"]["test_flag"] == true)

	print("Integration test passed ✅")
	quit()
