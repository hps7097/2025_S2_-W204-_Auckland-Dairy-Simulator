extends Node

var upgrades: Array = [0, 0, 0]

func upgrade(type: int) -> void:
	upgrades.set(type, upgrades[type] + 1)
	if type == 0 && upgrades[type] > 5:
		upgrades.set(type, 5)
	if type == 1 && upgrades[type] > 3:
		upgrades.set(type, 3)
	if type == 2 && upgrades[type] > 4:
		upgrades.set(type, 4)

func getUpgrade(type: int) -> int:
	return upgrades[type]
