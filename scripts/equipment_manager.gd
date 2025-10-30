extends TextureRect
class_name EquipmentManager

@export_category("Slots")
@export var helmet_slot: TextureRect
@export var armor_slot: TextureRect
@export var boots_slot: TextureRect
@export var gloves_slot: TextureRect
@export var belt_slot: TextureRect
@export var ring_1_slot: TextureRect
@export var ring_2_slot: TextureRect
@export var shield_slot: TextureRect
@export var weapon_slot: TextureRect
@export var necklace_slot: TextureRect

var equipment_data: Dictionary = {
	"helmet": null,
	"armor": null,
	"boots": null,
	"gloves": null,
	"belt": null,
	"ring_1": null,
	"ring_2": null,
	"shield": null,
	"necklace": null,
	"weapon": null
}

var can_click: bool = false
var slot_target = null


func _ready() -> void:
	connect_signal()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		unequip_item(slot_target)


func connect_signal() -> void:
	for slot in self.get_children():
		if slot is TextureRect:
			slot.mouse_entered.connect(on_mouse_entered.bind(slot))
			slot.mouse_exited.connect(on_mouse_exited.bind(slot))


func equip_item(item: StaticBody2D) -> void:
	var item_type: String = item.item_type
	
	match item_type:
		"weapon":
			if weapon_slot.get_child_count() == 1:
				return
			
			equipment_data["weapon"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			weapon_slot.add_child(item)
		
		"helmet":
			if helmet_slot.get_child_count() == 1:
				return
			
			equipment_data["helmet"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			helmet_slot.add_child(item)
		
		"armor":
			if armor_slot.get_child_count() == 1:
				return
			
			equipment_data["armor"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			armor_slot.add_child(item)
		
		"shield":
			if shield_slot.get_child_count() == 1:
				return
			
			equipment_data["shield"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			shield_slot.add_child(item)
		
		"gloves":
			if gloves_slot.get_child_count() == 1:
				return
			
			equipment_data["gloves"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			gloves_slot.add_child(item)
		
		"belt":
			if belt_slot.get_child_count() == 1:
				return
			
			equipment_data["belt"] = item.item_data
			item.get_parent().color = Color("#262626")
			item.get_parent().remove_child(item)
			belt_slot.add_child(item)
	
	get_total_bonus()
	Player.improve_damage("dps", "equipment")
	Player.improve_damage("click", "equipment")
	get_tree().call_group("main_scene", "update_label")


func unequip_item(slot: TextureRect) -> void:
	if slot.get_child_count() == 0:
		return
	
	var item: StaticBody2D = slot.get_child(0)
	slot.remove_child(item)
	get_tree().call_group("inventory", "add_item", item)
	
	match slot.name:
		"Helmet":
			equipment_data["helmet"] = null
		
		"Weapon":
			equipment_data["weapon"]= null
		
		"Armor":
			equipment_data["armor"] = null
		
		"Shield":
			equipment_data["shield"] = null
		
		"Gloves":
			equipment_data["gloves"] = null
		
		"Belt":
			equipment_data["belt"] = null
	
	get_total_bonus()
	Player.improve_damage("dps", "equipment")
	Player.improve_damage("click", "equipment")
	get_tree().call_group("main_scene", "update_label")


func get_total_bonus() -> void:
	var total_bonus: Dictionary = {
	"click_damage": 0.0,
	"dps_damage": 0.0,
	"gold_gain": 0.0,
	"magic_find": 0.0
	}
	
	for item in equipment_data.values():
		if item == null:
			continue
		total_bonus["click_damage"] += item["click_damage"]
		total_bonus["dps_damage"] += item["dps_damage"]
		total_bonus["gold_gain"] += item["gold_gain"]
		total_bonus["magic_find"] += item["magic_find"]
	
	Player.equipment_bonus = total_bonus


func on_mouse_entered(slot: TextureRect) -> void:
	slot_target = slot
	can_click = true


func on_mouse_exited(slot: TextureRect) -> void:
	can_click = false
	slot_target = null
