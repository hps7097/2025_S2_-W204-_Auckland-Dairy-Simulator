#MADE WITH CHATGPT
extends Node

# Simple manual test runner that works without GameState.gd
# It fakes the old GameState behavior for testing.

var fake_money := 0
var fake_flags := {}
var fake_upgrades := []

func _ready():
	print("\n--- Running Manual Unit Tests ---")
	
	var dialogue_result = run_dialogue_test()
	var upgrade_result = run_upgrade_test()
	
	print("\n==============================")
	if dialogue_result and upgrade_result:
		print("✅ ALL TESTS PASSED ✅")
	else:
		print("❌ SOME TESTS FAILED ❌")
	
	get_tree().quit()


# ------------------------
# Dialogue Test
# ------------------------
func run_dialogue_test() -> bool:
	print("\nRunning Dialogue Test...")
	
	# Simulate a dialogue choice that affects money and sets a flag
	fake_money = 100
	fake_flags.clear()

	var choice = {
		"text": "(Bribe)",
		"flags_set": ["bribed_police"],
		"effects": {"money": -50}
	}

	# Apply choice effects
	for flag in choice["flags_set"]:
		fake_flags[flag] = true

	if "money" in choice["effects"]:
		fake_money += choice["effects"]["money"]

	# Assertions
	var pass_flags = fake_flags.has("bribed_police")
	var pass_money = fake_money == 50

	if pass_flags and pass_money:
		print("✅ Dialogue test passed.")
		return true
	else:
		print("❌ Dialogue test failed.")
		print("- Expected flag 'bribed_police': ", pass_flags)
		print("- Expected money: 50, got: ", fake_money)
		return false


# ------------------------
# Upgrade Test
# ------------------------
func run_upgrade_test() -> bool:
	print("\nRunning Upgrade Test...")

	fake_upgrades.clear()
	add_upgrade("fast_scanner")

	if has_upgrade("fast_scanner"):
		print("✅ Upgrade test passed.")
		return true
	else:
		print("❌ Upgrade test failed.")
		return false


func add_upgrade(upgrade_name: String):
	if not has_upgrade(upgrade_name):
		fake_upgrades.append(upgrade_name)


func has_upgrade(upgrade_name: String) -> bool:
	return upgrade_name in fake_upgrades
