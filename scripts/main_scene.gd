extends Control
class_name MainScene

@export_category("Objetos")
@export var attack_timer: Timer

@export_category("Objetos - Actions")
@export var click_attack_label: Label
@export var dps_attack_label: Label
@export var gold_resource_label: Label
@export var scrap_resource_label: Label

@export_category("Objetos - Gold Upgrades")
@export var click_damage_cost_label: Label
@export var click_damage_level_label: Label
@export var dps_damage_cost_label: Label
@export var dps_damage_level_label: Label

@export_category("Variaveis")
@export var level: int = 1
@export var enemy_scene: PackedScene

var can_click: bool = false


func _ready() -> void:
	attack_timer.start()
	update_label()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		get_tree().call_group("enemy", "take_damage", Player.click_damage)


func spawn_new_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	$VContainer/Battlefield/Marker2D.add_child(enemy_instance)


func update_label() -> void:
	click_attack_label.text = str(Player.click_damage)
	dps_attack_label.text = str(Player.dps_damage)
	gold_resource_label.text = str(Player.gold_resource)
	scrap_resource_label.text = str(Player.scrap_resource)
	click_damage_cost_label.text = "Cost: " + str(World.click_damage_cost)
	click_damage_level_label.text = "Improve Clicks - Lvl " + str(World.click_damage_level)
	dps_damage_cost_label.text = "Cost: " + str(World.dps_damage_cost)
	dps_damage_level_label.text = "Improve Idle DPS - Lvl " + str(World.dps_damage_level)


func _on_attack_timer_timeout() -> void:
	get_tree().call_group("enemy", "take_damage", Player.dps_damage)


func _on_max_dps_pressed() -> void:
	if Player.gold_resource >= World.dps_damage_cost:
		World.dps_damage_level += 1 # aumenta o level do dps damage
		Player.dps_damage += 1 # aumenta o poder do dps damage
		Player.gold_resource -= World.dps_damage_cost # deduz o custo do upgrade
		World.dps_damage_cost += World.dps_damage_cost * 0.35 # calcula o novo custo do upgrade
		
	update_label()


func _on_max_click_pressed() -> void:
	if Player.gold_resource >= World.click_damage_cost:
		World.click_damage_level += 1
		Player.click_damage += 1
		Player.gold_resource -= World.click_damage_cost
		World.click_damage_cost += World.click_damage_cost * 0.25
		
	update_label()


func _on_battlefield_mouse_entered() -> void:
	can_click = true


func _on_battlefield_mouse_exited() -> void:
	can_click = false
