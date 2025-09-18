extends Node

var dayCustomerCount: int
var dayCount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newDay() -> void:
	dayCount += 1
	dayCustomerCount = 3 + UpgradeManager.upgrades[1]
	customerAppear()

func customerAppear() -> void:
	ProductManager.spawnNew()

func customerServed() -> void:
	dayCustomerCount -= 1
	if dayCustomerCount > 0:
		customerAppear()
	else:
		get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")
