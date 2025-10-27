extends Node2D
class_name Inventory

@export var slot_scene: PackedScene
@export var inventory_size: int
@export var inventory_container: GridContainer


func _ready() -> void:
	populate_inventory_slot()
	pass


func populate_inventory_slot() -> void:
	for j in range(inventory_size):
		var slot = slot_scene.instantiate()
		inventory_container.add_child(slot)


func add_item(item: StaticBody2D) -> void:
	for slot in inventory_container.get_children():
		if slot.get_child_count() <= 1:
			slot.add_child(item)
			slot.handler_slot_color(item.item_rarity)
			get_tree().call_group(
				"game_log", "add_message",
				"You found " + item.item_rarity.capitalize() + " " + item.item_name
				)
			break
