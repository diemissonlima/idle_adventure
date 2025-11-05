extends TextureRect
class_name EquipmentStats

@export_category("Objetos")
@export var gear_power: Label
@export var click_damage: Label
@export var dps_damage: Label
@export var gold_gain: Label


func _ready() -> void:
	update_label()


func update_label() -> void:
	gear_power.text = (
		str(Player.equipment_bonus["gear_power"]) + "\n" + 
		"Gear Power Score"
		)
	
	click_damage.text = (
		"+" + 
		World.format_number(Player.equipment_bonus["click_damage"]) + "\n" +
		"Click Damage"
		)
	
	dps_damage.text = (
		"+" + 
		World.format_number(Player.equipment_bonus["dps_damage"]) + "\n" +
		"Damage Per Second\n(DPS)"
	)
	
	gold_gain.text = (
		"+" +
		World.format_number(Player.equipment_bonus["gold_gain"]) + "%\n" +
		"Gold Gain"
	)
