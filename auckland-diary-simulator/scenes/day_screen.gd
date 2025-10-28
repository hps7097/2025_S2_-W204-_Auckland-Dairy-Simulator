extends Control

@onready var ambience: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")

func _ready() -> void:
	if ambience == null:
		push_error("Ambience player not found at path: AudioStreamPlayer2D")
		return
	if ambience.stream == null:
		push_error("Ambience player has no Stream assigned")
		return

	# Make sure it isn't paused
	ambience.stream_paused = false

	var s := ambience.stream
	if s is AudioStreamWAV:
		# WAV/QOA: enable looping via loop_mode
		s.loop_mode = AudioStreamWAV.LOOP_FORWARD
		# Optional loop points:
		# s.loop_begin = 0
		# s.loop_end = 0  # 0 = until end
	elif s is AudioStreamOggVorbis:
		# OGG/Vorbis: simple boolean
		s.loop = true
	else:
		# Fallback for other stream types (may have a tiny gap)
		ambience.finished.connect(func(): ambience.play())

	ambience.play()
