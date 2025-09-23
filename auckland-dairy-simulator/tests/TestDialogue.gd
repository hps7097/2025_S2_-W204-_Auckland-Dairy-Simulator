# MADE WITH CHATGPT

extends SceneTree

func _init():
	GameState.reset_state()
	DialogueManager.start_dialogue("police_1")
	# Simulate choice
	DialogueManager._on_choice_made({"text":"(Bribe)", "flags_set":["bribed_police"], "effects":{"money":-50}, "next":""})
	assert(GameState.get_flag("bribed_police") == true)
	assert(GameState.money == -50)
	print("Dialogue test passed")
	quit()

func _init2():
	print("--- Running Dialogue Unit Test ---")
	GameState.reset_state()

	var police_dialogue = {
		"npc_id": "police_1",
		"start": "greet",
		"nodes": {
			"greet": {
				"speaker": "Officer",
				"text": "Evening. Reports of illegal items...",
				"choices": [
					{"text":"(Bribe)", "next":"", "flags_set":["bribed_police"], "effects":{"money":-50}}
				]
			}
		}
	}

	var dlg_ui = preload("res://scenes/DialogueUI.tscn").instantiate()
	get_root().add_child(dlg_ui)
	dlg_ui.start(police_dialogue)

	# Simulate making choice
	dlg_ui._on_choice_pressed(police_dialogue["nodes"]["greet"]["choices"][0])

	assert(GameState.get_flag("bribed_police") == true)
	assert(GameState.money == -50)

	print("Dialogue test passed ✅")
	quit()
