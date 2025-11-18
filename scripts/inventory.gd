extends Node2D
class_name Inventory

# tipos de item
# weapon, helm, armor, shield, belt, gloves, necklace, ring, boots

@export var slot_scene: PackedScene
@export var inventory_size: int
@export var inventory_container: GridContainer
@export var equipment_container: TextureRect
@export var item_list: Array[PackedScene]

var slot_can_click: bool = false
var slot_target: ColorRect


func _ready() -> void:
	populate_inventory_slot()
	connect_slot_signal()
	populate_inventory()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and slot_can_click:
		if slot_target.get_child_count() > 1:
			var item = slot_target.get_child(1)
			
			get_tree().call_group(
				"equipment_manager", "equip_item", item
				)


func populate_inventory_slot() -> void:
	for j in range(inventory_size):
		var slot = slot_scene.instantiate()
		inventory_container.add_child(slot)


func connect_slot_signal() -> void:
	for slot in inventory_container.get_children():
		slot.mouse_entered.connect(on_mouse_entered.bind(slot))
		slot.mouse_exited.connect(on_mouse_exited.bind(slot))


func on_mouse_entered(slot: ColorRect) -> void:
	slot_target = slot
	slot_can_click = true


func on_mouse_exited(slot: ColorRect) -> void:
	slot_target = null
	slot_can_click = false


func add_item(item: StaticBody2D) -> void:
	var added: bool = false
	
	for slot in inventory_container.get_children():
		if slot.get_child_count() <= 1:
			slot.add_child(item)
			slot.handler_slot_color(item.item_rarity)
			get_tree().call_group(
				"game_log", "add_message",
				"You found " + item.item_rarity.capitalize() + " " + item.item_name
				)
			
			added = true
			break
			
	if not added:
		Player.improve_scrap(item.power_level)


func populate_inventory() -> void:
	for j in range(160):
		var index: int = randi() % item_list.size()
		var item_scene = item_list[index]
		var item_instance = item_scene.instantiate()
		add_item(item_instance)
