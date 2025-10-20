extends TextureRect
class_name StatsContainer

@export_category("Objetos")
@export var hero_level_label: Label
@export var avg_power_level_label: Label
@export var exp_bar: TextureProgressBar
@export var btn_reset_attributes: TextureButton


func _ready() -> void:
	update_exp_bar()


func update_exp_bar() -> void:
	exp_bar.max_value = Player.level_dict[str(Player.level)]
	exp_bar.value = Player.current_exp
	
	hero_level_label.text = "Hero Level: " + str(Player.level)
	avg_power_level_label.text = "Average Power Level: " + str(Player.avg_power_level)
	exp_bar.get_node("Label").text = (
		World.format_number(Player.current_exp) + " / " + 
		World.format_number(Player.level_dict[str(Player.level)])
	)


func _on_reset_attributes_pressed() -> void:
	pass # Replace with function body.


func _on_reset_attributes_mouse_entered() -> void:
	btn_reset_attributes.modulate.a = 150


func _on_reset_attributes_mouse_exited() -> void:
	btn_reset_attributes.modulate.a = 255
