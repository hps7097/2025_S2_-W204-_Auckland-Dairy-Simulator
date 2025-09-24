extends RichTextLabel

@onready var timer: Timer = $Timer
var displayMessage: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ProductManager.message != "" && not displayMessage:
		text = ProductManager.message
		timer.start()
		displayMessage = true
	elif not displayMessage:
		text = "TOTAL: $" + str(ProductManager.total_price).pad_decimals(2) + \
		"\n\n Day: " + str(GameManager.dayCount) + \
		"\n Customers Left: " + str(GameManager.dayCustomerCount) + \
		"\n Upgrades: " + str(UpgradeManager.upgrades)

func _on_timer_timeout() -> void:
	ProductManager.message = ""
	displayMessage = false;
	
