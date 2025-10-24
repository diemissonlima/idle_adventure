extends Node2D
class_name Inventory

@export var slot_scene: PackedScene
@export var inventory_size: int
@export var inventory_container: GridContainer


func _ready() -> void:
	populate_inventory_slot()


func populate_inventory_slot() -> void:
	for j in range(inventory_size):
		var slot = slot_scene.instantiate()
		inventory_container.add_child(slot)
