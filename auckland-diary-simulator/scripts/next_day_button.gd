extends Button

@onready var label: Label = $Label
@onready var sfx: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")
# @onready var sfx: AudioStreamPlayer = get_node_or_null("AudioStreamPlayer")

func _ready() -> void:
	pass # Nothing else needed here

func _process(delta: float) -> void:
	label.text = "START DAY " + str(GameManager.dayCount + 1)

func _on_pressed() -> void:
	# --- Play click sound (safe check)
	if sfx:
		sfx.play()
		# wait briefly so the sound can be heard before changing scene
		await get_tree().create_timer(0.12).timeout

	GameManager.newDay()
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
