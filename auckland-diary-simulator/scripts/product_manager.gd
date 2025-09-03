extends Node

var total_objects: Array = []
var scanned_objects: Array = []
var bagged_objects: Array = []
var message: String

var object = preload("res://scenes/draggableObject.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnNew()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if total_objects.size() == bagged_objects.size():
		print("Bagging Done!")
		message = "BAGGING DONE!"
		
		# Reset Arrays
		scanned_objects.clear()
		bagged_objects.clear()
		MouseManager.z_index_order.clear()
		
		# Reset Objects
		for obj in total_objects:
			obj.queue_free()
		total_objects.clear()
		
		# Spawn more items
		spawnNew()


func spawnNew():
	for i in range(randi_range(1, 3)):
		total_objects.append(object.instantiate())
		get_tree().current_scene.add_child(total_objects[i])

func scan(value: Node2D):
	if scanned_objects.has(value):
		message = "ALREADY SCANNED"
		return
	scanned_objects.append(value)
	message = "SCANNED ITEM"

func bag(value: Node2D):
	if bagged_objects.has(value):
		return
	bagged_objects.append(value)

func unbag(value: Node2D):
	if !bagged_objects.has(value):
		return
	bagged_objects.erase(value)
