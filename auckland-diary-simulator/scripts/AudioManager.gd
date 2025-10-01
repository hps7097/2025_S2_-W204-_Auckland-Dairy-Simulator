#MADE WITH CHATGPT

extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
    add_child(music_player)
    add_child(sfx_player)
    music_player.bus = "Music"
    sfx_player.bus = "SFX"

# Play background music (loops)
func play_music(stream: AudioStream) -> void:
    if music_player.stream != stream:
        music_player.stream = stream
    music_player.play()

# Stop music
func stop_music() -> void:
    music_player.stop()

# Play sound effect (one-shot)
func play_sfx(stream: AudioStream) -> void:
    sfx_player.stream = stream
    sfx_player.play()
