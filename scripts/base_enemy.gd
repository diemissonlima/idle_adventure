extends StaticBody2D
class_name BaseEnemy

@export_category("Objetos")
@export var enemy_name_label: Label
@export var progress_bar: TextureProgressBar

@export_category("Variaveis")
@export var enemy_name: String
@export var max_health: float
@export var health: float
@export_enum("Normal", "Mini-Boss", "Boss") var enemy_type
@export_enum(
	"Slime"
) var enemy_race


func _ready() -> void:
	increase_health()
	init_bar()


func init_bar() -> void:
	progress_bar.max_value = round(max_health)
	progress_bar.value = round(health)
	progress_bar.get_node("Label").text = str(
		World.format_number(round(health)) + " / " + World.format_number(round(max_health))
		)
	
	enemy_name_label.text = enemy_name + " - Lvl " + str(World.level)


func increase_health() -> void:
	max_health = World.enemy_hp_level[str(World.level)]
	health = max_health


func take_damage(value: int) -> void:
	health -= value
	update_bar()
	
	if health <= 0:
		kill()


func update_bar() -> void:
	progress_bar.value = round(health)
	progress_bar.get_node("Label").text = str(
		World.format_number(round(health)) + " / " + World.format_number(round(max_health))
		)


func kill() -> void:
	Player.improve_gold()
	World.level += 1
	Player.update_exp(randi_range(250, 750))
	get_tree().call_group("main_scene", "spawn_new_enemy")
	
	queue_free()
