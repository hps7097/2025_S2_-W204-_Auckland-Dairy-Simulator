extends Node

var total_objects: Array = []
var scanned_objects: Array = []
var bagged_objects: Array = []
var total_price: float

var money: float = 67.70

var message: String

var object = preload("res://scenes/draggableObject.tscn")
var coin = preload("res://scenes/coin.tscn")
@onready var timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		if current_scene.scene_file_path == ("res://scenes/dayScreen.tscn"):
			spawnNew()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_scene = get_tree().current_scene
	if current_scene:
		if total_objects.size() != 0 && total_objects.size() == bagged_objects.size() && get_tree().current_scene.scene_file_path == ("res://scenes/dayScreen.tscn"):
			message = "BAGGING DONE!"
			resetScene()

# """

func resetScene():
		# Reset Arrays
		scanned_objects.clear()
		bagged_objects.clear()
		MouseManager.z_index_order.clear()
		var moneyTotal = money + total_price
		
		# Income Animation
		for i in range(floor(total_price)):
			var t = get_tree().create_timer(0.1) # 1 second
			await t.timeout
			get_tree().current_scene.add_child(coin.instantiate())
		while money < moneyTotal:
			var t = get_tree().create_timer(0.01) # 1 second
			await t.timeout
			money += 0.1
			
		total_price = 0
		money = moneyTotal
		
		var t = get_tree().create_timer(1.0) # 1 second
		await t.timeout
		
		# Reset Objects
		for obj in total_objects:
			obj.queue_free()
		total_objects.clear()
		
		# Change Scene from day to night
		var nightScene = preload("res://scenes/nightScreen.tscn")
		# get_tree().change_scene_to_packed(nightScene)
		
		# Spawn more items
		spawnNew()

func spawnNew():
	var t = get_tree().create_timer(0.1) # 1 second
	await t.timeout
	for i in range(randi_range(1, 3)):
		total_objects.append(object.instantiate())
		# For choosing item type. Delete code in draggableObject.gd reset_item() if using
		# total_objects[i].item_type = total_objects[i].Type.PIE
		get_tree().current_scene.add_child(total_objects[i])

func scan(value: Node2D):
	if scanned_objects.has(value):
		message = "ALREADY SCANNED"
		return
	scanned_objects.append(value)
	message = "SCANNED ITEM"
	total_price += value.type_values[value.item_type]

func bag(value: Node2D):
	if bagged_objects.has(value):
		return
	bagged_objects.append(value)

func unbag(value: Node2D):
	if !bagged_objects.has(value):
		return
	bagged_objects.erase(value)
