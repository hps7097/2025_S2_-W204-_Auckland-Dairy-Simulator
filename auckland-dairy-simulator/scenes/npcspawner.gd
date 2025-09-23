extends Node2D

@export var npc_scene: PackedScene          # Drag your npc.tscn here
@export var npc_count: int = 4              # Number of NPCs to spawn
@export var path2d_path: NodePath           # Drag your Path2D node here
@export var npc_spacing: float = 80.0       # Distance along path between NPCs

func _ready():
	if path2d_path == NodePath():
		push_error("No Path2D assigned in Inspector!")
		return

	var path2d = get_node(path2d_path)
	if not path2d:
		push_error("Path2D not found at: " + str(path2d_path))
		return

	for i in range(npc_count):
		# Instantiate NPC
		var npc = npc_scene.instantiate()
		get_parent().add_child(npc)  # Add NPC as sibling of spawner

		# Create a new PathFollow2D for this NPC
		var pf = PathFollow2D.new()
		pf.name = "PathFollow2D_" + str(i + 1)
		path2d.add_child(pf)

		# Offset NPC along the path
		pf.progress = i * npc_spacing

		# Assign PathFollow2D to NPC
		npc.path_follow = pf
		npc.global_position = pf.global_position
