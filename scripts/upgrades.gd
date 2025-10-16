extends TextureRect
class_name Upgrades

@export_category("Gold Mastery")
@export var gold_mastery: TextureRect
@export var gold_level_label: Label
@export var gold_cost_label: Label
@export var gold_mastery_description: Label


func _on_btn_buy_gold_mastery_pressed() -> void:
	Player.improve_upgrades("gold_mastery")
