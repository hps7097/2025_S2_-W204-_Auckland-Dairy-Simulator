# MADE WITH CHATGPT
extends SceneTree

func _init():
	print("--- Running EndingManager tests ---")
	EndingManager.current_choices.clear()
	EndingManager.history.clear()

	# Register choices with positive score
	EndingManager.register_choice("help_farmer", {"weight": 3})
	EndingManager.register_choice("donate_milk", {"weight": 3})

	var ending_good := EndingManager.calculate_ending()
	assert(ending_good == "good", "Expected 'good' ending, got %s" % ending_good)
	print("Good ending passed ✅")

	# Register negative choices
	EndingManager.register_choice("steal", {"weight": -3})
	EndingManager.register_choice("lie", {"weight": -4})

	var ending_bad := EndingManager.calculate_ending()
	assert(ending_bad == "bad", "Expected 'bad' ending, got %s" % ending_bad)
	print("Bad ending passed ✅")

	# Fill history for quiz
	for i in range(EndingManager.QUIZ_AFTER - 1):
		EndingManager.history.append({"ending": "neutral"})

	assert(EndingManager.should_show_quiz() == true, "Quiz trigger should be true")
	print("Quiz trigger test ✅")

	print("All EndingManager tests passed 🎉")
	quit()
