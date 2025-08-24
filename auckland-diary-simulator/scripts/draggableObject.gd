extends Node2D

var draggable = false
var is_inside_dropable = false
var is_inside_till = true
var is_inside_desk = false
var is_hovering_placeable = true
var body_ref
var offset: Vector2
var initialPos: Vector2
var scaleBy: float = 1
@onready var drop_shadow: Sprite2D = $DropShadow
@onready var centre_area: Area2D = $CentreArea
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.region_rect = Rect2(128 * randi_range(0, 3), 0, 128, 128)  # (x, y, w, h)
	scale = Vector2(scaleBy, scaleBy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			z_index = 1
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			MouseManager.is_dragging = true
			var tweenShadowAlpha = get_tree().create_tween()
			var tweenShadowPos = get_tree().create_tween()
			tweenShadowAlpha.tween_property(drop_shadow, "modulate", Color(1, 1, 1, 0.3), 0.2).set_ease(Tween.EASE_OUT)
			tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,20 + 70 / scaleBy), 0.2).set_ease(Tween.EASE_OUT)
			
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			
		elif Input.is_action_just_released("click"):
			MouseManager.is_dragging = false
			var tween = get_tree().create_tween()
			var tweenShadowAlpha = get_tree().create_tween()
			var tweenShadowPos = get_tree().create_tween()
			tweenShadowAlpha.tween_property(drop_shadow, "modulate", Color(1, 1, 1, 0), 0.2).set_ease(Tween.EASE_OUT)
			tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,35), 0.2).set_ease(Tween.EASE_OUT)
			
			# Tween location depending if dropped in a snappable area, the table, or nothing
			if is_inside_dropable:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			elif not is_inside_desk && not is_inside_till:
				tween.tween_property(self, "global_position", initialPos, 0.1).set_ease(Tween.EASE_IN)
			else:
				tween.tween_property(self, "position", position + Vector2(0, 50), 0.2).set_ease(Tween.EASE_OUT)
	elif MouseManager.is_dragging:
		z_index = 0
			

func _on_area_2d_mouse_entered() -> void:
	if !MouseManager.is_dragging:
		draggable = true
		scale = Vector2(scaleBy + 0.05, scaleBy + 0.05)

func _on_area_2d_mouse_exited() -> void:
	if !MouseManager.is_dragging:
		draggable = false
		scale = Vector2(scaleBy, scaleBy)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.WEB_GRAY, 1)
		body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		body.modulate = Color(Color.LIGHT_GRAY, 0.7)
			
func rescale():
	var tweenShadowPos = get_tree().create_tween()
	var tweenScale = get_tree().create_tween()
	var tweenScale2 = get_tree().create_tween()
	tweenShadowPos.tween_property(drop_shadow, "position", Vector2(0,20 + 70 / scaleBy), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale.tween_property(self, "scale", Vector2(scaleBy + 0.05, scaleBy + 0.05), 0.1).set_ease(Tween.EASE_OUT)
	tweenScale2.tween_property(centre_area, "global_scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN)


func _on_hover_check_area_entered(area: Area2D) -> void:
	if area.is_in_group('till') || area.is_in_group('desk') :
		is_hovering_placeable = true

func _on_hover_check_area_exited(area: Area2D) -> void:
		is_hovering_placeable = false


func _on_centre_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = true
		scaleBy = 1
		rescale()
	elif area.is_in_group('desk'):
		is_inside_desk = true
		scaleBy = 2
		rescale()


func _on_centre_area_area_exited(area: Area2D) -> void:
	if area.is_in_group('till'):
		is_inside_till = false
		if is_inside_desk:
			scaleBy = 2
			rescale()
	if area.is_in_group('desk'):
		is_inside_desk = false
		if is_inside_till:
			scaleBy = 1
			rescale()
