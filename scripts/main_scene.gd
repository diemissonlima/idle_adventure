extends Control
class_name MainScene

@export_category("Objetos")
@export var attack_timer: Timer

var can_click: bool = false


func _ready() -> void:
	attack_timer.start()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		get_tree().call_group("enemy", "take_damage", Player.click_damage)


func _on_attack_timer_timeout() -> void:
	get_tree().call_group("enemy", "take_damage", Player.dps_damage)


func _on_max_dps_pressed() -> void:
	Player.dps_damage += 1


func _on_battlefield_mouse_entered() -> void:
	can_click = true


func _on_battlefield_mouse_exited() -> void:
	can_click = false
