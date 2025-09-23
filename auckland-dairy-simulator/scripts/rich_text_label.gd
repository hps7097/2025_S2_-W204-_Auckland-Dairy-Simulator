# MADE WITH CHATGPT
extends RichTextLabel

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if ProductManager.message != "" && timer.is_stopped():
		text = ProductManager.message
		timer.start()
	elif timer.is_stopped():
		text = "TOTAL: $" + str(ProductManager.total_price).pad_decimals(2) + \
		"\n\n Day: " + str(GameManager.dayCount) + \
		"\n Customers Left: " + str(GameManager.dayCustomerCount) + \
		"\n Upgrades: " + str(UpgradeManager.upgrades)

func _on_timer_timeout() -> void:
	ProductManager.message = ""
