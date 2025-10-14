# MADE WITH CHATGPT
extends Control

@onready var save_list := $ScrollContainer/SaveList

func _ready() -> void:
    populate_save_list()

func populate_save_list() -> void:
    save_list.queue_free_children()
    var saves := GameState.list_saves()
    for filename in saves:
        var button := Button.new()
        button.text = filename
        button.connect("pressed", Callable(self, "_on_load_pressed").bind(filename))
        save_list.add_child(button)

func _on_load_pressed(filename: String) -> void:
    var success := GameState.load_from_file(filename)
    if success:
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
    else:
        _show_error_popup("Failed to load save: " + filename)

func _show_error_popup(msg: String) -> void:
    var popup := AcceptDialog.new()
    popup.dialog_text = msg
    add_child(popup)
    popup.popup_centered()
