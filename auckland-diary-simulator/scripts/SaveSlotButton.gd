extends Button


var slot:int = 1


func setup(slot_id:int, display_text:String):
slot = slot_id
text = display_text


func _on_pressed():
# Emitting to parent menu to handle load
get_parent().emit_signal("load_requested", slot)
