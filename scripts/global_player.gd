extends Node
class_name GlobalPlayer

var dps_damage: int = 0#5000000
var click_damage: int = 1
var gold_resource: int = 0
var scrap_resource: int = 0


func improve_gold(gold_range: Array) -> void:
	gold_resource += randi_range(gold_range[0], gold_range[1])
	get_tree().call_group("main_scene", "update_label")
