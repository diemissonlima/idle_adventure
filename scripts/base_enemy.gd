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
	"goblin", "bandit", "slime", "wolf"
) var enemy_race

@export var drop_list: Array[PackedScene]
@export var drop_chances: Array[float]


func _ready() -> void:
	increase_health()
	init_bar()
	get_item_name()


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


func drop_loot() -> void:
	for i in range(drop_list.size()):
		var rng: float = randf()
		if rng <= drop_chances[i]:
			var drop_item = drop_list[i].instantiate()
			
			get_tree().call_group("inventory", "add_item", drop_item)
			break


func update_bar() -> void:
	progress_bar.value = round(health)
	progress_bar.get_node("Label").text = str(
		World.format_number(round(health)) + " / " + World.format_number(round(max_health))
		)


func kill() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	var gold_dropped: float = randi_range(gold_range[0], gold_range[1])
	
	Player.improve_gold(gold_dropped)
	World.level += 1
	Player.update_exp(randi_range(1500, 1500))
	drop_loot()
	get_tree().call_group("loot_container", "update_label")
	get_tree().call_group("loot_container", "clear_possible_loot")
	get_tree().call_group("main_scene", "spawn_new_enemy")
	
	queue_free()


func get_item_name() -> void:
	var possible_loot: Array = []
	
	for item in drop_list:
		possible_loot.append(item.resource_path.get_file().get_basename())
	
	get_tree().call_group("loot_container", "get_possible_loot", possible_loot)
