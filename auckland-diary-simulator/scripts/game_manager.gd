extends Node

var dayCustomerCount: int
var dayCount: int = 0
var dayNight: int = 0 # day = 0 night = 1
var moneyAtDayStart: float
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
	ProductManager.setMoney(999)
	dayCount += 1
	dayNight = 0
	dayCustomerCount = 0
	moneyAtDayStart = ProductManager.money
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
		await get_tree().create_timer(3.5).timeout
		if dayCount == 7:
			get_tree().change_scene_to_file("res://scenes/EndingScreen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")
			dayNight = 1;
			moneyAtDayStart = ProductManager.money;

func add_flag(flag: String):
	if flag not in flags:
		flags.append(flag)
	print(str(flags))

func check_flag(flag: String):
	return flag in flags
	
func getDayCount() -> int:
	return dayCount
	
func setDayCount(day: int):
	dayCount = day
	
func getDayNight() -> int:
	return dayNight
	
func setDayNight(day: int):
	dayNight = day
	
func getMoneyStart() -> float:
	return moneyAtDayStart
	
func setMoneyStart(money: float):
	moneyAtDayStart = money
	
func getFlags() -> Array:
	return flags
	
func setFlags(value: Array):
	flags = value
	
func loadDay() -> void:
	if dayNight == 0:
		get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
		moneyAtDayStart = ProductManager.money
		dayCustomerCount = 0
		await get_tree().create_timer(0.1).timeout
		characterSprite = $"../main/NPC/Sprite2D"
		shop_overview_main = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"
		print(str(shop_overview_main))
		NpcManager.spawn_for_day(GameManager.dayCount, shop_overview_main)
	else:
		get_tree().change_scene_to_file("res://scenes/nightScreen.tscn")
