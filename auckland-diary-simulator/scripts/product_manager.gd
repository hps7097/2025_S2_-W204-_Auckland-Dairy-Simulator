extends Node

var scanned_objects: Array = []
var bagged_objects: Array = []
var message: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
