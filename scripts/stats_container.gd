extends TextureRect
class_name StatsContainer

@export_category("Objetos")
@export var hero_level_label: Label
@export var avg_power_level_label: Label
@export var exp_bar: TextureProgressBar
@export var btn_reset_attributes: TextureButton
@export var strength_label: Label
@export var agility_label: Label
@export var luck_label: Label
@export var available_points_label: Label


func _ready() -> void:
	connect_button_signal()
	update_label()
	update_exp_bar()


func connect_button_signal() -> void:
	for button in $HBoxContainer.get_children(): # conecta os botoes das abas
		if button is TextureButton:
			button.pressed.connect(on_button_tab_pressed.bind(button))
	
	for button in $Hero/AttributesBackground/VBoxContainer2.get_children():
		if button is TextureButton:
			button.pressed.connect(on_button_increase_status_pressed.bind(button))


func on_button_tab_pressed(button: TextureButton) -> void:
	for child in $".".get_children():
		if child is Node2D:
			child.visible = false
	
	match button.name:
		"BtnMap":
			$Map.visible = true
		
		"BtnHero":
			$Hero.visible = true


func on_button_increase_status_pressed(button: TextureButton) -> void:
	if Player.available_stats_points <= 0:
		return
	
	match button.name:
		"Strength":
			Player.strength += 1
			Player.improve_damage("click", "stats_upgrade")
			
		"Agility":
			Player.agility += 1
			Player.improve_damage("dps", "stats_upgrade")
			
		"Luck":
			Player.luck += 1
	
	Player.available_stats_points -= 1
	get_tree().call_group("main_scene", "update_label")
	update_label()


func update_exp_bar() -> void:
	exp_bar.max_value = Player.level_dict[str(Player.level)]
	exp_bar.value = Player.current_exp
	
	hero_level_label.text = "Hero Level: " + str(Player.level)
	avg_power_level_label.text = "Average Power Level: " + str(Player.avg_power_level)
	exp_bar.get_node("Label").text = (
		World.format_number(Player.current_exp) + " / " + 
		World.format_number(Player.level_dict[str(Player.level)])
	)


func update_label() -> void:
	strength_label.text = "Strength: " + str(Player.strength)
	agility_label.text = "Agility: " + str(Player.agility)
	luck_label.text = "Luck: " + str(Player.luck)
	available_points_label.text = "Available Points: " + str(Player.available_stats_points)


func _on_reset_attributes_pressed() -> void:
	var total_points: int = Player.strength + Player.agility + Player.luck
	
	if total_points > 0:
		Player.strength = 0
		Player.agility = 0
		Player.luck = 0
		Player.available_stats_points = total_points
	
	update_label()
