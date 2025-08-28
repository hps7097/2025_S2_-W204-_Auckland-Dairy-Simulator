# MouseManager.gd (autoload this as a singleton)
extends Node

var is_dragging = false
var current_dragged : Node2D = null
var top_z_index : int = 0
