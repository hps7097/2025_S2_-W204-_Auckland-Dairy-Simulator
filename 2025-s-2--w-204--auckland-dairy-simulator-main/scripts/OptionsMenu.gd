#MADE WITH CHATGPT
# OptionsMenu.gd
extends Control

@onready var music_slider: HSlider = $Music
@onready var sfx_slider: HSlider = $Sfx
@onready var dialogue_speed_slider: HSlider = $DialogueSpeed
@onready var graphics_option: OptionButton = $Graphics
@onready var btn_close: Button = $BtnClose

func _ready() -> void:
	_load_current()
	music_slider.value_changed.connect(Callable(self, "_on_music_changed"))
	sfx_slider.value_changed.connect(Callable(self, "_on_sfx_changed"))
	dialogue_speed_slider.value_changed.connect(Callable(self, "_on_dialogue_speed_changed"))
	graphics_option.item_selected.connect(Callable(self, "_on_graphics_selected"))
	btn_close.pressed.connect(Callable(self, "_on_close_pressed"))

func _load_current() -> void:
	music_slider.value = Settings.music_vol * 100
	sfx_slider.value = Settings.sfx_vol * 100
	dialogue_speed_slider.value = Settings.dialogue_speed * 100

	# Fill graphics dropdown if needed
	graphics_option.clear()
	graphics_option.add_item("Low")
	graphics_option.add_item("Medium")
	graphics_option.add_item("High")

	for i in range(graphics_option.item_count):
		if graphics_option.get_item_text(i) == Settings.graphics_quality:
			graphics_option.select(i)
			break


func _on_music_changed(value: float) -> void:
	Settings.music_vol = value / 100.0
	Settings.save()

func _on_sfx_changed(value: float) -> void:
	Settings.sfx_vol = value / 100.0
	Settings.save()

func _on_dialogue_speed_changed(value: float) -> void:
	Settings.dialogue_speed = value / 100.0
	Settings.save()

func _on_graphics_selected(index: int) -> void:
	Settings.graphics_quality = graphics_option.get_item_text(index)
	Settings.save()

func _on_close_pressed() -> void:
	hide()
