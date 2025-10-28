extends Label

# Play when money GAINs, when it is SPENT, or BOTH
enum Trigger { GAIN, SPEND, BOTH }
@export var play_on: Trigger = Trigger.BOTH   # Set in Inspector (e.g., BOTH for night)

@onready var _sfx2d: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")
@onready var _sfx:   AudioStreamPlayer   = get_node_or_null("AudioStreamPlayer")

var _last_money: float = 0.0
var _active: bool = false
const EPS := 0.0001

func _ready() -> void:
	_last_money = ProductManager.money
	if _sfx2d:
		# make 2D act like UI (no falloff)
		_sfx2d.attenuation = 0.0
		_sfx2d.max_distance = 100000.0

func _process(delta: float) -> void:
	text = str(ProductManager.money).pad_decimals(2)

	var cur := ProductManager.money
	var rising  := cur > _last_money + EPS
	var falling := cur < _last_money - EPS
	var moving  := rising or falling

	# Should we trigger based on selected mode?
	var trigger_gain   := (play_on == Trigger.GAIN  or play_on == Trigger.BOTH) and rising
	var trigger_spend  := (play_on == Trigger.SPEND or play_on == Trigger.BOTH) and falling
	var should_trigger := (trigger_gain or trigger_spend) and not _active

	# Edge trigger (play once at start of movement in an allowed direction)
	if should_trigger:
		_active = true
		_play_coin()

	# Reset once movement stops (preps next edge)
	if not moving:
		_active = false

	_last_money = cur

func _play_coin() -> void:
	if _sfx and _sfx.stream:
		_sfx.stop()
		_sfx.play()
	elif _sfx2d and _sfx2d.stream:
		_sfx2d.stop()
		_sfx2d.play()
