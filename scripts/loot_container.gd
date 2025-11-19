extends ScrollContainer
class_name LootContainer

@export var gold_label: Label
@export var loot_container: VBoxContainer


func _ready() -> void:
	update_label()


func update_label() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	
	gold_label.text = (
		str(World.format_number(gold_range[0])) + "g - " + 
		str(World.format_number(gold_range[1])) + "g"
	)


func get_possible_loot(possible_loot: Array) -> void:
	print(possible_loot)
