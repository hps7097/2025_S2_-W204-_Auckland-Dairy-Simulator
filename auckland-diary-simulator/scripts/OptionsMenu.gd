#MADE WITH CHATGPT
extends Control

@onready var music_slider := $Music 
@onready var sfx_slider := $Sfx 
@onready var dialogue_slider := $DialogueSpeed 
@onready var graphics_dd := $Graphics 
@onready var close_btn := $BtnClose 

func _ready(): 
	music_slider.value = Settings.music_volume 
	sfx_slider.value = Settings.sfx_volume 
	dialogue_slider.value = Settings.dialogue_speed 
	
	graphics_dd.get_popup().clear()
	graphics_dd.add_item("Low")
	graphics_dd.add_item("Medium")
	graphics_dd.add_item("High")

	var idx := GraphicsIndex(Settings.graphics_quality)
	graphics_dd.select(idx)

	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	dialogue_slider.value_changed.connect(_on_dialogue_changed)
	graphics_dd.item_selected.connect(_on_graphics_selected)
	close_btn.pressed.connect(_on_close)

func GraphicsIndex(str_g: String) -> int:
	match str_g.to_lower():
		"low": return 0
		"medium": return 1
		"high": return 2
	return 1

func _on_music_changed(v: float) -> void:
	Settings.music_volume = v

func _on_sfx_changed(v: float) -> void:
	Settings.sfx_volume = v

func _on_dialogue_changed(v: float) -> void:
	Settings.dialogue_speed = v

func _on_graphics_selected(idx: int) -> void:
	Settings.graphics_quality = ["low", "medium", "high"][idx]

func _on_close() -> void:
	Settings.persist_all()
	queue_free()
