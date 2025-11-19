extends ScrollContainer
class_name LootContainer

@export var gold_label: Label
@export var loot_container: VBoxContainer
@export var slot_scene: PackedScene


func _ready() -> void:
	update_label()


func update_label() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	
	gold_label.text = (
		str(World.format_number(gold_range[0])) + "g - " + 
		str(World.format_number(gold_range[1])) + "g"
	)


func get_possible_loot(possible_loot: Array) -> void:
	for item in possible_loot:
		var new_texture_rect = slot_scene.instantiate()
		new_texture_rect.get_node("Sprite").texture = load(
			World.equipments[item]["img_path"]
		)
		
		new_texture_rect.mouse_entered.connect(on_mouse_entered.bind(new_texture_rect))
		new_texture_rect.mouse_exited.connect(on_mouse_exited.bind(new_texture_rect))
		
		loot_container.add_child(new_texture_rect)


func clear_possible_loot() -> void:
	for slot in loot_container.get_children():
		if slot.name != "Gold":
			slot.queue_free()


func on_mouse_entered(item: TextureRect) -> void:
	item.get_node("ItemInfo").visible = true
	var item_name = item.get_node("Sprite").texture.resource_path.get_file().get_basename()
	var item_info: Dictionary = World.equipments[item_name]
	
	item.update_item_info(item_info)


func on_mouse_exited(item: TextureRect) -> void:
	item.get_node("ItemInfo").visible = false
