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
@export var enemy_scene: PackedScene

var can_click: bool = false


func _ready() -> void:
	spawn_new_enemy()
	update_label()
	attack_timer.start()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		Player.cause_damage("click_damage")


func spawn_new_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	$Container1/Battlefield/Marker2D.add_child(enemy_instance)


func update_label() -> void:
	click_attack_label.text = str(World.format_number(Player.click_damage))
	dps_attack_label.text = str(World.format_number(Player.dps_damage))
	gold_resource_label.text = str(World.format_number(Player.gold_resource))
	scrap_resource_label.text = str(World.format_number(Player.scrap_resource))
	click_damage_cost_label.text = "Cost: " + str(World.format_number(World.click_damage_cost)) + " Gold"
	click_damage_level_label.text = "Improve Clicks - Lvl " + str(World.format_number(World.click_damage_level))
	dps_damage_cost_label.text = "Cost: " + str(World.format_number(World.dps_damage_cost)) + " Gold"
	dps_damage_level_label.text = "Improve Idle DPS - Lvl " + str(World.format_number(World.dps_damage_level))


func _on_attack_timer_timeout() -> void:
	Player.cause_damage("dps_damage")


func _on_max_dps_pressed() -> void:
	if Player.gold_resource >= World.dps_damage_cost:
		Player.improve_damage("dps", "gold_upgrade")
		
	update_label()
	get_tree().call_group("derived_status", "update_label", "IconDPS")


func _on_max_click_pressed() -> void:
	if Player.gold_resource >= World.click_damage_cost:
		Player.improve_damage("click", "gold_upgrade")
		
	update_label()
	get_tree().call_group("derived_status", "update_label", "IconClick")


func _on_battlefield_mouse_entered() -> void:
	can_click = true


func _on_battlefield_mouse_exited() -> void:
	can_click = false
