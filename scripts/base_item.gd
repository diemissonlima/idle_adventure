extends StaticBody2D
class_name BaseItem

@export var item_name: String
@export var item_sprite: TextureRect
@export_enum(
	"Common", "Uncommon", "Rare", "Epic", "Legendary"
	) var item_rarity: String = "Commom"
@export_enum(
	"helmet", "armor", "necklace", "weapon", "shield", "belt", "legs", "ring"
	) var item_type
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


func _ready() -> void:
	get_attributes()


func get_total_power() -> float:
	var rarity_mult = {
		"Common": 1.0,
		"Uncommon": 1.1,
		"Rare": 1.25,
		"Epic": 1.5,
		"Legendary": 2.0
	}
	
	return power_level * rarity_mult[item_rarity]


func update_item_info() -> void:
	item_name_label.text = item_rarity + "\n" + item_name
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


func get_attributes() -> void:
	var attributes = World.equipments[item_name]
	power_level = randi_range(attributes["power_level"][0], attributes["power_level"][1])
	
	if attributes.has("click_damage"):
		click_damage = randi_range(
			attributes["click_damage"][0], attributes["click_damage"][1]
			)
	if attributes.has("gold_gain"):
		gold_gain = randi_range(
			attributes["gold_gain"][0], attributes["gold_gain"][1]
		)
	if attributes.has("dps_damage"):
		dps_damage = randi_range(
			attributes["dps_damage"][0], attributes["dps_damage"][1]
		)
	if attributes.has("magic_find"):
		magic_find = randi_range(
			attributes["magic_find"][0], attributes["magic_find"][1]
		)


func _on_sprite_mouse_entered() -> void:
	item_info.visible = true
	update_item_info()


func _on_sprite_mouse_exited() -> void:
	item_info.visible = false
