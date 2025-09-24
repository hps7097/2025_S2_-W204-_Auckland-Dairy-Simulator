extends Node

var dayCustomerCount: int
var dayCount: int = 0

@onready var characterSprite: Sprite2D = $"../main/NPC/Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func newDay() -> void:
	dayCount += 1
	dayCustomerCount = 3 + UpgradeManager.getUpgrade(1)
	await get_tree().create_timer(0.1).timeout
	characterSprite = $"../main/NPC/Sprite2D"
	customerAppear()

func customerAppear() -> void:
	characterSprite.enter_scene()
	await get_tree().create_timer(1.0).timeout
	ProductManager.spawnNew()
	NpcManager.run()

func customerServed() -> void:
	dayCustomerCount -= 1
	characterSprite.leave_scene()
	await get_tree().create_timer(2.0).timeout
	if dayCustomerCount > 0:
		customerAppear()
	else:
		get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")
