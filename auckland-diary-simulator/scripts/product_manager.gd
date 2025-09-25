extends Node

var total_objects: Array = []
var scanned_objects: Array = []
var bagged_objects: Array = []
var total_price: float

var money: float = 999

var message: String

var object = preload("res://scenes/draggableObject.tscn")
var coin = preload("res://scenes/coin.tscn")
@onready var timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
			await get_tree().create_timer(0.1).timeout
			var coin1 = coin.instantiate()
			coin1.type = 0
			get_tree().current_scene.add_child(coin1)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "money", moneyTotal, 1.0)
			
		total_price = 0
		
		# Reset Objects
		for obj in total_objects:
			obj.queue_free()
		total_objects.clear()
		
		# Next Customer
		GameManager.customerServed()

func spawnNew(purchaseArray: Array):
	var t = get_tree().create_timer(0.1) # 1 second
	await t.timeout
	if purchaseArray.is_empty():
		# Next Customer
		resetScene()
	for item in purchaseArray.size():
		total_objects.append(object.instantiate())
		var i: Array = purchaseArray[item].split(":")
		var keys = total_objects[item].Type.keys()
		var type = keys[int(i[0])]
		total_objects[item].item_type = total_objects[item].Type[type]
		total_objects[item].item_flavour = int(i[1])
		get_tree().current_scene.add_child(total_objects[item])

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
