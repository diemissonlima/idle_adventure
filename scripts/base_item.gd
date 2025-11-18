extends StaticBody2D
class_name BaseItem

@export var item_name: String
@export var item_sprite: TextureRect
@export var item_rarity: String
@export var item_type: String
@export var item_unique: bool = false
@export var power_level: int = 0
@export var gold_gain: float = 0.0
@export var dps_damage: float = 0.0
@export var click_damage: float = 0.0
@export var magic_find: float = 0.0
@export var item_info: TextureRect
@export var compare_item_info: TextureRect

@export_category("Item Info")
@export var item_name_label: Label
@export var power_level_label: Label
@export var gold_gain_label: Label
@export var dps_damage_label: Label
@export var click_damage_label: Label
@export var magic_find_label: Label

@export_category("Compare Item")
@export var compare_item_name_label: Label
@export var compare_power_level_label: Label
@export var compare_gold_gain_label: Label
@export var compare_dps_damage_label: Label
@export var compare_click_damage_label: Label
@export var compare_magic_find_label: Label

var item_data: Dictionary
var compare_info: bool = false


func _ready() -> void:
	get_attributes()
	set_item_data()


func _process(_delta: float) -> void:
	if get_parent().name == "Slot" or get_parent().name.begins_with("@Color"):
		if Input.is_action_pressed("compare_item") and compare_info:
			show_compare_item_info()
		else:
			compare_item_info.visible = false
			Player.compare_item = {}


func update_item_info() -> void:
	item_name_label.text = item_rarity.capitalize() + "\n" + item_name
	power_level_label.text = "Power Level: " + str(power_level)
	
	match item_rarity:
		"common":
			item_name_label.self_modulate = Color.WHITE
		
		"uncommon":
			item_name_label.self_modulate = Color.GREEN
		
		"rare":
			item_name_label.self_modulate = Color.BLUE
		
		"epic":
			item_name_label.self_modulate = Color.MAGENTA
		
		"legendary":
			item_name_label.self_modulate = Color.GOLD
	
	if gold_gain:
		gold_gain_label.visible = true
		gold_gain_label.text = "+" + str(gold_gain) + "% Gold Gain"
	
	if dps_damage:
		dps_damage_label.visible = true
		dps_damage_label.text = "+" + str(dps_damage) + " DPS Damage"
	
	if click_damage:
		click_damage_label.visible = true
		click_damage_label.text = "+" + str(click_damage) + " Click Damage"
	
	if magic_find:
		magic_find_label.visible = true
		magic_find_label.text = "+" + str(magic_find) + "% Magic Find"


func get_item_rarity() -> String:
	var rarity_list: Array = [
		"legendary", "epic", "rare", "uncommon"
	]
	var rarity_chance: Array = [
		0.005, 0.01, 0.10, 0.30
	]
	
	for j in rarity_list.size():
		var rng: float = randf()
		if rng <= rarity_chance[j]:
			return rarity_list[j]
	
	return "common"


func get_attributes() -> void:
	var item_info = World.equipments[item_name]
	item_rarity = get_item_rarity()
	item_type = item_info["slot"]
	power_level = randi_range(
		item_info["power_level"][item_rarity][0],
		item_info["power_level"][item_rarity][1]
		)
	
	if item_info.has("click_damage"):
		click_damage = randi_range(
			item_info["click_damage"][item_rarity][0], 
			item_info["click_damage"][item_rarity][1]
			)
	if item_info.has("gold_gain"):
		gold_gain = randi_range(
			item_info["gold_gain"][item_rarity][0], 
			item_info["gold_gain"][item_rarity][1]
		)
	if item_info.has("dps_damage"):
		dps_damage = randi_range(
			item_info["dps_damage"][item_rarity][0], 
			item_info["dps_damage"][item_rarity][1]
		)
	if item_info.has("magic_find"):
		magic_find = randi_range(
			item_info["magic_find"][item_rarity][0], 
			item_info["magic_find"][item_rarity][1]
		)


func set_item_data() -> void:
	item_data["item_name"] = item_name
	item_data["item_sprite"] = item_sprite.texture.resource_path
	item_data["item_rarity"] = item_rarity
	item_data["item_type"] = item_type
	item_data["item_unique"] = item_unique
	item_data["power_level"] = power_level
	item_data["gold_gain"] = gold_gain
	item_data["dps_damage"] = dps_damage
	item_data["click_damage"] = click_damage
	item_data["magic_find"] = magic_find


func show_compare_item_info() -> void:
	compare_item_info.visible = true
	get_tree().call_group("equipment_manager", "check_equipped_item", item_type)
	var equipped_item = Player.compare_item.duplicate()
	
	if equipped_item:
		compare_item_name_label.text = (
			equipped_item["item_rarity"].capitalize() + "\n" + equipped_item["item_name"]
		)
		compare_power_level_label.text = (
			"Power Level: " + str(equipped_item["power_level"])
		)
		
		match equipped_item["item_rarity"]:
			"common":
				compare_item_name_label.self_modulate = Color.WHITE
			
			"uncommon":
				compare_item_name_label.self_modulate = Color.GREEN
			
			"rare":
				compare_item_name_label.self_modulate = Color.BLUE
			
			"epic":
				compare_item_name_label.self_modulate = Color.MAGENTA
			
			"legendary":
				compare_item_name_label.self_modulate = Color.GOLD
		
		if equipped_item["gold_gain"]:
			compare_gold_gain_label.visible = true
			compare_gold_gain_label.text = "+" + str(equipped_item["gold_gain"]) + "% Gold Gain"
		
		if equipped_item["dps_damage"]:
			compare_dps_damage_label.visible = true
			compare_dps_damage_label.text = "+" + str(equipped_item["dps_damage"]) + " DPS Damage"
		
		if click_damage:
			compare_click_damage_label.visible = true
			compare_click_damage_label.text = "+" + str(equipped_item["click_damage"]) + " Click Damage"
		
		if magic_find:
			compare_magic_find_label.visible = true
			compare_magic_find_label.text = "+" + str(equipped_item["magic_find"]) + "% Magic Find"


func _on_sprite_mouse_entered() -> void:
	update_item_info()
	item_info.visible = true
	compare_info = true
	
	var parent = get_parent()
	var slot_parent = parent.get_index() + 1
	
	if slot_parent % 8 in [5, 6, 7, 0]:
		item_info.position.x = -61
		
		if slot_parent in [149, 150, 151, 152]:
			item_info.position.y = -17
		if slot_parent in [157, 158, 159, 160]:
			item_info.position.y = -34
	
	if slot_parent in [145, 146, 147, 148]:
		item_info.position.y = -17
	if slot_parent in [153, 154, 155, 156]:
		item_info.position.y = -34


func _on_sprite_mouse_exited() -> void:
	item_info.visible = false
	compare_info = false
