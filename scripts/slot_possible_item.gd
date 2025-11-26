extends TextureRect
class_name SlotPossibleLoot

@export_category("Item Info")
@export var item_name_label: Label
@export var power_level_label: Label
@export var gold_gain_label: Label
@export var dps_damage_label: Label
@export var click_damage_label: Label
@export var magic_find_label: Label


func update_item_info(item_data: Dictionary) -> void:
	item_name_label.text = item_data["name"]
	power_level_label.text = (
		"Power Level: " + 
		str(item_data["power_level"]["common"][0]) + " - " + 
		str(item_data["power_level"]["legendary"][1])
	)
	
	if item_data.has("gold_gain"):
		gold_gain_label.visible = true
		gold_gain_label.text = (
			"Gold Gain: " + 
			str(item_data["gold_gain"]["common"][0]) + "% - " + 
			str(item_data["gold_gain"]["legendary"][1]) + "%"
		)
	
	if item_data.has("dps_damage"):
		dps_damage_label.visible = true
		dps_damage_label.text = (
			"Dps Damage: " + 
			str(item_data["dps_damage"]["common"][0]) + " - " + 
			str(item_data["dps_damage"]["legendary"][1])
		)
	
	if item_data.has("click_damage"):
		click_damage_label.visible = true
		click_damage_label.text = (
			"Click Damage: " + 
			str(item_data["click_damage"]["common"][0]) + " - " + 
			str(item_data["click_damage"]["legendary"][1])
		)
	
	if item_data.has("magic_find"):
		click_damage_label.visible = true
		click_damage_label.text = (
			"Magic Find: " + 
			str(item_data["magic_find"]["common"][0]) + "% - " + 
			str(item_data["magic_find"]["legendary"][1]) + "%"
		)
