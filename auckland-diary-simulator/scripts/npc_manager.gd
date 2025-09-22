extends Node

var counterFree: bool = true

var npcScene = preload("res://scenes/npc.tscn")
var shop_overview_main: Node2D

func _ready() -> void:
	pass

func run() -> void:
	var t = get_tree().create_timer(0.1) # 1 second
	await t.timeout
	shop_overview_main = $"../main/UI/SubViewportContainer/SubViewport/shopOverviewMain"
	print("Manager Active")
	print("Children of this node:", get_children())
	print("Full scene tree:")
	get_tree().get_root().print_tree_pretty()
	
	print("Manager Active")
	if shop_overview_main == null:
		print("shop_overview_main is NULL — check the node path!")
		return
	
	spawn_loop()

func spawn_loop() -> void:
	while true:
		print("Spawning")
		var npc = npcScene.instantiate()
		npc.position = Vector2(-330, 0)
		shop_overview_main.add_child(npc)
		await get_tree().create_timer(2.0).timeout
		
