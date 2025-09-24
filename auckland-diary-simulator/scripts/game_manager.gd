extends Node

var dayCustomerCount: int
var dayCount: int = 0
var flags: Array = []

var customerAtDesk: bool = false

@onready var shop_overview_main: Node = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"

@onready var characterSprite: Sprite2D = $"../main/NPC/Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")
		
func _process2(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		$PauseMenu.toggle()

func add_flag(flag: String):
	if flag not in flags:
		flags.append(flag)
	print(str(flags))

func check_flag(flag: String):
	return flag in flags
