extends Control


signal load_requested(slot)


onready var slot_list = $ScrollContainer/SlotList
onready var load_confirm = $LoadConfirm # optional confirmation dialog


func _ready():
refresh()


func refresh():
slot_list.clear()
var saves = SaveManager.list_saves()
for i in range(1, SaveManager.MAX_SLOTS + 1):
var btn = Button.new()
btn.name = "slot_%d" % i
btn.text = "Slot %d" % i
btn.connect("pressed", self, "_on_slot_pressed", [i])
slot_list.add_child(btn)
# If a save exists, show extra marker
for s in saves:
if s.slot == i:
btn.text = "Slot %d — saved" % i
break


func _on_slot_pressed(slot:int):
# optional: ask for confirmation / show details
var data = SaveManager.load(slot)
if data == null:
# No save — maybe offer to start a new game or warn
get_tree().change_scene("res://scenes/GameScene.tscn")
return
# apply loaded state
_apply_state_to_game(data)


func _apply_state_to_game(state:Dictionary) -> void:
# Example: assume state contains player position and variables
# This function must be adapted to your game's state layout
var player = get_node_or_null("/root/Game/Player")
if player and state.has("player_pos"):
player.global_position = state["player_pos"]
if state.has("variables"):
for k,v in state["variables"]:
GlobalVars.set(k, v) # replace with your variable manager
# continue loading other parts
