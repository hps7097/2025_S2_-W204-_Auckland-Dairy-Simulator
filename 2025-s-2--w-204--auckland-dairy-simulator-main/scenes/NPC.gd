#MADE WITH CHATGPT
extends Area2D
class_name NPC

@export var npc_id := ""
@export var dialogue_id := ""

func _ready() -> void:
	input_event.connect(_on_input_event)

#func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		if dialogue_id != "":
#			DialogueManager.start(dialogue_id)

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		DialogueManager.start(dialogue_id)
