#MADE WITH CHATGPT
extends Node
# Optional helper singleton

func check_for_ending() -> String:
	if GameState.day >= 5:
		if GameState.police_rep > GameState.gang_rep:
			return "police_victory"
		elif GameState.gang_rep > GameState.police_rep:
			return "gang_victory"
		else:
			return "neutral"
	return ""
