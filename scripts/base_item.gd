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

@export_category("Item Info")
@export var item_name_label: Label
@export var power_level_label: Label
@export var gold_gain_label: Label
@export var dps_damage_label: Label
@export var click_damage_label: Label
@export var magic_find_label: Label

var item_data: Dictionary


func _ready() -> void:
	get_attributes()
	set_item_data()


func update_item_info() -> void:
	item_name_label.text = item_rarity.capitalize() + "\n" + item_name
	power_level_label.text = "Power Level: " + str(power_level)
	
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
	item_data["item_unique"] = item_unique
	item_data["power_level"] = power_level
	item_data["gold_gain"] = gold_gain
	item_data["dps_damage"] = dps_damage
	item_data["click_damage"] = click_damage
	item_data["magic_find"] = magic_find


func _on_sprite_mouse_entered() -> void:
	item_info.visible = true
	update_item_info()


func _on_sprite_mouse_exited() -> void:
	item_info.visible = false
