# MADE WITH CHATGPT
extends Control

@onready var npc_holder: Node = $NPC_Holder # Add a Node2D/Control in your dayScreen to hold NPCs
@onready var npc_manager_node: Node = $NPCManager
@onready var emblem: TextureRect = $PathEmblem
@onready var hud_icon: TextureRect = $HUD/BranchIcon

func _ready() -> void:
	# spawn conditionally for today's day
	npc_manager_node.spawn_for_day(GameState.current_day, npc_holder)

func _process(_delta: float) -> void:
	# Update emblem on the store wall
	if GameState.get_flag("gang_path"):
		emblem.texture = preload("res://assets/_GangEmblem.png")
	elif GameState.get_flag("lawful_path"):
		emblem.texture = preload("res://assets/_LawEmblem.png")
	else:
		emblem.texture = null
	
	# Update HUD icon to show current branch
	if GameState.get_flag("gang_ally"):
		hud_icon.texture = preload("res://assets/gang.png")
	elif GameState.get_flag("bribed_police"):
		hud_icon.texture = preload("res://assets/corrupt.png")
	else:
		hud_icon.texture = preload("res://assets/lawful.png")
