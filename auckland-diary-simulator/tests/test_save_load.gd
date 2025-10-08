# MADE WITH CHATGPT
extends SceneTree

func _init():
	print("--- Running Save/Load test ---")
	# Ensure clean state
	var state := {
		"player_pos": Vector2(100, 200),
		"flags": {"bribed_police": true}
	}

	# Save
	var saved := SaveManager.save_game(1, state)
	assert(saved == true, "Failed to save game")

	# Load
	var loaded := SaveManager.load_game(1)
	assert(typeof(loaded) == TYPE_DICTIONARY, "Loaded data not a dictionary")

	assert(loaded.has("player_pos"))
	assert(loaded["player_pos"] == Vector2(100, 200))

	assert(loaded.has("flags"))
	assert(loaded["flags"]["bribed_police"] == true)

	print("Save/Load basic data ✅")

	# List saves
	var saves := SaveManager.list_saves()
	assert(1 in saves)
	print("List saves works ✅")

	print("All Save/Load tests passed 🎉")
	quit()
