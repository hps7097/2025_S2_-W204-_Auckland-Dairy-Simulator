#MADE WITH CHATGPT
extends CanvasLayer
@onready var npc_label = $Panel/VBoxContainer/NPCName 
@onready var text_label = $Panel/VBoxContainer/DialogueText 
@onready var choices_container = $Panel/VBoxContainer/ChoicesContainer 
@onready var panel = $Panel 
 
var current_dialogue = {} 
var current_node_id = "" 
var manager = null 
 
func show_dialogue(dialogue_data: Dictionary, start_node_id: String, mgr): 
	manager = mgr 
	current_dialogue = dialogue_data 
	panel.visible = true 
	_show_node(start_node_id) 
 
func _show_node(node_id: String): 
	current_node_id = node_id 
	var node = current_dialogue["nodes"].get(node_id, null) 
	if node == null: 
		_end_dialogue() 
		return 
	# display text 
	text_label.bbcode_text = node.get("text","") 
	# clear previous choices 
	for ch in choices_container.get_children(): 
		ch.queue_free() 
	# if choices present, create buttons; else create 'Continue' button or auto-next 
	var choices = node.get("choices", []) 
	if choices.size() > 0: 
		for choice in choices: 
			var btn = preload("res://addons/story/ChoiceButton.tscn").instance() 
			btn.get_node("Button").text = choice.get("text","") 
			btn.connect("pressed", self, "_on_choice_pressed", [choice]) 
			choices_container.add_child(btn) 
	else: 
		# auto-next or show continue/close 
		if node.has("next") and node["next"] != null: 
			var cont = Button.new() 
			cont.text = "Continue" 
			cont.connect("pressed", self, "_on_continue_pressed") 
			choices_container.add_child(cont) 
		else: 
			var close = Button.new() 
			close.text = "Close" 
			close.connect("pressed", self, "_on_close_pressed") 
			choices_container.add_child(close) 
	# notify manager to process effects at display time (or after choice? pick consistent) 
	# We process effects when the node is entered 
	manager.process_node(current_dialogue, node_id) 
 
func _on_choice_pressed(choice: Dictionary): 
	# apply immediate effects (manager already processed node effects) 
	var next_id = choice.get("next", null) 
	var effects = choice.get("effects", []) 
	for e in effects: 
		manager.apply_effect(e) 
	# Record branch choice 
	if next_id: 
		_show_node(next_id) 
	else: 
		_end_dialogue() 
 
func _on_continue_pressed(): 
	var node = current_dialogue["nodes"].get(current_node_id, {}) 
	var next_id = node.get("next", null) 
	if next_id: 
		_show_node(next_id) 
	else: 
		_end_dialogue() 
 
func _on_close_pressed(): 
	_end_dialogue() 
 
func _end_dialogue(): 
	panel.visible = false 
	current_dialogue = {} 
	current_node_id = "" 
