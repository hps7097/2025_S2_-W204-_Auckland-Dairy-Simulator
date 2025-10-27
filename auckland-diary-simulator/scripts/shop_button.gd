extends Button

@onready var image: TextureRect = $VBoxContainer/PanelContainer/ColorRect1/Image
@onready var label: Label = $VBoxContainer/PanelContainer/ColorRect1/Label
@onready var priceLabel: Label = $VBoxContainer/PanelContainer2/ColorRect1/Label
@onready var nextDayButton: Button = $"../../Button"

var coin = preload("res://scenes/coin.tscn")

var upgadeLabels = [
["New flooring", "Better Lighting", "Shutter Grates", "Reinforced Glass", "Bollards / Steel Posts"], 
["XXL Pies", "V Refresh Series", "More Chip Flavours"], 
["Vapes", "Fake IDs", "Zaza", "White Stuff"]]

var upgradePrices = [
[40, 55, 75, 80, 100], 
[30, 40, 50], 
[25, 30, 40, 50]]

@export var upgradeType: int
var price: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = load("res://assets/_Upgrades.png")
	atlas.region = Rect2(
		upgradeType * 120,
		UpgradeManager.getUpgrade(upgradeType) * 120,
		120, 120
	)
	image.texture = atlas
	
	var upgrade_value = UpgradeManager.getUpgrade(upgradeType)
	
	if (upgradeType == 0 and upgrade_value == 5) \
	or (upgradeType == 1 and upgrade_value == 3) \
	or (upgradeType == 2 and upgrade_value == 4):
		image.texture.region = Rect2(120, 480, 120, 120)
		label.text = "Upgrade Maxed"
		price = 999999999
		priceLabel.text = "$--.--"
		nextDayButton.disabled = false
		return
		
	if (upgradeType == 2 and GameManager.dayCount == 1):
		image.texture.region = Rect2(240, 480, 120, 120)
		label.text = "Locked"
		price = 999999999
		priceLabel.text = "$--.--"
		nextDayButton.disabled = false
		return
	
	image.texture.region = Rect2(upgradeType * 120, upgrade_value * 120, 120, 120)  # x, y, width, height
	label.text = str(upgadeLabels[upgradeType][upgrade_value])
	price = upgradePrices[upgradeType][upgrade_value]
	priceLabel.text = "$" + "%0.2f" % price

func _on_pressed() -> void:
	"""
	MAKE CHECK IF BALANCE SUFFICIENT
	THEN CREATE MONEY ANIMATION
	"""
	if price < ProductManager.money:
		disabled = true
		nextDayButton.disabled = true
		UpgradeManager.upgrade(upgradeType)
		var moneyTotal = ProductManager.money - price
		
		GameManager.setMoneyStart(moneyTotal)
		
		for i in range(floor(price / 2)):
			var t = get_tree().create_timer(0.1) # 1 second
			await t.timeout
			var coin1 = coin.instantiate()
			coin1.type = upgradeType + 1
			get_tree().current_scene.add_child(coin1)
		var tween = get_tree().create_tween()
		tween.tween_property(ProductManager, "money", moneyTotal, 1.0)
		
		var upgrade_value = UpgradeManager.getUpgrade(upgradeType)
		if (upgradeType == 0 and upgrade_value == 5) \
		or (upgradeType == 1 and upgrade_value == 3) \
		or (upgradeType == 2 and upgrade_value == 4):
			image.texture.region = Rect2(120, 480, 120, 120)
			label.text = "Upgrade Maxed"
			price = 999999999
			priceLabel.text = "$--.--"
			nextDayButton.disabled = false
			return
		
		price = upgradePrices[upgradeType][upgrade_value]
		image.texture.region = Rect2(upgradeType * 120, UpgradeManager.getUpgrade(upgradeType) * 120, 120, 120)
		label.text = str(upgadeLabels[upgradeType][upgrade_value])
		priceLabel.text = "$" + "%0.2f" % price
		
		var t = get_tree().create_timer(1) # 1 second
		await t.timeout
	
		
		nextDayButton.disabled = false
		disabled = false
	
