extends Node
class_name GlobalPlayer

var dps_damage: float = 0.0
var click_damage: float = 1.0
var gold_resource: float = 0.0
var scrap_resource: float = 0.0

var gold_min: float = 10.0
var gold_max: float = 12.0


func improve_gold() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	
	gold_resource += randi_range(gold_range[0], gold_range[1])
	get_tree().call_group("main_scene", "update_label")
