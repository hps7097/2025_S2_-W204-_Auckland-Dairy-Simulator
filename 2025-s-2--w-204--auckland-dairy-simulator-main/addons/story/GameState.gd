#MADE WITH CHATGPT
extends Node 
 
# -- Persistent player/store state 
var day: int = 1 
var money: int = 0 
var police_rep: int = 0         # can be negative/positive 
var gang_rep: int = 0 
var flags := {}                 # dictionary of arbitrary boolean/values 
var inventory := {}             # item_id -> count 
var upgrades := {}              # upgrade_id -> level 
var seen_endings := []          # track endings seen 
 
# NPC runtime presence (id -> bool) 

var npc_present := {} 
 
# Replay tracking for acceptance tests 
var branch_history := []        # list of branch ids chosen each run 
 
# Save filepath 
const SAVE_FILE := "user://savegame.save" 
 
func _ready(): 
	# load if exists 
	if File.new().file_exists(SAVE_FILE): 
		load_game() 
	else: 
		# example startup values 
		money = 100 
		police_rep = 0 
		gang_rep = 0 
 
# Game state helpers 
func set_flag(key: String, value): 
	flags[key] = value 
 
func get_flag(key: String) -> Variant: 
	return flags.get(key, null) 
 
func add_money(amount: int): 
	money += amount

func spend_money(amount: int) -> bool: 
	if money >= amount: 
		money -= amount 
		return true 
	return false 
 
func add_item(item_id: String, count: int=1): 
	inventory[item_id] = inventory.get(item_id, 0) + count 
 
func remove_item(item_id: String, count: int=1) -> bool: 
	var have = inventory.get(item_id, 0) 
	if have >= count: 
		inventory[item_id] = have - count 
		return true 
	return false 
 
func set_upgrade(upgrade_id: String, level: int): 
	upgrades[upgrade_id] = level 
 
func increment_day(): 
	day += 1 
	# Reset npc_present each day; spawn system will set them again 
	npc_present.clear() 

func spend_money(amount: int) -> bool: 
	if money >= amount: 
		money -= amount 
		return true 
	return false 
 
func add_item(item_id: String, count: int=1): 
	inventory[item_id] = inventory.get(item_id, 0) + count 
 
func remove_item(item_id: String, count: int=1) -> bool: 
	var have = inventory.get(item_id, 0) 
	if have >= count: 
		inventory[item_id] = have - count 
		return true 
	return false 
 
func set_upgrade(upgrade_id: String, level: int): 
	upgrades[upgrade_id] = level 
 
func increment_day(): 
	day += 1 
	# Reset npc_present each day; spawn system will set them again 
	npc_present.clear()

func spend_money(amount: int) -> bool: 
	if money >= amount: 
		money -= amount 
		return true 
	return false 
 
func add_item(item_id: String, count: int=1): 
	inventory[item_id] = inventory.get(item_id, 0) + count 
 
func remove_item(item_id: String, count: int=1) -> bool: 
	var have = inventory.get(item_id, 0) 
	if have >= count: 
		inventory[item_id] = have - count 
		return true 
	return false 
 
func set_upgrade(upgrade_id: String, level: int): 
	upgrades[upgrade_id] = level 
 
func increment_day(): 
	day += 1 
	# Reset npc_present each day; spawn system will set them again 
	npc_present.clear()

func compute_ending(): 
	# Example logic, tweak to taste 
	if flags.get("ram_raid_triggered", false): 
		if police_rep > 0 and upgrades.get("shutter", 0) == 0: 
			return "backup_police" 
		if upgrades.get("full_armor", 0) >= 1: 
			return "fully_armoured" 
		if gang_rep > 1 and police_rep < 0: 
			return "busted" 
		if gang_rep > 2: 
			return "gang_affiliated" 
		return "ram_raided" 
	return "neutral" 
 
