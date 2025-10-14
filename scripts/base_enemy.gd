extends StaticBody2D
class_name BaseEnemy

@export_category("Objetos")
@export var enemy_name_label: Label
@export var progress_bar: TextureProgressBar

@export_category("Variaveis")
@export var enemy_name: String
@export var max_health: int
@export var health: int
@export var gold_range: Array[int]
@export_enum("Normal", "Elite", "Mini-Boss", "Boss") var enemy_type
@export_enum(
	"Golem"
) var enemy_race


func _ready() -> void:
	increase_health()
	init_bar()
	
	#print("==============================")
	#print("TESTANDO ESCALONAMENTO DE VIDA ATÉ O LEVEL 500")
	#print("==============================")
#
	#for lvl in range(1, 501):
		#World.level = lvl
		#increase_health2()
#
	#print("==============================")
	#print("FIM DO TESTE")
	#print("==============================")


func init_bar() -> void:
	health = max_health
	
	progress_bar.max_value = max_health
	progress_bar.value = health
	progress_bar.get_node("Label").text = str(health) + " / " + str(max_health)
	
	enemy_name_label.text = enemy_name + " - Lvl " + str(World.level)


func increase_health() -> void:
	var base_health: float = 4.0
	var level: int = max(0, World.level) # segurança caso level seja negativo

	# Defina os segmentos [start, end] (inclusive) e a taxa por nível (growth_rate)
	var segments = [
		{"start": 1,   "end": 99,   "rate": 0.15},
		{"start": 100,  "end": 199,  "rate": 0.12},
		{"start": 200,  "end": 299,  "rate": 0.09},
		{"start": 300,  "end": 399,  "rate": 0.06},
		{"start": 400,  "end": 499,  "rate": 0.03},
		{"start": 500, "end": 999999, "rate": 0.01} # end grande para "infinito"
	]

	# Se level for 0, mantemos a vida no base_health
	if level <= 0:
		if not "max_health" in self:
			self.max_health = 0
		max_health = int(round(base_health))
		print("Level:", level, " | Max Health:", max_health)
		return

	# Calcula o multiplicador acumulado por segmentos (usando pow por bloco)
	var multiplier: float = 1.0
	for seg in segments:
		var seg_start: int = seg["start"]
		var seg_end: int = seg["end"]
		var rate: float = seg["rate"]

		# quantos níveis deste segmento estão dentro do level atual?
		var levels_in_seg: int = clamp(min(level, seg_end) - seg_start + 1, 0, seg_end - seg_start + 1)
		if levels_in_seg > 0:
			# cada nível multiplica por (1 + rate)
			multiplier *= pow(1.0 + rate, levels_in_seg)

	var new_max_health: float = base_health * multiplier

	# Arredonda e atribui
	if not "max_health" in self:
		self.max_health = 0
	max_health = int(round(new_max_health))

	# print("Level:", level, " | Multiplier:", multiplier, " | Max Health:", max_health)


func take_damage(value: int) -> void:
	health -= value
	update_bar()
	
	if health <= 0:
		World.level += 1
		kill()


func update_bar() -> void:
	progress_bar.value = health
	progress_bar.get_node("Label").text = str(health) + " / " + str(max_health)


func kill() -> void:
	Player.improve_gold(gold_range)
	get_tree().call_group("main_scene", "spawn_new_enemy")
	
	queue_free()
