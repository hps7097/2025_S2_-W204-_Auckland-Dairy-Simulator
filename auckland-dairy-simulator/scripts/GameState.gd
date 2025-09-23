# MADE WITH CHATGPT
# GameState.gd
extends Node

## Persistent player state
var money: int = 0
var flags: Dictionary = {}        # story flags, e.g. {"gang_path": true}
var upgrades: Array = []          # e.g. ["scanner_v2", "fast_cashier"]

signal money_changed(new_value: int)
signal flag_changed(flag: String, value)
signal upgrade_added(upgrade: String)

func _ready():
	print("GameState ready: money=%s, flags=%s" % [money, flags])

# --- Money Handling ---
func add_money(amount: int):
	money += amount
	emit_signal("money_changed", money)

func remove_money(amount: int):
	money = max(0, money - amount)
	emit_signal("money_changed", money)

# --- Flags ---
func set_flag(flag: String, value):
	flags[flag] = value
	emit_signal("flag_changed", flag, value)

func get_flag(flag: String, default_value = false):
	return flags.get(flag, default_value)

# --- Upgrades ---
func add_upgrade(upgrade: String):
	if not upgrades.has(upgrade):
		upgrades.append(upgrade)
		emit_signal("upgrade_added", upgrade)

func has_upgrade(upgrade: String) -> bool:
	return upgrades.has(upgrade)

# --- Reset for New Game ---
func reset():
	money = 0
	flags.clear()
	upgrades.clear()
