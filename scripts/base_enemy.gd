extends StaticBody2D
class_name BaseEnemy

@export_category("Objetos - Inimigo")
@export var progress_bar: TextureProgressBar

@export_category("Variaveis")
@export var max_health: int
@export var health: int


func _ready() -> void:
	init_bar()


func init_bar() -> void:
	max_health = 100
	health = max_health
	
	progress_bar.max_value = max_health
	progress_bar.value = health
	progress_bar.get_node("Label").text = str(health) + " / " + str(max_health)


func take_damage(value: int) -> void:
	health -= value
	update_bar()
	
	if health <= 0:
		kill()


func update_bar() -> void:
	progress_bar.value = health
	progress_bar.get_node("Label").text = str(health) + " / " + str(max_health)


func kill() -> void:
	print("matar inimigo")
