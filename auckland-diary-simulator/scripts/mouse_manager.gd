# MouseManager.gd (autoload this as a singleton)
extends Node

var is_dragging = false
var is_hovering = false
var current_dragged : Node2D = null
var top_z_index : int = 0

var z_index_order: Array = []

var selectScanner = false

func push(value: Node2D):
	if z_index_order.has(value):
		z_index_order.erase(value)
	z_index_order.append(value)
	
var intersections
func pick_top_object(position : Vector2, layer_mask = 1) -> Node2D:
	var space_state = get_tree().current_scene.get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()  
	params.position = position  
	params.collide_with_areas = true  
	intersections  = space_state.intersect_point(params)
	
	if intersections.is_empty():
		return null
	# Sort by z_index descending to get the topmost
	var result
	for obj in z_index_order:
		for area in intersections:
			if area.collider == obj:
				result = obj
	return result

func signalAllObjects() -> void:
	for obj in z_index_order:
		obj.get_parent().check_top()
