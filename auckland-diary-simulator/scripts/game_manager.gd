extends Node

var dayCustomerCount: int
var dayCount: int = 1
var flags: Array = []
var customerAtDesk: bool = false

@onready var shop_overview_main: Node = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"
@onready var characterSprite: Sprite2D = $"../main/NPC/Sprite2D"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func newDay() -> void:
	dayCount += 1
	await get_tree().create_timer(0.1).timeout
	characterSprite = $"../main/NPC/Sprite2D"
	shop_overview_main = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"
	NpcManager.spawn_for_day(GameManager.dayCount, shop_overview_main)

func customerAppear(dialogue_id: String, purchases: Array) -> void:
	customerAtDesk = true
	characterSprite.enter_scene()
	await get_tree().create_timer(1.0).timeout
	DialogueManager.start_dialogue(dialogue_id, purchases)

func customerServed() -> void:
	dayCustomerCount -= 1
	customerAtDesk = false
	characterSprite.leave_scene()
	if dayCustomerCount <= 0:
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")

# --- FLAG SYSTEM ---
func add_flag(flag: String):
	if flag not in flags:
		flags.append(flag)
	print("Flag added:", flag, "| Current flags:", flags)

func check_flag(flag: String) -> bool:
	return flag in flags
