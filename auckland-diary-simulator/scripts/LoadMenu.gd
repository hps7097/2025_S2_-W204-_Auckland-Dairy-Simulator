#MADE WITH CHATGPT

extends Control

const MAX_SLOTS := 10
@onready var slot_list := $ScrollContainer/VBoxContainer

func _ready() -> void:
	refresh()

func refresh() -> void:
	slot_list.queue_free_children()
	var saves := SaveManager.list_saves()
	for i in range(1, MAX_SLOTS + 1):
		var btn := Button.new()
		btn.text = "Slot %d" % i
		if i in saves:
			btn.text += " — saved"
		btn.connect("pressed", Callable(self, "_on_slot_pressed").bind(i))
		slot_list.add_child(btn)

func _on_slot_pressed(slot:int) -> void:
	var data := SaveManager.load_game(slot)
	if data.is_empty():
		print("No save in slot %d, starting new game" % slot)
		get_tree().change_scene_to_file("res://scenes/GameScene.tscn")
		return

	# Example: Apply player position or game flags (adjust for your game)
	if data.has("player_pos") and get_tree().has_current_scene():
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if player:
			player.global_position = data["player_pos"]

	if data.has("flags") and Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		gm.flags = data["flags"]

	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")
